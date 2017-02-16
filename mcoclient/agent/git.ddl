metadata :name        => 'git',
         :description => 'Git service for MCollective',
         :author      => 'Tobias Brunner',
         :license     => 'BSD-3-Clause',
         :version     => '1.0',
         :url         => 'https://github.com/vshn/puppet-in-docker/blob/master/r10k/README.md',
         :timeout     => 60

action 'cln', :description => 'Clones a Git repository' do
    display :always

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

action 'run', :description => 'Runs a Git command in PATH' do
    display :always

    input :path,
          :prompt      => 'Path',
          :description => 'Path to the Git repo',
          :type        => :string,
          :validation  => '.*',
          :optional    => false,
          :maxlength   => 1024

    input :command,
          :prompt      => 'Git command',
          :description => 'Git command to run',
          :type        => :list,
          :list        => ['pull', 'reset', 'checkout'],
          :optional    => false

    input :arg,
          :prompt      => 'Git command arguments',
          :description => 'Arguments to pass to the Git command',
          :type        => :string,
          :validation  => '.*',
          :optional    => false,
          :maxlength   => 90

    output :msg,
           :description => 'Git message',
           :display_as  => 'Git message',
           :default     => ''

    output :out,
           :description => 'Git message status',
           :display_as  => 'Git status',
           :default     => ''
end

action 'gws', :description => 'Runs the gws tool' do
    display :always

    input :path,
          :prompt      => 'Path',
          :description => 'Path to the Git repo',
          :type        => :string,
          :validation  => '.*',
          :optional    => false,
          :maxlength   => 1024

    input :command,
          :prompt      => 'GWS command',
          :description => 'GWS command to run',
          :type        => :list,
          :list        => ['update', 'ff', 'check'],
          :optional    => false

    output :msg,
           :description => 'Git message',
           :display_as  => 'Message',
           :default     => ''
end
