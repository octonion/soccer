#!/usr/bin/env ruby
# coding: utf-8

require 'csv'
require 'mechanize'

bad = " "

agent = Mechanize.new{ |agent| agent.history.max_size=0 }
agent.user_agent = 'Mozilla/5.0'

url = "http://www.football-data.co.uk/data.php"

#/html/body/table[5]/tbody/tr[2]/td[3]/table/tbody/tr[1]

country_path = "/html/body/table[5]/tr[2]/td[3]/table/tr"

results = CSV.open("football-data/countries.csv", "w")

header = ["country_id", "country_name", "country_url", "leagues"]

results << header

page = agent.get(url)

found = 0

page.parser.xpath(country_path).each do |country|

  row = []

  country.xpath("td").each_with_index do |td,i|

    case i
    when 0
      next
    when 1
      title = td.text.gsub(bad,"").scrub.strip rescue nil
      country_name = title.split(" ")[0]
      country_id = country_name.downcase
      href = td.xpath("a").first.attributes["href"]
      country_url = URI.join(url, href)
      row += [country_id, country_name, country_url]
    when 2
      leagues = td.text.gsub(bad,"").scrub.strip rescue nil
      row += [leagues]
    end

  end

  results << row
  found += 1

end

print "Found #{found} countries\n"
results.close


