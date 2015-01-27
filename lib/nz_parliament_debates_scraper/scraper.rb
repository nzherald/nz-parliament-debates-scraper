module NZParliamentDebatesScraper
  class Scraper
    include Capybara::DSL
    attr_reader :debates

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
      @debates = debate_links.map { |link| Debate.from_link(link) }
      debates.each { |debate| debate.metadata = extract_debate_metadata(debate) }
    end

    def extract_debate_metadata(debate)
      visit debate.metadata_url
      keys = all('.copy dl dt').map(&:text)
      values = all('.copy dl dd').map(&:text)
      Hash[keys.zip(values)]
    end

    private

    def question_time_urls
      PARLIAMENTS.map do |parliament|
        "#{BASE_URL}/en-nz/pb/business/qoa?Criteria.Parliament=#{parliament}&Criteria.ViewAll=1"
      end
    end
  end
end
