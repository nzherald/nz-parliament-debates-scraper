module NZParliamentDebatesScraper
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
end
