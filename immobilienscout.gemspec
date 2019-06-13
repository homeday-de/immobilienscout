Gem::Specification.new do |s|
  s.name         = 'immobilienscout'
  s.version      = '0.0.1'
  s.date         = '2019-03-11'
  s.summary      = 'A ruby gem to handle Immobilienscout API'
  s.description  = 'This gem provides HTTP endpoints to connect your app with Immobilienscout API'
  s.authors      = ['Angela Guette', 'Wiebke Frey', 'Laura Garcia']
  s.email        = 'backend-team@homeday.de'
  s.files        = Dir.glob('lib/**/*') + ['README.md']
  s.homepage     = 'https://github.com/homeday-de/immobilienscout'
  s.license      = 'MIT'
  s.require_path = 'lib'
  s.add_dependency 'json'
  s.add_dependency 'multipart-post'
  s.add_dependency 'activesupport'
  s.add_dependency 'webmock'
end
