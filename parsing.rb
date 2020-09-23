require 'curb'
require 'nokogiri'
require 'csv'
require './product'

class Parsing
  CATEGORY_XPATH = "//link[contains(@itemprop, 'url')]".freeze
  NAME_XPATH = '//div/h1/text()'.freeze
  TYPE_NAME_XPATH = "//span[contains(@class, 'radio_label')]/text()".freeze
  PRICE_XPATH = "//span[@class ='price_comb']/text()".freeze
  IMG_XPATH = "//img[contains(@id, 'bigpic')]/@src".freeze

  def page_parser(page)
    products = []

    http = Curl.get(page)

    doc = Nokogiri::HTML(http.body)

    name = doc.at(NAME_XPATH)
    type_names = doc.xpath(TYPE_NAME_XPATH)
    price = doc.xpath(PRICE_XPATH)
    img = doc.at(IMG_XPATH)

    (0..type_names.length - 1).each do |i|
      full_name = "#{name} - #{type_names[i]}"
      products << Product.new(full_name, price[i], img)
    end

    puts "Parsing #{name} ended"
    products
  end

  def category_parser(category)
    products = []

    http = Curl.get(category)

    doc = Nokogiri::HTML(http.body)

    doc.xpath(CATEGORY_XPATH).each do |page|
      products += page_parser(page['href'])
    end
    products
  end

  def file_writer(products, file)
    CSV.open(file, 'w') do |csv|
      csv << %w[Name Price Image]
      products.each do |product|
        csv << %W[#{product.name} #{product.price} #{product.img}]
      end
    end
  end
end
