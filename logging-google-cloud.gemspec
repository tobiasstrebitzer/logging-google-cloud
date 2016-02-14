lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'logging-google-cloud/version'

Gem::Specification.new do |s|
  s.name        = "logging-google-cloud"
  s.version     = LoggingGoogleCloud::VERSION
  s.licenses    = ["BSD-3-Clause"]
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Tobias Strebitzer"]
  s.email       = ["*@magloft.com"]
  s.homepage    = "https://github.com/tobiasstrebitzer/logging-google-cloud"
  s.summary     = "Google Cloud Logging appender"
  s.description = "Google Cloud Logging appender for the logging gem"
  s.required_ruby_version = '~> 2.0'
  s.required_rubygems_version = '~> 2.5'
  s.add_runtime_dependency "logging", "~> 2.0"
  s.add_runtime_dependency "gcloud", "~> 0.6"
  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_path = 'lib'
end
