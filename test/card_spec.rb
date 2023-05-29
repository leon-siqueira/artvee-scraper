# frozen_string_literal: true

require 'nokogiri'
require_relative '../lib/card'

RSpec.describe Card do
  subject { described_class.new(Nokogiri::HTML(html_obj)) }
  describe 'Card object' do
    let(:html_obj) do
      "<html><body><div class='product-grid-item product woodmart-hover-tiled'><div>#{content}</div></div></body></html>"
    end

    context 'on a fully info-filled @html_obj' do
      let(:content) do
        '<img src="https://mdl.artvee.com/ftmp/storageid.jpg"/>
        <h3>Art title (1905) </h3>
        <div class="woodmart-product-brands-links"><a>Artist name</a> (Countrian, 1905-1990)</div>
        <div class="woodmart-product-cats"><a>Tag</a></div>'
      end
      it 'should have all its info on the readble attrs' do
        expect(subject.img_url).to eq('https://mdl.artvee.com/sftb/storageid.jpg')
        expect(subject.artist).to eq('Artist name')
        expect(subject.title).to eq('Art title')
        expect(subject.date).to eq('1905')
        expect(subject.artist_details).to eq({ birth_date: '1905', passing_date: '1990', nationality: 'Countrian' })
      end
    end
  end
end
