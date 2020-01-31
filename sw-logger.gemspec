require_relative "lib/sw/logger/version"

Gem::Specification.new do |spec|
  spec.name          = "sw-logger"
  spec.version       = Sw::Logger::VERSION
  spec.authors       = ["Kai Kuchenbecker"]
  spec.email         = ["dev@sayway.com"]

  spec.summary       = "Context enriched logging with plain and json format."
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/say-way/sw-logger"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"]    = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`
      .split("\x0")
      .reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ["lib"]
end
