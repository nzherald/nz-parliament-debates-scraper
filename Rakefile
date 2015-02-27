require 'bundler'
Bundler.require

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

lib = File.expand_path('./lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nz_parliament_debates_scraper'

RSpec::Core::RakeTask.new(:spec) do |t|
    t.verbose = false
end

desc 'Runs the scrapers'
task :scrape do
    NZParliamentDebatesScraper.run
end

task default: :spec
