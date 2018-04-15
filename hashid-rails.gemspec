# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "hashid/rails/version"

Gem::Specification.new do |spec|
  spec.name          = "hashid-rails"
  spec.version       = Hashid::Rails::VERSION
  spec.authors       = ["Justin Cypret"]
  spec.email         = ["jcypret@gmail.com"]

  spec.summary       = "Use Hashids in your Rails app models."
  spec.description   = <<-DESCRIPTION
    This gem allows you to easily use [Hashids](http://hashids.org/ruby/)
    in your Rails app. Instead of your models using sequential numbers like 1,
    2, 3, they will instead have unique short hashes like "yLA6m0oM",
    "5bAyD0LO", and "wz3MZ49l". The database will still use integers under
    the hood, so this gem can be added or removed at any time.
  DESCRIPTION
  spec.homepage      = "https://github.com/jcypret/hashid-rails"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`
                       .split("\x0")
                       .reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.4.0"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "sqlite3"

  spec.add_runtime_dependency "activerecord", ">= 4.0"
  spec.add_runtime_dependency "hashids", "~> 1.0"
end
