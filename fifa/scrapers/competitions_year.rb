#!/usr/bin/env ruby

require 'csv'
require 'open-uri'
require 'json'

base = "http://www.fifa.com/live/common/world-match-centre"

#/year=1971/gender=f/_competitionMonthList.js

gender_id = ARGV[0]
year = ARGV[1].to_i

case gender_id
when "men"
  gid = "m"
when "women"
  gid = "f"
else
  exit
end

print "#{gender_id} - #{year}\n"
  
url = "#{base}/year=#{year}/gender=#{gid}/_competitionMonthList.js"
  
file_name = "json/competitions_#{gender_id}_#{year}.json"

open(file_name, 'wb') do |file|
  data = JSON.parse(open(url).read)
  file << data.to_json
end
