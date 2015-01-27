require 'bundler'
Bundler.require

require 'capybara/mechanize'

module ParliamentScraper
  PARLIAMENTS = (47..51).to_a
  BASE_URL = 'http://www.parliament.nz'

  Debate = Struct.new(:name, :url, :metadata_url) do
    def self.from_link(link)
      name, href = link.text, link[:href]
      document_id = href.match(/^\/en-nz\/pb\/debates\/debates\/(.+)\//)[1]
      new(name, BASE_URL + href, BASE_URL + '/en-nz/Document/' + document_id + '/Metadata')
    end
  end

  def self.run
    Scraper.new.run
  end

  class Scraper
    include Capybara::DSL

    DEBATE_URL = "#{BASE_URL}/en-nz/pb/debates/debates?Criteria.ViewAll=1"

    def initialize
      Capybara.app_host = 'http://www.parliament.nz'
      Capybara.default_driver = :mechanize
      Capybara.app = true
    end

    def run
      visit DEBATE_URL
      debate_links = all('.listing tbody tr a').to_a
      debate_links.shift # first link is "Next"
      debate_links.map { |link| Debate.from_link(link) }
    end

    private

    def question_time_urls
      PARLIAMENTS.map do |parliament|
        "#{BASE_URL}/en-nz/pb/business/qoa?Criteria.Parliament=#{parliament}&Criteria.ViewAll=1"
      end
    end

  end
end
