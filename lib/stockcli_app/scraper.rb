require 'open-uri'
require 'pry'
require 'nokogiri'

# The Scraper class should have two methods
# The first method should be used to scrape the name, symbol, market cap
# The first method should return an array with arrays for each stock within it :
# This should be information collected from the main webpage about the 8 large companies
# url etc. from the main page for all the stocks
# The second method should scrape information about the individual stock
# The second method should scrape the EPS P/E ratio and the Index

class StockcliApp::Scraper

finviz = Nokogiri::HTML(open("https://finviz.com/screener.ashx?v=111&f=cap_mega,exch_nasd"))

  def self.scrape_screener
    array_main = []
    finviz = Nokogiri::HTML(open("https://finviz.com/screener.ashx?v=111&f=cap_mega,exch_nasd"))
    fin = finviz.css("div#screener-content").css("td").css("tr[valign=top]")

    fin.each do |f|
         temp = []

         num = f.css("td")[0].text
         symbol = f.css("td")[1].text
         name = f.css("td")[2].text
         url = f.css("td")[1].css("a").attribute("href").value

         price = f.css("td")[8].text
         mktcap = f.css("td")[6].text
         sector = f.css("td")[3].text
         change = f.css("td")[9].text

         temp = [num, symbol, name, url, price, mktcap, sector, change]
         array_main << temp
       end
    array_main
  end

  def self.scrape_stock_info(url)
    stock_webpage = Nokogiri::HTML(open(url))
    stock_addinfo_array = []
    stock = stock_webpage.css("table.snapshot-table2 tr")
      index = stock.css("td")[1].text
      peratio = stock.css("td")[3].text
      eps = stock.css("td")[5].text
    stock_addinfo_array = [index, peratio, eps]
  end



end
