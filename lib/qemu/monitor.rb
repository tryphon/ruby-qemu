require 'net/telnet'

module QEMU
  class Monitor

    attr_accessor :host, :port, :timeout

    def initialize(attributes = {})
      attributes = { :host => "localhost", :timeout => 30 }.merge(attributes)
      attributes.each { |k,v| send "#{k}=", v }
    end

    def telnet
      Net::Telnet::new "Host" => host, "Port" => port, "Timeout" => timeout, "Prompt" => /\(qemu\) /
    end

    def command(command)
      telnet.tap do |telnet|
        QEMU.logger.debug "Send monitor command '#{command}'"

        response = telnet.cmd(command)
        QEMU.logger.debug "Receive '#{response}'"

        telnet.close
      end
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

    def device_add(driver, options = {})
      command "device_add #{driver},#{options.to_command}"
    end

    def device_del(id)
      command "device_del #{id}"
    end

    def drive_add(name, options = {})
      command "drive_add #{name} #{options.to_command}"
    end

    def drive_del(name)
      command "drive_del #{name}"
    end

  end
end
