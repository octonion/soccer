#!/usr/bin/env ruby

require 'json'
require 'csv'

require 'nokogiri'
require 'open-uri'

leagues = CSV.open("tsv/leagues.tsv",
                   "w",
                   {:col_sep => "\t"})

leagues << ["league_id", "league_key", "league_name", "league_url"]

league_url = "http://www.espnfc.us/api/navigation?xhr=1"

doc = open(league_url).read

json = JSON.parse(doc)

html = nil
json["navigationItems"].each do |i|
  if (i["key"] == ".desktop-nav-item.leagues")
    html = i["html"]
  end
end

parsed = Nokogiri::HTML(html)

parsed.xpath("//a").each do |x|
  name = x.attribute("name").text rescue nil
  if (name==nil) or not(name.include?(":leagues:"))
    next
  end
  league_key = name.split(":")[-1]
  league_href = x.attribute("href").text
  league_id = league_href.split("/")[-2]
  league_name = x.text
  leagues << [league_id, league_key, league_name, league_href]
end
