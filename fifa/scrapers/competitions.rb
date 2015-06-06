#!/usr/bin/env ruby

require 'csv'
require 'open-uri'
require 'json'

base = "http://www.fifa.com/live/common/world-match-centre"

#/year=1971/gender=f/_competitionMonthList.js

gender_id = ARGV[0]

case gender_id
when "men"
  gid = "m"
when "women"
  gid = "f"
else
  exit
end

year_file = "json/years_#{gender_id}.json"

years = JSON.parse(File.read(year_file))

years.each do |year_row|
  
  year = year_row[0]

  print "#{gender_id} - #{year}\n"
  
  url = "#{base}/year=#{year}/gender=#{gid}/_competitionMonthList.js"
  
  file_name = "json/competitions_#{gender_id}_#{year}.json"

  open(file_name, 'wb') do |file|
    data = JSON.parse(open(url).read)
    file << data.to_json
  end
  
end

