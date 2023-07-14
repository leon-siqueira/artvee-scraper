# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'artvee_scraper'
  s.version     = '0.2.0'
  s.summary     = 'Get art data from artvee.com'
  s.description = 'A gem that gets titles, dates, artist, image URLs, etc. and returns as a Hash'
  s.authors     = ['Leon Siqueira']
  s.email       = 'leon.siqueir4@gmail.com'
  s.files       = Dir['lib/**/*.rb']
  s.required_ruby_version = '>= 3.1'
  s.homepage =
    'https://github.com/leon-siqueira/artvee-scraper'
  s.license = 'MIT'
end
