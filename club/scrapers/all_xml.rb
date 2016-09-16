#!/usr/bin/env ruby
# coding: utf-8

require 'csv'

require 'nokogiri'
require 'mechanize'

retries = 2

agent = Mechanize.new{ |agent| agent.history.max_size=0 }
agent.user_agent = 'Mozilla/5.0'

base_url = "http://www.espnfc.us/gamepackage10/data"

first_year = ARGV[0]
last_year = ARGV[1]

leagues = CSV.open("tsv/leagues.tsv",
                   "r",
                   {:col_sep => "\t", :headers => TRUE})

#skip = ["english+premier+league","spanish+primera+división","german+bundesliga","italian+serie+a","french+ligue+1","major+league+soccer","mexican+liga+mx","english+league+championship","australian+a-league","indian+super+league","futebol+brasileiro","primera+división+de+argentina","dutch+eredivisie","portuguese+liga","turkish+super+lig","scottish+premiership","russian+premier+league"]

skip = []

leagues.each do |league|

  league_key = league["league_key"]

  if skip.include?(league_key)
    next
  end
  
(first_year..last_year).each do |year|

  begin
    games = CSV.open("tsv/games_#{league_key}_#{year}.tsv",
                     "r",
                     {:col_sep => "\t", :headers => TRUE})
  rescue
    print "skipping #{league_key}/#{year}\n"
    next
  end

  game_ids = []

  games.each do |game|
    game_ids << game["game_id"]
  end
  games.close

  game_ids.sort!.uniq!

  game_ids.each do |game_id|

    print "pulling #{league_key}/#{year}/#{game_id}"

    game_file = "xml/#{league_key}/#{year}/gamecast_#{game_id}.xml"
  
    #  if (File.file?(game_file))
    #    print "...gamecast already present\n"
    #    next
    #  end

    url = "#{base_url}/gamecast?gameId=#{game_id}&langId=0&snap=0"

    tries = 0
    begin
      doc = agent.get(url).body
    rescue
      tries += 1
      if (tries>retries)
        print "...gamecast not found.\n"
        next
      else
        print "...sleeping"
        sleep 5
        retry
      end
    end
    print "...gamecast found"

    xml = Nokogiri::XML(doc)

    File.open(game_file,"w") do |file|
      file << xml
    end

    url = "#{base_url}/timeline?gameId=#{game_id}&langId=0&snap=0"

    tries = 0
    begin
      doc = agent.get(url).body
    rescue
      tries += 1
      if (tries>retries)
        print "...timeline not found\n"
        next
      else
        print "...sleeping"
        sleep 5
        retry
      end
    end
    print "...timeline found\n"
  
    xml = Nokogiri::XML(doc)
  
    File.open("xml/#{league_key}/#{year}/timeline_#{game_id}.xml","w") do |file|
      file << xml
    end

  end

end
  
end
