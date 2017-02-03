module MCollective
  module Agent
    class Git<RPC::Agent
      action "clon" do
        reply[:status] = run("git clone #{request[:repo]} #{request[:path]}", :stdout => :out, :stderr => :msg)
      end
    end
  end
end
