#!/usr/bin/env ruby

require "csv"
require "nokogiri"

args = ARGV
dir = args[0]

games = CSV.open("#{dir}/games.csv", "w")
attacks =  CSV.open("#{dir}/attacks.csv","w")
shots = CSV.open("#{dir}/shots.csv","w")

args[1..-1].each do |file|
      
  file_name = File.basename(file)

  game_id = file_name.split("_")[1].split(".")[0]
  
  print "Parsing #{game_id} ...\n"
      
  xml = Nokogiri::XML(File.open(file))

  game = xml.search("/game").first

  home = game.search("teams/home").first
  away = game.search("teams/away").first

  home_id = home.attribute("id")
  home_color = home.attribute("color")
  home_name = home.inner_text

  away_id = away.attribute("id")
  away_color = away.attribute("color")
  away_name = away.inner_text
  
  row = [game_id,
         home_id, home_color, home_name,
         away_id, away_color, away_name]

  games << row


  attack_keys = ["key", "jersey", "avgX", "avgY", "posX", "posY",
                 "left", "middle", "right", "playerId", "teamId", "position"]

  game.search("attack/entry").each do |attack|

    row = [game_id]

    a = attack.attributes

    attack_keys.each do |key|
      value = a[key].value
      if (value.size==0)
        value = nil
      end
      row += [value]
    end

    h = {}
    attack.children.each do |child|
      h["#{child.name}"] = child.text.strip
    end

    row += [h["cdata-section"]]

    grid = h["grid"]
    heat_map = []

    if not(grid==nil)
      values = grid.split("~")
      flat = []
      values.each { |v| flat << v.to_i }
      (0..21).each do |i|
        heat_map += [flat[(32*i)..(32*i+31)]]
      end
      row += [heat_map.reverse]
    else
      row += [nil]
    end

    attacks << row

  end

  play_keys = ["id", "clock", "addedTime", "period", "startX", "startY",
               "teamId", "goal", "ownGoal", "shootout", "videoId"]

  part_keys = ["pId", "jersey", "startX", "startY"]

  game.search("shots/play").each do |play|

    row = [game_id]

    a = play.attributes
    play_keys.each do |key|
      value = a[key].value
      if (value.size==0)
        value = nil
      end
      row += [value]
    end

    h = {}
    play.children.each do |child|
      h["#{child.name}"] = child.text.strip
    end

    row += [h["player"]]
    row += [h["result"]]
    row += [h["topScoreText"]]
    row += [h["shotByText"]]

    part = play.search("part").first

    a = part.attributes
    part_keys.each do |key|
      value = a[key].value
      if (value.size==0)
        value = nil
      end
      row += [value]
    end

    h = {}
    part.children.each do |child|
      h["#{child.name}"] = child.text.strip
    end

    row += [h["player"]]
    row += [h["result"]]
    row += [h["resultText"]]

    shots << row

  end
  
end

