metadata :name        => 'r10kcli',
         :description => 'r10k cli agent for MCollective',
         :author      => 'Marco Fretz',
         :license     => 'BSD-3-Clause',
         :version     => '1.0',
         :url         => 'https://github.com/vshn/puppet-in-docker/blob/master/r10k/README.md',
         :timeout     => 180

action 'deploy_module', :description => 'Deploys a Module' do
    display :always

    input :module,
          :prompt      => 'Modulename',
          :description => 'The name of the Module',
          :type        => :string,
          :validation  => '.*',
          :optional    => false,
          :maxlength   => 256

    input :args,
          :prompt      => 'Arguments',
          :description => 'Any r10k arguments to be appended',
          :type        => :string,
          :validation  => '.*',
          :optional    => false,
          :maxlength   => 1024,
          :default     => '-v INFO'
end
action 'deploy', :description => 'Deploys a environment from Puppetfile' do
    display :always

    input :environment,
          :prompt      => 'Environment',
          :description => 'The name of the Environment',
          :type        => :string,
          :validation  => '.*',
          :optional    => false,
          :maxlength   => 256

    input :args,
          :prompt      => 'Arguments',
          :description => 'Any r10k arguments to be appended',
          :type        => :string,
          :validation  => '.*',
          :optional    => false,
          :maxlength   => 1024,
          :default     => '-v INFO'
end
