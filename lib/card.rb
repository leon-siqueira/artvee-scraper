# frozen_string_literal: true

# Helps the ArtveeScraper class to populate the @arts array
class Card
  attr_reader :img_url, :title, :date, :artist, :artist_details, :tag

  def initialize(html_obj)
    @html_obj = html_obj
    set_img_url
    set_date_and_title
    set_artist
    set_artist_details
    set_tag
  end

  private

  def set_img_url
    img_src = @html_obj.at('img').attributes['src'].value
    @img_url = img_src.sub(/ftmp/, 'sftb')
  end

  def set_date_and_title
    h3_text = @html_obj.at('h3').text[..-2]
    date_title = h3_text.match(/^(?<title>.+?)\s*(\((?<date>[^)]+)\))?$/)
    @title = date_title[:title]
    @date = date_title[:date]
  end

  def set_artist
    @artist = @html_obj.at('.woodmart-product-brands-links a')&.text
  end

  def set_artist_details
    div_text = @html_obj.at('.woodmart-product-brands-links').text
    return {} if div_text.split('(').count < 2

    @details = div_text.split('(')[1][0..-2].split(', ')
    @artist_details = author_life_cycle.merge(nationality)
  end

  def set_tag
    @tag = @html_obj.at('.woodmart-product-cats a')&.text
  end

  def author_life_cycle
    return {} unless @details.count >= 1 && @details.last.match?(/\d+/)

    life_cycle_hash(@details.last.delete(' ').split(/-|–/))
  end

  def life_cycle_hash(life_cycle)
    {
      birth_date: life_cycle[0],
      passing_date: life_cycle[1]
    }
  end

  def nationality
    return {} unless @details.first.match?(/^[a-zA-Z]{2,}/)

    { nationality: @details.first }
  end
end
