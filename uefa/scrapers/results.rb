#!/usr/bin/env ruby

require 'csv'
require 'open-uri'
require 'mechanize'

agent = Mechanize.new{ |agent| agent.history.max_size=0 }
agent.user_agent = 'Mozilla/5.0'

agent.robots = false

data_path = "//img+//a"
data_css = "img+a"

countries = CSV.open("football-data/countries.csv", "r", {:headers => TRUE})

countries.each do |country|

  country_id = country["country_id"]
  country_name = country["country_name"]

  country_url = country["country_url"]

  directory_name = "csv/#{country_id}"
  
  Dir.mkdir(directory_name) unless File.directory?(directory_name)

  begin
    page = agent.get(country_url)
  rescue
    retry
  end

  page.search(data_css).each_with_index do |data_file, i|

    text = data_file.text.scrub.strip
    href = data_file.attributes["href"]
    data_url = URI.join(country_url, href)
    
    s = href.text.split("/")
    base = s[2]
    year_string = s[1]
    year_part = year_string[2..3].to_i

    case year_part
    when 0..15
      year = 2000+year_part
    when 90..99
      year = 1900+year_part
    end

    file_name = "football-data/#{country_id}/#{year}_#{base}"

    print "#{country_name} #{year} - #{text}\n"
    open(file_name, "w") do |file|
      file << open(data_url).read
    end
    
  end
end
