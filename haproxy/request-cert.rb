#!/usr/bin/env ruby
require "net/http"
require "resolv"
require "fileutils"

def ssl_dir
  "/usr/local/etc/haproxy/ssl"
end

def puppetca_server
  {:target => ARGV[0], :port => "8140"}
end

def certname
  ARGV[1]
end

def ca_path
  File.join(ssl_dir, "certs", "ca.pem")
end

def crl_path
  File.join(ssl_dir, "crl.pem")
end

def csr_path
  File.join(ssl_dir, "certificate_requests", "%s.pem" % certname)
end

def client_private_key
  File.join(ssl_dir, "private_keys", "%s.pem" % certname)
end

def client_public_cert
  File.join(ssl_dir, "certs", "%s.pem" % certname)
end

def has_ca?
  File.exist?(ca_path)
end

def has_crl?
  File.exist?(crl_path)
end

def has_client_private_key?
  File.exist?(client_private_key)
end

def has_client_public_cert?
  File.exist?(client_public_cert)
end

def has_csr?
  File.exist?(csr_path)
end

def waiting_for_cert?
  !has_client_public_cert? && has_client_private_key?
end

def make_ssl_dirs
  FileUtils.mkdir_p(ssl_dir, :mode => 0o0771)

  ["certificate_requests", "certs", "public_keys"].each do |dir|
    FileUtils.mkdir_p(File.join(ssl_dir, dir), :mode => 0o0755)
  end

  ["private_keys", "private"].each do |dir|
    FileUtils.mkdir_p(File.join(ssl_dir, dir), :mode => 0o0750)
  end
end

# Create a Net::HTTP instance optionally set up with the Puppet certs
#
# If the client_private_key and client_public_cert both exist they will
# be used to validate the connection
#
# If the ca_path exist it will be used and full verification will be enabled
#
# @param server [Hash] as returned by {#try_srv}
# @return [Net::HTTP]
def https(server)
  http = Net::HTTP.new(server[:target], server[:port])

  http.use_ssl = true

  if has_client_private_key? && has_client_public_cert?
    http.cert = OpenSSL::X509::Certificate.new(File.read(client_public_cert))
    http.key = OpenSSL::PKey::RSA.new(File.read(client_private_key))
  end

  if has_ca?
    http.ca_file = ca_path
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
  else
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  end

  http
end

def fetch_ca
  return true if has_ca?

  server = puppetca_server

  req = Net::HTTP::Get.new("/puppet-ca/v1/certificate/ca", "Content-Type" => "text/plain")
  resp, _ = https(server).request(req)

  if resp.code == "200"
    File.open(ca_path, "w", 0o0644) {|f| f.write(resp.body)}
  else
    raise("----> Failed to fetch CA from %s:%s: %s: %s" % [server[:target], server[:port], resp.code, resp.message])
  end

  has_ca?
end

def fetch_crl
  server = puppetca_server

  req = Net::HTTP::Get.new("/puppet-ca/v1/certificate_revocation_list/ca", "Content-Type" => "text/plain")
  resp, _ = https(server).request(req)

  if resp.code == "200"
    File.open(crl_path, "w", 0o0644) {|f| f.write(resp.body)}
  else
    raise("----> Failed to fetch CRL from %s:%s: %s: %s" % [server[:target], server[:port], resp.code, resp.message])
  end

  has_crl?
end

def request_cert
  key = write_key
  csr = write_csr(key)

  server = puppetca_server

  req = Net::HTTP::Put.new("/puppet-ca/v1/certificate_request/%s?environment=production" % certname, "Content-Type" => "text/plain")
  req.body = csr
  resp, _ = https(server).request(req)

  if resp.code == "200"
    true
  else
    raise("----> Failed to request certificate from %s:%s: %s: %s: %s" % [server[:target], server[:port], resp.code, resp.message, resp.body])
  end
end

def create_rsa_key(bits)
  OpenSSL::PKey::RSA.new(bits)
end

def write_key
  if has_client_private_key?
    raise("----> Refusing to overwrite existing key in %s" % client_private_key)
  end

  key = create_rsa_key(4096)
  File.open(client_private_key, "w", 0o0640) {|f| f.write(key.to_pem)}

  key
end

def write_csr(key)
  raise("----> Refusing to overwrite existing CSR in %s" % csr_path) if has_csr?

  csr = create_csr(certname, "mcollective", key)

  File.open(csr_path, "w", 0o0644) {|f| f.write(csr.to_pem)}

  csr.to_pem
end

def create_csr(cn, ou, key)
  # TODO use PSK "oid == "challengePassword""
  csr = OpenSSL::X509::Request.new
  csr.version = 0
  csr.public_key = key.public_key
  csr.subject = OpenSSL::X509::Name.new(
    [
      ["CN", cn, OpenSSL::ASN1::UTF8STRING],
      ["OU", ou, OpenSSL::ASN1::UTF8STRING]
    ]
  )
  csr.sign(key, OpenSSL::Digest::SHA1.new)

  csr
end

def attempt_fetch_cert
  return true if has_client_public_cert?

  req = Net::HTTP::Get.new("/puppet-ca/v1/certificate/%s" % certname, "Accept" => "text/plain")
  resp, _ = https(puppetca_server).request(req)

  if resp.code == "200"
    File.open(client_public_cert, "w", 0o0644) {|f| f.write(resp.body)}
    true
  else
    false
  end
end

### Main

$stdout.sync = true

puts("----> Creating SSL dirs")
make_ssl_dirs

puts("----> Requesting CA from '%s'" % ARGV[0])
fetch_ca

puts("----> Requesting CRL from '%s'" % ARGV[0])
fetch_crl

if waiting_for_cert?
  puts("----> Certificate %s has already been requested, attempting to retrieve it" % certname)
else
  puts("----> Requesting certificate for '%s' from '%s'" % [certname, ARGV[0]])
  request_cert
end

puts("----> Waiting up to 240 seconds for it to be signed")
24.times do |time|
  print "----> Attempting to download certificate %s: %d / 24\r" % [certname, time]
  break if attempt_fetch_cert
  sleep 10
end

unless has_client_public_cert?
  raise("----> Could not fetch the certificate after 240 seconds, please ensure it gets signed and rerun this command")
end

puts("----> Certificate %s has been stored in %s" % [certname, ssl_dir])
