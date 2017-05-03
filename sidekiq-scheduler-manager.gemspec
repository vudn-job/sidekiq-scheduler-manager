# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sidekiq/scheduler/manager/version'

Gem::Specification.new do |spec|
  spec.name          = "sidekiq-scheduler-manager"
  spec.version       = Sidekiq::Scheduler::Manager::VERSION
  spec.authors       = ["vudn-job"]
  spec.email         = ["vudn.job@gmail.com"]

  spec.summary       = %q{sidekiq scheduler manager.}
  spec.description   = %q{sidekiq scheduler manager.}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency 'hashie',          '~> 3.4'
  spec.add_dependency 'sidekiq',         '>= 3'
  spec.add_dependency 'redis',           '~> 3'
  spec.add_dependency 'rufus-scheduler', '~> 3.1.8'
  spec.add_dependency 'tilt',            '>= 1.4.0'

  spec.add_development_dependency 'timecop',                 '~> 0'
  spec.add_development_dependency 'mocha',                   '~> 0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'mock_redis',              '~> 0'
  spec.add_development_dependency 'simplecov',               '~> 0'
  spec.add_development_dependency 'byebug'

  if RUBY_VERSION >= '2.2.2'
    spec.add_development_dependency 'activejob'
  else
    spec.add_development_dependency 'activejob', '< 5'
  end

  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'rack-test'
  spec.add_development_dependency 'sinatra'
end
