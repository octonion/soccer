#!/usr/bin/env ruby

require 'csv'
require 'open-uri'

#require 'json'

url = "http://www.fifa.com/xmlfeed/widgets/leagues/leagues.xml"

file_name = "xml/leagues.xml"

open(file_name, 'wb') do |file|
  xml = open(url).read
  file << xml
end
