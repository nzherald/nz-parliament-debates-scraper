require 'nz_parliament_debates_scraper/version'
require 'capybara/mechanize'

module NZParliamentDebatesScraper
  PARLIAMENTS = (47..51).to_a
  BASE_URL = 'http://www.parliament.nz'

  def self.run
    Scraper.new.run
  end
end

require 'nz_parliament_debates_scraper/metadata'
require 'nz_parliament_debates_scraper/debate'
require 'nz_parliament_debates_scraper/scraper'
