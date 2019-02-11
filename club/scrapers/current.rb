#!/usr/bin/env ruby

require 'csv'

require 'nokogiri'
require 'open-uri'

leagues = CSV.open("tsv/leagues.tsv",
                   "r",
                   {:col_sep => "\t", :headers => true})

clubs = CSV.open("tsv/clubs.tsv",
                 "w",
                 {:col_sep => "\t"})

# Header for club file

clubs << ["league_id", "league_key",
          "club_id", "club_key", "club_name", "club_url"]

club_xpath = '//li[@data-section="clubs"]/ul/li/a'

leagues.each do |league|

  league_id = league["league_id"]
  league_key = league["league_key"]
  league_name = league["league_name"]

  print "pulling #{league_name}"

  league_url = league["league_url"]
  
  doc = Nokogiri::HTML(open(league_url))

  found = 0
  doc.xpath(club_xpath).each do |club|
    name = club.attribute("name").text
    club_key = name.split(":")[-1]
    club_name = club.text
    club_url = club.attribute("href").text
    club_id = club_url.split("/")[-2]
    clubs << [league_id, league_key, club_id, club_key, club_name, club_url]
    found += 1
  end

  print " - found #{found} clubs\n"
  
end
