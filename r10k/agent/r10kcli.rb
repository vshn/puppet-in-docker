module MCollective
  module Agent
    class R10kcli<RPC::Agent
      action "deploy_module" do
        command = "flock --exclusive /tmp/r10k-#{request[:environment]}.lock r10k deploy module #{request[:module]} #{request[:args]}"
        Log.info("Running '#{command}'")

        reply[:status] = run(command,
                             :stdout => :out,
                             :stderr => :msg)

        if reply[:status] != 0
          reply.fail "Command failed: #{command}. Reason: \n #{reply[:msg]}", 1
        end
      end

      action "deploy" do
        command = "flock --exclusive /tmp/r10k-#{request[:environment]}.lock r10k deploy environment -p #{request[:environment]} #{request[:args]}"
        Log.info("Running '#{command}'")

        reply[:status] = run(command,
                             :stdout => :out,
                             :stderr => :msg)

        if reply[:status] != 0
          reply.fail "Command failed: #{command}. Reason: \n #{reply[:msg]}", 1
        end
      end
    end
  end
end
