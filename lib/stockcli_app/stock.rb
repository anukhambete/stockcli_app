class StockcliApp::Stock

  attr_accessor :srno, :name, :symbol, :url, :price, :mktcap, :sector, :index, :peratio, :eps, :change

  @@all = []

  # The instances of stocks should be initialized with an array that includes information that was scraped
  # using the scraper class
  # The initialized stock should contain information about the Sr no, name, symbol, url and marketcap

  def initialize(array)
    stock_array = array
    @srno = stock_array[0]
    @symbol = stock_array[1]
    @name = stock_array[2]
    @url = stock_array[3]
    @price = stock_array[4]
    @mktcap = stock_array[5]
    @sector = stock_array[6]
    @change = stock_array[7]
    @@all << self
  end

  def self.create_from_scraper_array(outer_array)
    outer_array.each do |inner_array|
      stock = StockcliApp::Stock.new(inner_array)
    end
  end


  def self.all
    @@all
  end

  def add_stock_info(info)
    array = info
    @index = array[0]
    @peratio = array[1]
    @eps = array[2]
  end


end
