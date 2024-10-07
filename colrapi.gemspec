# frozen_string_literal: true

require_relative "lib/colrapi/version"

Gem::Specification.new do |s|
  s.name          = "colrapi"
  s.version       = Colrapi::VERSION
  s.authors       = ["Matt Yoder, Geoff Ower"]
  s.email         = ["diapriid@gmail.com"]

  s.summary       = "Catalog of Life Client"
  s.description   = "colrapi (a play on Kholrabi) is a low-level wrapper around the Catalog of Life API."
  s.homepage      = "https://github.com/SpeciesFileGroup/colrapi"
  s.license       = "NCSA"
  s.required_ruby_version = ">= 2.5.0"

 # s.metadata["allowed_push_host"] = "TODO: Set to 'https://mygemserver.com'"

  s.metadata["homepage_uri"] = s.homepage
  s.metadata["source_code_uri"] = "https://github.com/SpeciesFileGroup/colrapi"
  s.metadata["changelog_uri"] = "https://github.com/SpeciesFileGroup/colrapi/releases/tag/v#{s.version}"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  s.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|s|features)/}) }
  end
  s.bindir        = "exe"
  s.executables   = s.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  s.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # s.add_dependency "example-gem", "~> 1.0"

  s.add_development_dependency "bundler", "~> 2.1", ">= 2.1.4"
  s.add_development_dependency "rake", "~> 13.0", ">= 13.0.1"
  s.add_development_dependency "test-unit", "~> 3.3", ">= 3.3.6"
  s.add_development_dependency "vcr", "~> 6.0"
  s.add_development_dependency "webmock", "~> 3.18"
  s.add_development_dependency "rexml", "~> 3.3", ">= 3.3.6"

  s.add_runtime_dependency "faraday", "~> 2.2"
  s.add_runtime_dependency "faraday-follow_redirects", ">= 0.1", "< 0.4"
  s.add_runtime_dependency "multi_json", "~> 1.15"

  #  s.add_runtime_dependency "thor", "~> 1.0", ">= 1.0.1"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
