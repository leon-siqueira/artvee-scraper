# frozen_string_literal: true

require 'nokogiri'
require_relative '../lib/card'

RSpec.describe Card do
  subject { described_class.new(Nokogiri::HTML(html_obj)) }
  describe 'Card object' do
    let(:html_obj) do
      "<html><body><div class='product-grid-item product woodmart-hover-tiled'><div>#{content}</div></div></body></html>"
    end

    let(:content) do
      "<img src='#{src}'/>
      <h3>#{title} (#{date}) </h3>
      <div class='woodmart-product-brands-links'><a>#{artist_name}</a> (#{details})</div>
      <div class='woodmart-product-cats'><a>#{tag}</a></div>"
    end

    let(:src) { 'https://mdl.artvee.com/ftmp/storageid.jpg' }
    let(:title) { 'Art title' }
    let(:date) { '1945' }
    let(:artist_name) { 'Artist name' }
    let(:details) { 'Countrian, 1905 - 1990' }
    let(:tag) { 'Tag' }

    context 'on a fully info-filled @html_obj' do
      it 'should have ALL its info on the readble attrs' do
        expect(subject.img_url).to eq('https://mdl.artvee.com/sftb/storageid.jpg')
        expect(subject.artist).to eq('Artist name')
        expect(subject.title).to eq('Art title')
        expect(subject.date).to eq('1945')
        expect(subject.artist_details).to eq({ birth_date: '1905', passing_date: '1990', nationality: 'Countrian' })
      end
    end

    context 'when title have MORE than 2 parenthesis' do
      let(:title) { 'Ohne titel (Sonnenberg)' }
      let(:date) { '1926' }
      it 'the content within the LAST pair of parentesis should be the date and the rest the title' do
        expect(subject.title).to eq(title)
        expect(subject.date).to eq(date)
      end
    end

    context 'on a @html_obj without nationality of the author' do
      let(:details) { '1908 - 1959' }
      it 'artist_details should NOT have nationality' do
        expect(subject.artist_details).to eq({ birth_date: '1908', passing_date: '1959' })
      end
    end

    context 'on a @html_obj without dob nor passing of the author' do
      let(:details) { 'St Helenian' }
      it 'artist_details should NOT have dob nor passing' do
        expect(subject.artist_details).to eq({ nationality: 'St Helenian' })
      end
    end
  end
end
