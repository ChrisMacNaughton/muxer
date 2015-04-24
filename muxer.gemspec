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
  spec.homepage      = "https://github.com/ChrisMacNaughton/muxer"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 1.9.3"
  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "eventmachine", "~>1.0"
  spec.add_runtime_dependency "em-http-request", "~>1.1"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~>10.4"
  spec.add_development_dependency "rspec", "~>3.2"
  spec.add_development_dependency "vcr", "~>2.9"
  spec.add_development_dependency "pry", "~>0.10"
  spec.add_development_dependency "webmock", "~>1.20"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "ruby_gntp"
  spec.add_development_dependency "codeclimate-test-reporter"
end
