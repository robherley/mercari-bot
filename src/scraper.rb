# frozen_string_literal: true

class Scraper
  ELEMENT_ID_REGEX = %r{(?<=\/jp\/items\/)(?<id>.*)(?=/)}.freeze
  JPY_TO_USD = 0.0091

  def self.search_items(keyword)
    html = parse_html "https://www.mercari.com/jp/search/?sort_order=created_desc&keyword=#{keyword}"
    elements = html.css '.items-box-content > .items-box'

    elements.map do |el|
      href = el.css('a').attr('href').value
      id = ELEMENT_ID_REGEX.match(href)['id']
      price_jpy = el.css('.items-box-price').text

      Item.new(
        {
          mercari_id: id,
          href: href,
          sendico_url: "https://www.sendico.com/mercari/item/#{id}",
          img: el.css('img').attr('data-src').value,
          price_usd: yen_text_to_usd(price_jpy),
          price_jpy: price_jpy,
          description: el.css('.items-box-name').text,
          sold: !el.css('.item-sold-out-badge').empty?
        }
      )
    end
  end

  def self.category_items(cat_id)
    html = parse_html "https://www.mercari.com/jp/category/#{cat_id}/"
    elements = html.css "[data-test='grid-layout'] > ul > li"
    elements.map do |el|
      href = el.css('a').attr('href').value
      id = ELEMENT_ID_REGEX.match(href)['id']
      price_jpy = el.css("span[aria-label='Price']").text

      Item.new(
        {
          mercari_id: id,
          href: href,
          sendico_url: "https://www.sendico.com/mercari/item/#{id}",
          img: el.css('img').attr('src').value,
          price_usd: yen_text_to_usd(price_jpy),
          price_jpy: price_jpy,
          description: el.css('figcaption').text,
          sold: el.css("[aria-label='Status']").text == 'SOLD'
        }
      )
    end
  end

  def self.parse_html(url)
    response = Faraday.get url
    Nokogiri::HTML response.body
  end

  def self.yen_text_to_usd(text)
    format('$%.2f', text.delete('^0-9').to_i * JPY_TO_USD)
  end

  private_class_method :parse_html, :yen_text_to_usd
end
