module NZParliamentDebatesScraper
  class DCMetadata
    attr_reader :title, :date, :creator, :publisher, :subject, :language,
                :channel_guid, :committee_name, :custom

    def initialize(options)
      @short_title = options['Title']
      @date = Date.parse(options['Date'])
      @creator = options['Creator']
      @publisher = options['Publisher']
      @subject = options['Subject']
      @language = options['Language']
      @channel_guid = options['ChannelGuid']
      @committee_name = options['CommitteeName']
      @custom = options['Custom']
    end

  end
end
