
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "net/address/version"

Gem::Specification.new do |spec|
  spec.name          = "net-address"
  spec.version       = Net::Address::VERSION
  spec.authors       = ["Piotr Wojcieszonek"]
  spec.email         = ["piotr@wojcieszonek.pl"]

  spec.summary       = %q{Ruby library for network addresses}
  spec.description   = %q{Net::Address is a Ruby library designed to make manipulation of network addresses such as MAC, IPv4, Netmask.}
  spec.homepage      = "https://github.com/pwojcieszonek/net-address"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

  spec.required_ruby_version = '>= 3.0.0'
end
