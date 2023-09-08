# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'feep/version'

source_uri = 'https://github.com/michaelchadwick/feep'
rubygem_uri = 'http://rubygems.org/gems/feep'

Gem::Specification.new do |spec|
  spec.name            = 'feep'
  spec.summary         = 'Make your computer beep with Ruby'
  spec.version         = Feep::VERSION
  spec.platform        = Gem::Platform::RUBY
  spec.authors         = ['Michael Chadwick']
  spec.email           = ['mike@neb.host']
  spec.homepage        = rubygem_uri
  spec.license         = 'MIT'
  spec.description     = 'Use Ruby to make your computer beep at a certain frequency for a certain duration. Do it for fun, or add it to other programs for easy alert sounds.'

  spec.files           = `git ls-files`.split("\n")
  spec.test_files      = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.executables     = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  spec.require_paths   = ['lib']

  spec.metadata        = {
    "documentation_uri" => source_uri,
    "homepage_uri" => source_uri,
    "source_code_uri" => source_uri
  }

  ## required deps
  spec.add_runtime_dependency 'wavefile', '= 0.6.0'
  spec.add_runtime_dependency 'os', '~> 0.9', '>= 0.9.6'

  ## development deps
  spec.add_development_dependency 'pry-byebug', '~> 3.0'
  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.52.1'
end
