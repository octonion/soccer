#!/usr/bin/env ruby

require 'csv'
require 'mechanize'

agent = Mechanize.new{ |agent| agent.history.max_size=0 }
agent.user_agent = 'Mozilla/5.0'

gender_id = ARGV[0]

path = '//td[@class="tbl-teamname"]/a'

url = "http://www.fifa.com/fifa-world-ranking/ranking-table/#{gender_id}/index.html"

results = CSV.open("csv/countries_#{gender_id}.csv", "w")

header = ["gender_id", "country_id", "country_name", "country_url"]

results << header

page = agent.get(url)

found = 0
page.parser.xpath(path).each do |country|

  href = country.attributes["href"].to_s
  country_id = href.split("=")[1].split("/")[0]
  country_url = URI.join(url, href)
  
  country_name = country.text
  country_name = country_name.gsub("*","").scrub.strip
  
  row = [gender_id, country_id, country_name, country_url]

  print "  #{country_name}\n"
  found += 1
  results << row
  
end

results.close

print "Found #{found} countries\n"
