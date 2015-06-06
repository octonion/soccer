#!/usr/bin/env ruby

require 'csv'
require 'open-uri'
require 'json'

base = "http://www.fifa.com/live/common/world-match-centre/intCompetitionMonths"

gender_id = ARGV[0]

case gender_id
when "men"
  url = "#{base}.js"
when "women"
  url = "#{base}_w.js"
else
  exit
end

file_name = "json/years_#{gender_id}.json"

open(file_name, 'wb') do |file|
  years = JSON.parse(open(url).read)
  file << years.to_json
end
