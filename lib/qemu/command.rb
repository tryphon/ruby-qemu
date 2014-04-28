module QEMU
  class Command

    attr_accessor :name

    def name
      @name ||= "qemu"
    end

    attr_accessor :memory

    attr_accessor :architecture

    def architecture
      @architecture ||= :i386
    end

    attr_reader :disks
    def disks
      @disks ||= Disks.new
    end

    class Disks < Array

      def push(*args)
        super Disk.new(*args)
      end
      alias_method :<<, :push
      alias_method :add, :push

    end

    class Disk

      attr_accessor :file, :options

      def initialize(file, options = {})
        self.file = file
        self.options = { :media => "disk" }.merge options
      end

      def qemu_drive(index)
        {
          :file => File.expand_path(file),
          :index => index,
          :if => "virtio"
        }.merge(options).map { |k,v| "#{k}=#{v}" }.join(',')
      end

    end

    attr_accessor :mac_address

    attr_accessor :vde_options
    def vde_options
      @vde_options ||= { :sock => "/var/run/vde2/tap0.ctl" }
    end

    attr_accessor :vnc

    attr_accessor :monitor
    attr_accessor :telnet_port

    def telnet_port=(telnet_port)
      @telnet_port = telnet_port
      self.monitor = "telnet::#{telnet_port},server,nowait,nodelay"
    end

    def qemu_monitor
      @qemu_monitor ||= QEMU::Monitor.new :port => telnet_port if telnet_port
    end

    attr_accessor :sound_hardware
    attr_accessor :audio_driver
    def audio_driver
      @audio_driver ||= "alsa"
    end

    attr_accessor :alsa_dac_dev, :alsa_adc_dev

    def command_arguments
      [].tap do |args|
        args << "-enable-kvm"

        args << "-m" << "#{memory}m" if memory
        disks.each_with_index do |disk, index|
          args << "-drive" << disk.qemu_drive(index)
        end
        args << "-net" << "nic,macaddr=#{mac_address}"
        unless vde_options.empty?
          args << "-net" << "vde," + vde_options.map { |k,v| "#{k}=#{v}" }.join(',')
        end
        if vnc
          args << "-vnc" << vnc
        else
          args << "-nographic"
        end
        args << "-monitor" << monitor if monitor
        args << "-soundhw" << sound_hardware if sound_hardware
      end
    end

    def command_env
      {}.tap do |env|
        env["QEMU_AUDIO_DRV"] = audio_driver
        env["QEMU_ALSA_DAC_DEV"] = alsa_dac_dev if alsa_dac_dev
        env["QEMU_ALSA_ADC_DEV"] = alsa_adc_dev if alsa_adc_dev
      end
    end

    @@command_system_aliases = {
      "amd64" => "x86_64"
    }

    def command
      system = @@command_system_aliases.fetch(architecture.to_s, architecture.to_s)
      "/usr/bin/qemu-system-#{system}"
    end

    def run
      shell_env = command_env.map { |k,v| "#{k}=#{v}" }.join(' ')
      system "#{shell_env} #{command} #{command_arguments.join(' ')}"
    end

    def daemon
      @daemon ||=
        begin
          QEMU.logger.debug "Prepare daemon with '#{command_arguments}'"
          Daemon.new :command => command, :name => name, :arguments => command_arguments, :env => command_env
        end
    end

  end
end
