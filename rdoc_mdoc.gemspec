lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rdoc_mdoc/version"

Gem::Specification.new do |spec|
  spec.name = "rdoc_mdoc"
  spec.version = RdocMdoc::VERSION
  spec.authors = ["Calle Erlandsson", "Mike Burns"]
  spec.email = ["calle@thoughtbot.com", "hello@thoughtbot.com"]
  spec.summary = "An mdoc(7) generator for RDoc"
  spec.homepage = "https://github.com/thoughtbot/rdoc_mdoc"
  spec.license = "MIT"
  spec.files = `git ls-files -z`.split("\x0")
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency "rdoc", "~> 4"
  spec.add_dependency "activesupport", "~> 4"
end
