# frozen_string_literal: true

require_relative 'card'
require_relative 'http_fetcher'

# Scrapes art data from artvee.com
class ArtveeScraper
  BASE_URL = 'https://artvee.com/'
  @arts = []
  @doc = ::Nokogiri::HTML(HttpFetcher.call(BASE_URL))

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
  end
end
