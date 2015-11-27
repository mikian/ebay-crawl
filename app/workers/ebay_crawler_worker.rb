require 'net/http'
require 'nokogiri'

class EbayCrawlerWorker
  include Sidekiq::Worker

  def perform(search_id)
    search = Search.find(search_id)

    # Make requst to ebay
    uri = URI("http://www.ebay.de/sch/i.html?_nkw=#{search.keyword}")
    response = Net::HTTP.get_response(uri)

    # Parse web page for products
    doc = Nokogiri::HTML(response.body)

    doc.css('li.lvresult').each do |item|
      next if SearchResult.exists?(item_id: item.attr('id'))

      # Create search result
      SearchResult.create(
        item_id: item.attr('id'),
        name: item.css('.lvtitle').text().strip,
        price: item.css('li.lvprice > span.bold').text().strip.gsub('EUR ', '').to_f,
        link: item.css('.lvtitle > a').try(:attr, 'href').value,
        search_id: search.id
      )
    end

    search.update_attributes(done: true)
  end
end
