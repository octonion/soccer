#!/usr/bin/env ruby

require 'csv'
require 'open-uri'
require 'nokogiri'

base_url = "http://www.espnfc.us/gamepackage10/data"

league_key = ARGV[0]
year = ARGV[1]

games = CSV.open("tsv/games_#{league_key}_#{year}.tsv",
                 "r",
                 {:col_sep => "\t", :headers => TRUE})

game_ids = []

games.each do |game|
  game_ids << game["game_id"]
end

game_ids.uniq!

game_ids.each do |game_id|

  url = "#{base_url}/gamecast?gameId=#{game_id}&langId=0&snap=0"

  begin
    doc = open(url).read
  rescue
    print " ... sleeping"
    sleep 10
    retry
  end

  xml = Nokogiri::XML(doc)

  File.open("xml/#{league_key}/#{year}/gamecast_#{game_id}.xml","w") do |file|
    file << xml
  end

  url = "#{base_url}/timeline?gameId=#{game_id}&langId=0&snap=0"

  begin
    doc = open(url).read
  rescue
    print " ... sleeping"
    sleep 10
    retry
  end

  xml = Nokogiri::XML(doc)
  
  File.open("xml/#{league_key}/#{year}/timeline_#{game_id}.xml","w") do |file|
    file << xml
  end

end
