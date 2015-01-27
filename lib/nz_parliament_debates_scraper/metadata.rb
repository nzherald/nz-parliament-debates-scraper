module NZParliamentDebatesScraper
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
      @ref, @session, @volume, @week = options['Ref'], parse_ref(options['Ref']) if options['Ref']
      @status = options['Status']
      @language = options['Language']
    end

    private

    def parse_ref(ref)
      ref.split(';').map { |s| s.match(/\d+/)[0].to_i }
    end
  end
end
