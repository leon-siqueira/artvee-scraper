# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name          = 'artvee_scraper'
  s.version       = '0.2.1'
  s.authors       = ['Leon Siqueira']
  s.email         = 'leon.siqueir4@gmail.com'

  s.summary       = 'Get art data from artvee.com'
  s.description   = 'A gem that gets titles, dates, artist, image URLs, etc. and returns as a Hash'
  s.homepage      = 'https://github.com/leon-siqueira/artvee-scraper'
  s.license       = 'MIT'

  s.files         = Dir['lib/**/*', 'README.md', 'Gemfile', 'LICENSE']
  s.require_paths = Dir['lib']
  s.required_ruby_version = '>= 3.1'

  s.add_dependency 'net-http', '~> 0.3.2'
  s.add_dependency 'nokogiri', '~> 1.15', '>= 1.15.2'
end
