lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "colissimo/version"

Gem::Specification.new do |spec|
  spec.name = "colissimo_AIO"
  spec.version = Colissimo::VERSION
  spec.authors = ["wilrib"]
  spec.email = ["willy91330@gmail.com"]

  spec.summary = %q{Write a short summary, because RubyGems requires one.}
  spec.description = %q{Generate Colissimo label for France in DPL/ZPL/PDF format (Colissimo webservice account required)
Generate Bordereau
Return all informations about a Relay Point.
}
  spec.homepage = "https://github.com/wilrib/colissimo_AIO"

  #spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  #spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/wilrib/colissimo_AIO"
  #spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency 'savon', '~> 2.12.0'
end
