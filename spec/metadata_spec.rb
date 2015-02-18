require 'spec_helper'
require 'nz_parliament_debates_scraper/metadata'

module NZParliamentDebatesScraper
  RSpec.describe Metadata do
    subject { Metadata }
    let(:attrs) do
      {
        'Date' => '18-Feb-2015',
        'Business Unit' => 'Parliamentary Library',
        'Content Provider' => 'Labour Party',
        'Document ID' => '51MP2871',
        'Document Type' => 'MP',
        'MP' => 'Chris Hipkins',
        'Parliament #' => '51',
        'Language' => 'en-NZ',
        'Priority' => '500'
      }
    end

    it 'takes a hash' do
      expect{ subject.new(attrs) }.to_not raise_error
    end
  end

end
