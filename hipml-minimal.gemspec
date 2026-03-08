# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "hipml-minimal"
  spec.version       = "1.0.0"
  spec.authors       = ["Paul Lambert"]
  spec.email         = ["paul.lambert@linux.com"]

  spec.summary       = "A minimal serif Jekyll theme."
  spec.homepage      = "https://github.com/hipml/hipml.github.io"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").select { |f| f.match(%r!^(assets|_layouts|_includes|_sass|LICENSE|README|_config\.yml)!i) }

  spec.add_runtime_dependency "jekyll", ">= 4.0"
  spec.add_runtime_dependency "jekyll-feed"
  spec.add_runtime_dependency "jekyll-seo-tag"
  spec.add_runtime_dependency "jektex"

  spec.required_ruby_version = '>= 3.4'
end
