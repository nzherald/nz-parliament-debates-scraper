require 'logger'

module NZParliamentDebatesScraper
  class Scraper
    include Capybara::DSL
    attr_reader :debates, :logger

    DEBATE_URL = "#{BASE_URL}/en-nz/pb/debates/debates?Criteria.ViewAll=1"

    def initialize(logger = Logger.new(STDOUT))
      @logger = logger
      Capybara.app_host = 'http://www.parliament.nz'
      Capybara.default_driver = :mechanize
      Capybara.app = true
    end

    def run
      load_url DEBATE_URL
      debate_links = all('.listing tbody tr a').to_a
      debate_links.shift # first link is "Next"
      @debates = debate_links.map { |link| Debate.from_link(link) }
      debates.each { |debate| debate.metadata = extract_cms_metadata(debate) }
      debates.each { |debate| extract_debate_content(debate) }
    end

    def extract_cms_metadata(debate)
      load_url debate.metadata_url
      keys = all('.copy dl dt').map(&:text)
      values = all('.copy dl dd').map(&:text)
      Hash[keys.zip(values)]
    end

    def extract_debate_content(debate)
      load_url debate.url
      extract_html_metatag(debate)
      title = extract_document_title
      reference = extract_document_reference
      document_debate_element = extract_document_debate_element
      css_class = document_debate_element[:class]
      speeches = extract_document_speeches(document_debate_element)
      { title: title, reference: reference, speeches: speeches, css_class: css_class }
    end

    private

    def extract_html_metatag(debate)
      meta_tags = all('meta', visible: false).map { |m| Hash[[m.native.values]] }
      meta_tags.reduce({}, :merge)

      dc_meta_tags = meta_tags.select {|key, value| key =~ /^DC/ }
      dc_meta_tags.each { |key, value| dc_meta_tags[key.sub(/^DC\./, '')] = dc_meta_tags.delete(key) }
      # TODO:
      # DCMetadata.new(dc_meta_tags)

      nzgls_meta_tags = meta_tags.select {|key, value| key =~ /^NZGLS/ }
      nzgls_meta_tags.each { |key, value| nzgls_meta_tags[key.sub(/^NZGLS\./, '')] = nzgls_meta_tags.delete(key) }
      # TODO:
      # NZGLSMetadata.new(nzgls_meta_tags)
    end

    def load_url(url)
      logger.info "Visiting #{url}"
      visit URL.escape url
    end

    def extract_document_title
      find('#mainContent #content .copy .section a[name="DocumentTitle"] + h1').text
    end

    def extract_document_reference
      find('#mainContent #content .copy .section a[name="DocumentReference"] + p').text
    end

    def extract_document_debate_element
      find('#mainContent #content .copy .section a[name="DocumentReference"] + p + div')
    end

    def extract_document_speeches(el)
      el.all('div.Speech')
    end

    def question_time_urls
      PARLIAMENTS.map do |parliament|
        "#{BASE_URL}/en-nz/pb/business/qoa?Criteria.Parliament=#{parliament}&Criteria.ViewAll=1"
      end
    end
  end
end
