#!/usr/bin/env ruby

require "csv"
require "nokogiri"

require "cgi"

args = ARGV
dir = args[0]

print "Target dir is #{dir}\n"

if (args[1..-1].size==1) and (args[1].include?('*'))
  print "No xml files to process; skipping.\n"
  exit
end

if not(File.directory?(dir))
  print "Target csv directory missing; skipping.\n"
  exit
end

gamecast = CSV.open("#{dir}/gamecast.csv", "w")
attacks =  CSV.open("#{dir}/attacks.csv","w")
shots = CSV.open("#{dir}/shots.csv","w")
parts = CSV.open("#{dir}/parts.csv","w")

args[1..-1].each do |file|

  year = File.dirname(file).split("/")[-1]
  league_key = File.dirname(file).split("/")[-2]
      
  file_name = File.basename(file)

  game_id = file_name.split("_")[1].split(".")[0]
  
  print "Parsing #{game_id} ...\n"

  begin
    xml = Nokogiri::XML(File.open(file))
  rescue
    next
  end

  game = xml.search("/game").first

  home = game.search("teams/home").first
  away = game.search("teams/away").first

  home_id = home.attribute("id")
  home_color = home.attribute("color")
  home_name = home.inner_text

  away_id = away.attribute("id")
  away_color = away.attribute("color")
  away_name = away.inner_text
  
  row = [game_id, year, league_key,
         home_id, home_color, home_name,
         away_id, away_color, away_name]

  gamecast << row

  attack_keys = ["key", "jersey", "avgX", "avgY", "posX", "posY",
                 "left", "middle", "right", "playerId", "teamId", "position"]

  game.search("attack/entry").each do |attack|

    row = [game_id, year, league_key]

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
      h["#{child.name}"] = child.text.encode!("UTF-8", "ISO-8859-1", :invalid => :replace, :undef => :replace, :replace => "").strip
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

  part_keys = ["pId", "jersey", "startX", "startY", "endX", "endY", "endZ"]

  game.search("shots/play").each do |play|

    row = [game_id, year, league_key]

    a = play.attributes
    play_keys.each do |key|
      value = a[key].value rescue nil
      if not(value==nil) and (value.size==0)
        value = nil
      end
      row += [value]
    end

    id = a["id"].value

    h = {}
    play.children.each do |child|
      h["#{child.name}"] = child.text.encode!("UTF-8", "ISO-8859-1", :invalid => :replace, :undef => :replace, :replace => "").strip
    end

    # Am I losing information here?
    # Need to handle this for data fields

    h["shotByText"].encode!("UTF-8", "ISO-8859-1", :invalid => :replace, :undef => :replace, :replace => "")

    row += [h["player"]]
    row += [h["result"]]
    row += [h["topScoreText"]]
    row += [h["shotByText"]]

    parts_xml = play.search("part")
    row += [parts_xml.size]

    shots << row

    parts_xml.each_with_index do |part,i|
      
      row = [game_id, year, league_key, id, i]
      
      a = part.attributes
      part_keys.each do |key|
        value = a[key].value rescue nil
        if not(value==nil) and (value.size==0)
          value = nil
        end
        row += [value]
      end

      h = {}
      part.children.each do |child|
        h["#{child.name}"] = child.text.encode!("UTF-8", "ISO-8859-1", :invalid => :replace, :undef => :replace, :replace => "").strip
      end

      row += [h["player"]]
      row += [h["result"]]
      row += [h["resultText"]]

      parts << row

    end

  end
  
end

