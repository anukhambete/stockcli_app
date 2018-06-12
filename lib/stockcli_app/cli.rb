#require_relative "../stockcli_app/scraper.rb"
require_relative "../stockcli_app/stock.rb"
require_relative "../stockcli_app/scraper.rb"
require 'nokogiri'
require 'pry'


class StockcliApp::CLI

# The cli should display 2 options List and quit and accept a valid input
# if list then display the list of stocks and symbols --> create method called display_list
# the display_list method should display the stocks and ask the user to enter a valid symbol
# the display_list method should use the @@all array from the Stock class to display the list of stocks
# the create_stocks method should us the scraper and stock classes to create instances of stocks
# The display_additional_info method adds information about the stock that is available through the stock url
# like index, PE ratio and eps and the output should include basic information about the stock (from)
# the main web page as well as the information scraped from the stock url
#

  def create_stocks
      outer_array = StockcliApp::Scraper.scrape_screener
      StockcliApp::Stock.create_from_scraper_array(outer_array)
  end


  def display_list
    puts "   "
    #binding.pry
    StockcliApp::Stock.all.each do |stock|
    puts stock.srno.ljust(5) + stock.symbol.ljust(10) + stock.name.ljust(25) + stock.price.rjust(5)
    end
    puts "   "
  end

  def display_additional_info(stock_symbol)
    stock = StockcliApp::Stock.all.find {|stock| stock.symbol == stock_symbol}
    info = StockcliApp::Scraper.scrape_stock_info("https://finviz.com/" + stock.url)    #Scraper.scrape_stock_info(url)
    stock.add_stock_info(info)
    puts "#{stock.name} belongs to the #{stock.sector} sector and has a marketcap of #{stock.mktcap.gsub("B"," Billion")}"
    puts "  "
    puts "The major index/indices that include(s) it is/are #{stock.index.gsub("DJIA ","DJIA and ")}"
    puts "  "
    puts "The Earnings per share is #{stock.eps}"
    puts "   "
  end

  def input_for_additional_info
    puts "Enter a valid symbol for more information or enter 'quit' to return to the main menu"
    puts "   "
    valid_symbols = StockcliApp::Stock.all.collect {|stock| stock.symbol}
    input_symbol = gets.strip
    if valid_symbols.include? input_symbol.upcase
    display_additional_info(input_symbol.upcase)
    elsif input_symbol == "quit"
    puts "You are returning to the main menu"
    puts "   "
    else
    input_for_additional_info
    end
  end

  def display_by_market_cap
    array = []
    array = StockcliApp::Stock.all.sort_by {|stock| stock.mktcap}.reverse
    array.each {|stock| puts stock.name.ljust(25) + stock.mktcap.gsub("B", " Billion").rjust(1)}
    puts "  "
  end

  def display_by_vol
    array = []
    array = StockcliApp::Stock.all.sort_by {|stock| stock.change.gsub("%","").gsub("-","").to_f}.reverse
    array.each {|stock| puts stock.name.ljust(25) + stock.change.rjust(2)}
    puts "  "
  end

# The call method should
# (1) Main menu list options : (a) List of stocks (b) Top companies by mkt cap (c) Most volatile stock (d) quit
  # (a) If the user picks a stock from the list a method to display additional information
  # about the stock should be called and then go back to the main menu
  # The symbol entered should be valid?
# (2) Call the appropriate method after the user makes their choice
# (3) Print an error message if the option is invalid and list the options again



  def call
    create_stocks unless !StockcliApp::Stock.all.empty?

    puts "(a) To view the list of stocks enter --- list"
    puts "(b) To view the list of companies in desc order of Market cap enter --- mkt"
    puts "(c) To view the list of stocks in desc order of volatility enter --- vol"
    puts "(b) To exit the program enter --- 'quit'"

    input_1 = gets.strip
    if["list", "mkt", "vol", "quit"].include? input_1.downcase
      if input_1.downcase == "list"
        display_list
        input_for_additional_info
        call

      elsif input_1.downcase == "mkt"
        display_by_market_cap
        call

      elsif input_1.downcase == "vol"
        display_by_vol
        call

      elsif input_1.downcase == "quit"
        puts "You have chosen to exit the app"
      end

    else
      puts "Please enter a valid option"
      call
    end
  end

end
