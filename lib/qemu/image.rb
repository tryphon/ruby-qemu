module QEMU
  class Image

    attr_accessor :file, :size, :format

    def initialize(file, options = {})
      self.file = file
      options = options.merge :format => "raw"
      options.each { |k,v| send "#{k}=", v }
    end

    def create
      system "qemu-img create -f #{format} #{file} #{size}"
    end

    def convert(format, output_file = nil)
      output_file ||= "#{file}.#{format}"
      system "qemu-img convert -O #{format} #{file} #{output_file}" and output_file
    end

  end
end
