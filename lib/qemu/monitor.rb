require 'net/telnet'

module QEMU
  class Monitor

    attr_accessor :host, :port, :timeout

    def initialize(attributes = {})
      attributes = { :host => "localhost", :timeout => 5 }.merge(attributes)
      attributes.each { |k,v| send "#{k}=", v }
    end

    def telnet
      @telnet ||= Net::Telnet::new "Host" => host, "Port" => port, "Timeout" => timeout, "Prompt" => /\(qemu\) /
    end

    def command(command)
      telnet.cmd command
    end
   
    def reset
      command "system_reset"
    end

    def savevm(name = "default")
      command "savevm #{name}"
    end

    def loadvm(name = "default")
      command "loadvm #{name}"
    end

  end
end
