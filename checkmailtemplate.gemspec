# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'checkmailtemplate/version'

Gem::Specification.new do |spec|
  spec.name          = 'checkmailtemplate'
  spec.version       = Checkmailtemplate::VERSION
  spec.authors       = ['katoy']
  spec.email         = ['youichikato@gmail.com']
  spec.summary       = %q(Check syntax for sms-mail-template. )
  spec.description   = %q(Commandline tool for sms-mail-template. )
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'thor', '~>0.19.0'
  spec.add_development_dependency 'racc', '~>1.4.11'
  spec.add_development_dependency 'colorize', '~>0.7.2'
  # spec.add_development_dependency 'charlock_holmes', '~>0.7.1'
  spec.add_development_dependency 'charlock_holmes_bundle_icu', '~>0.6.9.2'

end
