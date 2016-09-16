#!/usr/bin/env ruby

require 'csv'

require 'nokogiri'
require 'open-uri'

year = ARGV[0]

leagues = CSV.open("tsv/leagues.tsv",
                   "r",
                   {:col_sep => "\t", :headers => TRUE})

clubs = CSV.open("tsv/clubs_#{year}.tsv",
                 "w",
                 {:col_sep => "\t"})

# Header for club file

clubs << ["year", "league_id", "league_key",
          "club_id", "club_key", "club_name", "club_url"]

club_xpath = 'td[@class="team"]/a'

leagues.each do |league|

  league_id = league["league_id"]
  league_key = league["league_key"]
  league_name = league["league_name"]

  #if not(league_key=='futebol+brasileiro')
  #  next
  #end

  print "pulling #{league_name}"

  league_url = league["league_url"]

  table_url = league_url.gsub("index","")+"table?season=#{year}" #&seasonType=1"

  begin
    doc = Nokogiri::HTML(open(table_url))
  rescue
    print " ... sleeping"
    retry
  end

  found = 0
  doc.search(club_xpath).each do |club|

    club_name = club.text.strip rescue nil
    club_url = club.attribute("href").text.strip rescue nil
    club_id = club_url.split("/")[-2] rescue nil
    club_key = club_url.split("/")[-3] rescue nil
    clubs << [year, league_id, league_key,
              club_id, club_key, club_name, club_url]
    found += 1
  end

  print " - found #{found} clubs\n"

end
