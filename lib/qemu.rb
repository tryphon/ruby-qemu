
module QEMU
  def self.sh!(command)
    logger.debug "Execute '#{command}'"
    system command or raise "Command failed: '#{command}'"
  end
end

require 'qemu/version'
require 'qemu/logger'

require 'qemu/image'
require 'qemu/daemon'
require 'qemu/command'
require 'qemu/monitor'
