#!/usr/bin/env ruby

require 'csv'
require 'mechanize'

agent = Mechanize.new{ |agent| agent.history.max_size=0 }
agent.user_agent = 'Mozilla/5.0'

url = "http://web1.ncaa.org/stats/exec/records"
teams = CSV.read("ncaa_teams.csv")

first_year = 2014
last_year = 2014

games_header = ["year","team_name","team_id","opponent_name","opponent_id",
                "game_date","team_score","opponent_score","location",
                "neutral_site_location","game_length","attendance"]

records_header = ["year","team_id","team_name","wins","losses","ties",
                  "total_games"]

(first_year..last_year).each do |year|

  games = CSV.open("ncaa_games_#{year}.csv","w")
  records = CSV.open("ncaa_records_#{year}.csv","w")

  team_count = 0
  game_count = 0

  games << games_header
  records << records_header

  teams.each do |team|
    team_id = team[0]
    team_name = team[1]
    print "#{year}/#{team_name} (#{team_count}/#{game_count})\n"
    begin
      page = agent.post(url, {"academicYear" => "#{year}", "orgId" => team_id,
                             "sportCode" => "MSO"})
    rescue
      print "  -> error, retrying\n"
      retry
    end

    begin
      page.parser.xpath("//table/tr[3]/td/form/table[1]/tr[2]").each do |row|
        r = []
        row.xpath("td").each do |d|
          r += [d.text.strip]
        end
        team_count += 1
        records << [year,team_id]+r
      end
      records.flush
    end

    page.parser.xpath("//table/tr[3]/td/form/table[2]/tr").each do |row|
      r = []
      row.xpath("td").each do |d|
        r += [d.text.strip,d.inner_html.strip]
      end
      if (r[0]=="Opponent")
        next
      end
      opponent_id = r[1][/(\d+)/]
      game_count += 1
      games << [year,team_name,team_id,r[0],opponent_id,r[2],r[4],
                r[6],r[8],r[10],r[12],r[14]]
    end
    games.flush
  end
  records.close
  games.close
end
