# frozen_string_literal: true

require 'net/http'

# Fetches the content of a given URL and returns its body only if the HTTP request receives a 200 response.
class HttpFetcher
  def self.call(url)
    uri = ::URI.parse(url)

    response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(Net::HTTP::Get.new(uri.request_uri))
    end

    response.body if response.code == '200'
  end
end
