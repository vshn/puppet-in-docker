metadata :name        => 'git',
         :description => 'Git service for MCollective',
         :author      => 'Tobias Brunner',
         :license     => 'BSD-3-Clause',
         :version     => '1.0',
         :url         => 'https://github.com/vshn/puppet-in-docker/blob/master/r10k/README.md',
         :timeout     => 60

action 'clon', :description => 'Clones a Git repository' do
    input :repo,
          :prompt      => 'Repository',
          :description => 'URL of the repository to clone',
          :type        => :string,
          :validation  => '.*',
          :optional    => false,
          :maxlength   => 1024

    input :path,
          :prompt      => 'Path',
          :description => 'Path to clone the repo to',
          :type        => :string,
          :validation  => '.*',
          :optional    => false,
          :maxlength   => 1024

    output :msg,
           :description => 'Git message',
           :display_as  => 'Message',
           :default     => ''
end

# action 'pull'
# action 'reset'
# action 'checkout'
