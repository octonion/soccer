#!/usr/bin/env ruby

require 'csv'

require 'nokogiri'
require 'mechanize'

agent = Mechanize.new{ |agent| agent.history.max_size=0 }
agent.user_agent = 'Mozilla/5.0'

base_url = "http://www.espnfc.us/gamepackage10/data"

league_key = ARGV[0]
first_year = ARGV[1]
last_year = ARGV[2]

retries = 2

(first_year..last_year).each do |year|

  begin
    games = CSV.open("tsv/games_#{league_key}_#{year}.tsv",
                     "r",
                     {:col_sep => "\t", :headers => TRUE})
  rescue
    next
  end

  game_ids = []

  games.each do |game|
    game_ids << game["game_id"]
  end
  games.close

  game_ids.sort!.uniq!

  game_ids.each do |game_id|

    print "#{game_id}"

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
