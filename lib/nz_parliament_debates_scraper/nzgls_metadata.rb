module NZParliamentDebatesScraper
  class NZGLSMetadata
    attr_reader :creator, :title, :date, :publisher, :subject, :language,
                :channel_guid, :committee_name, :alternative, :id, :type

    def initialize(options)
      @creator = options['Creator']
      @subject = options['Subject']
      @title = options['Title']
      @alternative = options['Alternative']
      @type = options['Type']
      @id = options['Identifier']
      @publisher = options['Publisher']
      @date = Date.parse(options['Date'])
      @language = options['Language']
      @format = options['Format']
    end

  end
end
