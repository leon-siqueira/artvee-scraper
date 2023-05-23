# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'
require 'json'
require 'byebug'

class ArtveeScraper
  BASE_URL = 'https://artvee.com/'

  def initialize
    @arts = []
    @doc = Nokogiri::HTML(URI.open(BASE_URL))
  end

  def scrape
    populate_arts
    @arts
  end

  private

  def populate_arts
    @doc.search('.product-grid-item.product.woodmart-hover-tiled').each do |card|
      @arts << {
        img_url: big_pic_url(card.at('img').attributes['src'].value),
        title: title(card.at('h3').text),
        date: date(card.at('h3').text),
        artist: card.at('.woodmart-product-brands-links a')&.text || 'Unknown',
        artist_details: artist_details(card.at('.woodmart-product-brands-links').text),
        tag: card.at('.woodmart-product-cats a')&.text
      }
    end
  end

  def big_pic_url(original_url)
    original_url.sub(/ftmp/, 'sftb')
  end

  def title(h3_text)
    h3_text[..-2].match(/^(?<title>.+?)\s*(\((?<date>[^)]+)\))?$/)[:title]
  end

  def date(h3_text)
    h3_text[..-2].match(/^(?<title>.+?)\s*(\((?<date>[^)]+)\))?$/)[:date]
  end

  def artist_details(div_text)
    return {} if div_text.split('(').count < 2

    @details = div_text.split('(')[1][0..-2].split(', ')
    author_life_cycle.merge(nationality)
  end

  def author_life_cycle
    return { birth_date: @details.first } if @details.count == 1
    return { birth_date: @details.last } if @details.last.delete(' ').split(/-|–/).count == 1

    life_cycle_hash(@details.last.delete(' ').split(/-|–/))
  end

  def life_cycle_hash(life_cycle)
    {
      birth_date: life_cycle.first,
      passing_date: life_cycle.last
    }
  end

  def nationality
    return {} if @details.count == 1

    { nationality: @details.first }
  end
end
