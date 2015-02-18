require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |t|
    t.verbose = false
end

desc 'Runs the scrapers'
task :scrape do
    NZMPsPopolo.run
end

task default: :spec
