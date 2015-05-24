# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'html/pipeline/abbr/version'

Gem::Specification.new do |spec|
  spec.name          = "html-pipeline-abbr"
  spec.version       = Html::Pipeline::Abbr::VERSION
  spec.authors       = ["Keenan Brock"]
  spec.email         = ["keenan@thebrocks.net"]

  spec.summary       = %q{html-pipeline filter to add or replace abbreviations}
  spec.description   = %q{abbr tags are part of the html spec. They are currently
                          not part of markdown but potentially part of common mark.
                          In the mean time this adds abbr tags}
  spec.homepage      = "http://github.com/kbrock/html-pipeline-abbr/"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
#    spec.metadata['allowed_push_host'] = ""
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_dependency "html-pipeline", ">= 1.0"
  spec.add_dependency "nokogiri", [">= 1.4", "<= 1.6.5"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.3"
  spec.add_development_dependency "yard", "~> 0.8"
end
