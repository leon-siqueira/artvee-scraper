# rubocop:disable Lint/MixedRegexpCaptureTypes
# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'
require_relative 'card'

class ArtveeScraper
  BASE_URL = 'https://artvee.com/'
  @arts = []
  @doc = Nokogiri::HTML(URI.open(BASE_URL))

  class << self
    def scrape
      populate_arts
      @arts
    end

    private

    def populate_arts
      @doc.search('.product-grid-item.product.woodmart-hover-tiled').each do |obj|
        @arts << art_hash(Card.new(obj))
      end
    end

    def art_hash(card)
      {
        img_url: card.img_url,
        title: card.title,
        date: card.date,
        artist: card.artist,
        artist_details: card.artist_details,
        tag: card.tag
      }
    end

    # def request_doc
    #   url = URI.parse(BASE_URL)
    #   http = Net::HTTP.new(url.host, url.port)
    #   http.use_ssl = (url.scheme == 'https')
    #   request = Net::HTTP::Get.new(url.path)
    #   response = http.request(request)
    #   response.code.to_i == 200 ? response.body : nil
    # end
  end
end
