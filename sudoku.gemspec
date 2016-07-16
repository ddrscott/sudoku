# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sudoku/version'

Gem::Specification.new do |spec|
  spec.name          = "sudoku"
  spec.version       = Sudoku::VERSION
  spec.authors       = ["Scott Pierce"]
  spec.email         = ["scott.pierce@centro.net"]

  spec.summary       = %q{Sudoku solver}
  spec.homepage      = "https://github.com/ddrscott/sudoku"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
