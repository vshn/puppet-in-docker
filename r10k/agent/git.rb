module MCollective
  module Agent
    class Git<RPC::Agent

      action "cln" do
        command = "git clone #{request[:repo]} #{request[:path]}"
        Log.info("Running '#{command}'")

        reply[:status] = run("git clone #{request[:repo]} #{request[:path]}",
                             :stdout => :out,
                             :stderr => :msg)

        if reply[:status] != 0
          reply.fail "Command failed: #{command}. Reason: \n #{reply[:msg]}", 1
        end
      end

      action "run" do
        command = "git #{request[:command]} #{request[:arg]}"
        Log.info("Running '#{command}' in #{request[:path]}")

        reply[:status] = run(command,
                             :stdout => :out,
                             :stderr => :msg,
                             :cwd => request[:path])

        if reply[:status] != 0
          reply.fail "Command failed: #{command}. Reason: \n #{reply[:msg]}", 1
        end
      end

      action "gws" do
        command = "/usr/local/bin/gws #{request[:command]}"
        Log.info("Running '#{command}' in #{request[:path]}")

        reply[:status] = run(command,
                             :stdout => :out,
                             :stderr => :msg,
                             :cwd => request[:path])

        if reply[:status] != 0
          reply.fail "Command failed: #{command}. Reason: \n #{reply[:msg]}", 1
        end
      end

    end
  end
end
