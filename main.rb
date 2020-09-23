require './parsing'

class Main
  def start(url, file)
    parsing = Parsing.new
    products = parsing.category_parser(url)
    parsing.file_writer(products, file)
  end
end
