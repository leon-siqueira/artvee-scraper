require 'byebug'
require 'net/http'
require 'uri'
require 'webmock/rspec'
require 'nokogiri'
require_relative '../lib/artvee_scraper'

RSpec.describe ArtveeScraper do
  let(:resource) { described_class }
  let(:valid_url) { 'https://artvee.com/' }

  let(:contents) do
    [
      { src: 'https://mdl.artvee.com/ftmp/storageid1.jpg',
        title: 'Art title 1',
        date: '1945',
        artist_name: 'Artist name 1',
        details: 'Spanish, 1905 - 1970',
        tag: 'Tag 1' },
      { src: 'https://mdl.artvee.com/ftmp/storageid2.jpg',
        title: 'Art title 2',
        date: '1946',
        artist_name: 'Artist name 2',
        details: 'French, 1906 - 1991',
        tag: 'Tag 2' },
      { src: 'https://mdl.artvee.com/ftmp/storageid3.jpg',
        title: 'Art title 3',
        date: '1947',
        artist_name: 'Artist name 3',
        details: 'Swiss, 1907 - 1992',
        tag: 'Tag 3' }
    ]
  end

  context 'when the HTTP request is successful (status code 200)' do
    let(:body) do
      cards = contents.map do |content|
        "<div class='product-grid-item product woodmart-hover-tiled'><div>
        <img src='#{content[:src]}'/>
        <h3>#{content[:title]} (#{content[:date]}) </h3>
        <div class='woodmart-product-brands-links'><a>#{content[:artist_name]}</a> (#{content[:details]})</div>
        <div class='woodmart-product-cats'><a>#{content[:tag]}</a></div>
        </div></div>"
      end.join

      "<html><body>#{cards}</body></html>"
    end
    before do
      allow(HttpFetcher).to receive(:call).with(valid_url).and_return(body)
    end

    it 'returns the response body' do
      result = resource.scrape
      expect(result.class).to eq(Array)
    end
  end

  context 'when the HTTP request fails' do
    let(:body) { nil }
    before do
      allow(HttpFetcher).to receive(:call).with(valid_url).and_return(nil)
    end

    it 'returns nil' do
      result = resource.scrape
      expect(described_class.scrape).to eq([])
    end
  end
end
