# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'immobilienscout/version'

# rubocop:disable Metrics/BlockLength
Gem::Specification.new do |spec|
  spec.name          = 'immobilienscout'
  spec.version       = Immobilienscout::VERSION
  spec.authors       = ['Homeday GmbH']
  spec.email         = ['backend-team@homeday.de']

  spec.summary       = 'A ruby gem to handle Immobilienscout API'
  spec.description   = 'This gem provides HTTP client to connect your app with Immobilienscout API'
  spec.homepage      = 'https://github.com/homeday-de/immobilienscout'
  spec.license       = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/homeday-de/immobilienscout'
  spec.metadata['changelog_uri'] = 'https://github.com/homeday-de/immobilienscout/blob/master/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport'
  spec.add_dependency 'json'
  spec.add_dependency 'multipart-post'
  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'byebug', '~> 9.0'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency('rubocop', '~> 0.70')
  spec.add_development_dependency('rubocop-rspec')
  spec.add_development_dependency 'timecop', '~> 0.8.1'
  spec.add_development_dependency 'vcr', '~> 5.0'
  spec.add_development_dependency 'webmock', '~> 3.6'
end
# rubocop:enable Metrics/BlockLength
