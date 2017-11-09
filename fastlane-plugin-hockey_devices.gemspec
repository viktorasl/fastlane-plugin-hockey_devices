# coding: utf-8

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/hockey_devices/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-hockey_devices'
  spec.version       = Fastlane::HockeyDevices::VERSION
  spec.author        = 'Viktoras Laukevičius'
  spec.email         = 'viktoras.laukevicius@yahoo.com'

  spec.summary       = 'Retrieves a list of devices from Hockey which can then be used with Match'
  spec.homepage      = "https://github.com/viktorasl/fastlane-plugin-hockey_devices"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  # Don't add a dependency to fastlane or fastlane_re
  # since this would cause a circular dependency

  spec.add_dependency 'faraday'
  spec.add_dependency 'faraday_middleware'

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec_junit_formatter'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop', '0.49.1'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'fastlane', '>= 2.64.0'
end
