# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nz_parliament_debates_scraper/version'

Gem::Specification.new do |spec|
  spec.name          = 'nz_parliament_debates_scraper'
  spec.version       = NZParliamentDebatesScraper::VERSION
  spec.authors       = ['Caleb']
  spec.email         = ['caleb.tutty@nzherald.co.nz']
  spec.summary       = %q{NZ Parliament website scraper}
  spec.description   = %q{Scrapes the NZ Parliament website HTML for Hansard Debates }
  spec.homepage      = 'http://github.com/nzherald/nz-parliament-debates-scraper'
  spec.license       = 'MIT'
3
  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.1.0'
  spec.add_development_dependency 'vcr', '~> 2.9.3'

  spec.add_runtime_dependency 'capybara', '~> 2.4.4'
  spec.add_runtime_dependency 'capybara-mechanize', '~> 1.4.0'
end
