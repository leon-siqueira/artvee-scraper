require 'net/http'
require 'uri'
require 'webmock/rspec'
require_relative '../lib/http_fetcher'

RSpec.describe HttpFetcher do
  let(:resource) { described_class }
  let(:valid_url) { 'https://example.com' }
  let(:invalid_url) { 'https://example.com/nonexistent' }

  context 'when the HTTP request is successful (status code 200)' do
    it 'returns the response body' do
      body = 'Response body'
      stub_request(:get, valid_url).to_return(status: 200, body:)

      expect(resource.call(valid_url)).to eq(body)
    end
  end

  context 'when the HTTP request fails' do
    it 'returns nil' do
      stub_request(:get, invalid_url).to_return(status: 404)

      expect(resource.call(invalid_url)).to be_nil
    end
  end
end
