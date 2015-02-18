require 'spec_helper'
require 'nz_parliament_debates_scraper/metadata'

module NZParliamentDebatesScraper
  RSpec.describe Metadata do
    subject { Metadata }
    let(:attrs) { {} }

    it 'takes a hash' do
      expect(subject.new(attrs)).to_not raise_error
    end
  end

end
