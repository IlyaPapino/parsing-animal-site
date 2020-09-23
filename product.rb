class Product
  attr_accessor :name, :price, :img

  def initialize(name, price, img)
    @name = name
    @price = price
    @img = img
  end
end
