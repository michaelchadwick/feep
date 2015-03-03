# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "feep/version"

Gem::Specification.new do |spec|
  spec.name            = 'feep'
  spec.version         = Feep::VERSION
  spec.platform        = Gem::Platform::RUBY
  spec.authors         = ["Michael Chadwick"]
  spec.email           = 'mike@codana.me'
  spec.homepage        = "http://rubygemspec.org/gems/feep"
  spec.summary         = %q{Make your computer feep with Ruby}
  spec.description     = %q{Use Ruby to make your computer beep at a certain frequency for a certain duration. Do it for fun, or add it to other programs for easy alert sounds.}

  spec.files           = `git ls-files`.split("\n")
  spec.test_files      = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.executables     = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  spec.require_paths   = ["lib"]
  spec.license         = 'MIT'
  
  spec.add_runtime_dependency 'wavefile', '= 0.6.0'
  spec.add_runtime_dependency 'os', '~> 0.9', '>= 0.9.6'
  
  spec.add_development_dependency 'pry-byebug', '~> 3.0'
  spec.add_development_dependency 'bundler', '~> 1.8'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 0'
end