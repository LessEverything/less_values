# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "less/values/version"

Gem::Specification.new do |spec|
  spec.name          = "less_values"
  spec.version       = Less::Values::VERSION
  spec.authors       = ["Eugen Minciu"]
  spec.email         = ["eugen@lesseverything.com"]

  spec.summary       = %q{Simple Ruby Value Types}
  spec.description   = %q{Less Values provides a base class for creating your own immutable value objects.}
  spec.homepage      = "https://github.com/LessEverything/less_values"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
