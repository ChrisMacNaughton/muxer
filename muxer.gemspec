# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'muxer/version'

Gem::Specification.new do |spec|
  spec.name          = "muxer"
  spec.version       = Muxer::VERSION
  spec.authors       = ["Chris MacNaughton"]
  spec.email         = ["chmacnaughton@gmail.com"]
  spec.summary       = %q{Muxer is a web request multiplexer}
  spec.description   = %q{Muxer allows timeouts to be set for each request made in addition to a global timeout for a set of requests.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "vcr"
end
