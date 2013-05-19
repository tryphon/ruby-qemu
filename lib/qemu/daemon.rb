require "daemons"

module QEMU
  class Daemon

    @@log_directory = "log"
    def self.log_directory
      @@log_directory
    end

    @@run_directory = "tmp"
    def self.run_directory
      @@run_directory
    end

    attr_accessor :command, :arguments, :name, :run_dir, :log_dir, :env

    def initialize(attributes = {})
      attributes = attributes.merge(:name => "qemu", :run_dir => self.class.run_directory, :log_dir => self.class.log_directory)
      attributes.each { |k,v| send "#{k}=", v }
    end

    def run_dir=(directory)
      @run_dir = File.expand_path(directory)
    end

    def log_dir=(directory)
      @log_dir = File.expand_path(directory)
    end

    def options
      { :app_name => name, :dir_mode => :normal, :dir => run_dir, :mode => :exec, :log_dir => log_dir, :log_output => true }
    end

    def arguments_to(command)
      [ command.to_s, "--", *arguments ]
    end

    def options_to(command)
      options.merge :ARGV => arguments_to(command)
    end

    def start
      fork do
        env.each { |k,v| ENV[k] = v } if env
        Daemons.run command, options_to(:start)
      end
    end

    def stop
      Daemons.run command, options_to(:stop)
    end

  end

end
