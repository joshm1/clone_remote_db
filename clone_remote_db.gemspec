# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'clone_remote_db/version'

Gem::Specification.new do |spec|
  spec.name          = "clone_remote_db"
  spec.version       = CloneRemoteDb::VERSION
  spec.authors       = ["Josh McDade"]
  spec.email         = ["josh.ncsu@gmail.com"]
  spec.summary       = %q{Helper script to dump, download, and remote a remote PostgreSQL database}
  spec.homepage      = "https://github.com/joshm1/clone_remote_db"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
