#!/usr/bin/ruby1.9.3

require 'csv'
require 'mechanize'

agent = Mechanize.new{ |agent| agent.history.max_size=0 }

agent.user_agent = 'Mozilla/5.0'

#url = "http://web1.ncaa.org/stats/exec/records"
#url = "http://web1.ncaa.org/stats/StatsSrv/careersearch"

# Needed for referer

url = "http://web1.ncaa.org/stats/StatsSrv/careerteam"
agent.get(url)

teams = CSV.read("ncaa_teams.csv")

first_year = 2013
last_year = 2013

(first_year..last_year).each do |year|
  stats = CSV.open("ncaa_players_#{year}.csv","w")

  teams.each do |team|

    team_id = team[0]
    team_name = team[1]
    print "#{year}/#{team_name}\n"

    begin
      page = agent.post(url, {
                          "academicYear" => "#{year}",
                          "orgId" => team_id,
                          "sportCode" => "MSO",
                          "sortOn" => "0",
                          "doWhat" => "display",
                          "playerId" => "-100",
                          "coachId" => "-100",
                          "division" => "1",
                          "idx" => ""
                        })
    rescue
      print "  -> error, retrying\n"
      retry
    end

    page.parser.xpath("//table[5]/tr").each do |row|
      if (row.path =~ /\/tr\[[123]\]\z/)
        next
      end
      r = [team_name,team_id,year]
      row.xpath("td").each_with_index do |d,i|
        if (i==0) then
          id = d.inner_html.strip[/(\d+)/].to_i
          r += [d.text.strip,id]
        else
          r += [d.text.strip]
        end
      end

      stats << r
      stats.flush
    end
  end

  stats.close
end
