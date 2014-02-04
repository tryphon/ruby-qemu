module QEMU
  class Image

    attr_accessor :file, :size, :format, :options

    def initialize(file, options = {})
      self.file = file
      options = { :format => self.class.file_format(file) }.merge options
      options.each { |k,v| send "#{k}=", v }
    end

    def self.file_format(file)
      case `file #{file}`
      when /qcow/
        "qcow2"
      when /x86 boot sector/
        "raw"
      else
        QEMU.logger.info "Unknown file format : #{file}"
        "raw"
      end
    end

    def options_arguments
      if options
        options_value = options.map { |k,v| "#{k}=#{v}" }.join(",")
        "-o #{options_value}"
      end
    end

    def create
      QEMU.sh! "qemu-img create -f #{format} #{options_arguments} #{file} #{size}"
    end

    def self.output_file(file, format)
      unless file.to_s.end_with? ".#{format}"
        "#{file}.#{format}"
      else
        file
      end
    end

    def convert(format, output_file = nil)
      output_file ||= self.class.output_file file, format
      unless self.format.to_s == format.to_s
        QEMU.sh! "qemu-img convert -O #{format} #{file} #{output_file}"
      end
      output_file
    end

  end
end
