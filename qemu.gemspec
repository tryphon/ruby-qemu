# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'qemu/version'

Gem::Specification.new do |spec|
  spec.name          = "qemu"
  spec.version       = QEMU::VERSION
  spec.authors       = ["Alban Peignier", "Florent Peyraud"]
  spec.email         = ["alban@tryphon.eu", "florent@tryphon.eu"]
  spec.description   = %q{Create QEMU command lines, start and stop daemon, send monitor commands to a qemu instances, create or convert QEMU disks, etc .. in Ruby}
  spec.summary       = %q{Manage QEMU from Ruby}
  spec.homepage      = "http://projects.tryphon.eu/projects/ruby-qemu"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "rdoc"

  spec.add_runtime_dependency "daemons"
end
