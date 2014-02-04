require "logger"

module QEMU
  def self.sh!(command)
    logger.debug "Execute '#{command}'"
    system command or raise "Command failed: '#{command}'"
  end

  @@logger = Logger.new("log/qemu.log")
  def self.logger
    @@logger
  end
  def self.logger=(logger)
    @@logger = logger
  end

end

require 'qemu/version'

require 'qemu/image'
require 'qemu/daemon'
require 'qemu/command'
require 'qemu/monitor'
