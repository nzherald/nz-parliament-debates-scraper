require 'bundler'
Bundler.require

require 'capybara/mechanize'

module ParliamentScraper
  PARLIAMENTS = (47..51).to_a
  BASE_URL = 'http://www.parliament.nz'

  def self.run
    Scraper.new.run
  end

  class Debate
    attr_reader :name, :url, :metadata_url, :metadata

    def initialize(name, url, metadata_url)
      @name, @url, @metadata_url = name, url, metadata_url
    end

    def metadata=(item)
      case item
      when Hash then @metadata = Metadata.new(item)
      else @metadata = item
      end
    end

    def self.from_link(link)
      name, href = link.text, link[:href]
      document_id = href.match(/^\/en-nz\/pb\/debates\/debates\/(.+)\//)[1]
      new(name, BASE_URL + href, BASE_URL + '/en-nz/Document/' + document_id + '/Metadata')
    end
  end

  class Metadata
    attr_reader :short_title, :date, :business_unit, :content_provider,
                :id, :type, :parliament_number, :ref, :session, :volume,
                :week, :status, :language

    def initialize(options)
      @short_title = options['Short title']
      @date = Date.parse(options['Date'])
      @business_unit = options['Business Unit']
      @content_provider = options['Content Provider']
      @id = options['Document ID']
      @type = options['Document Type']
      @parliament_number = options['Parliament #']
      @ref, @session, @volume, @week = options['Ref'], parse_ref(options['Ref'])
      @status = options['Status']
      @language = options['Language']
    end

    private

    def parse_ref(ref)
      ref.split(';').map { |s| s.match(/\d+/)[0].to_i }
    end
  end

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
