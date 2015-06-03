#!/usr/bin/env ruby

require 'csv'
require 'mechanize'

agent = Mechanize.new{ |agent| agent.history.max_size=0 }

agent.user_agent = 'Mozilla/5.0'

sport_code = "MSO"

stats = CSV.open("ncaa_divisions.csv","w")

teams = CSV.read("ncaa_teams.csv")

teams.each do |team|
# Needed for referer

  team_id = team[0]
  team_name = team[1]

  url = "http://web1.ncaa.org/stats/StatsSrv/careersearch"
  page = agent.get(url)

  form = page.forms[1]
  form.searchOrg = team_id
  form.academicYear = "X"
  form.searchSport = sport_code
  form.searchDiv = "X"
  page = form.submit

  sp = "/html/body/form/table/tr/td[1]/table/tr/td/table/tr/td/a"
  show = page.search(sp)
  pulls = show.to_html.scan(/javascript:showNext/).length

  if (pulls>0)
    path = "/html/body/form/table/tr/td[2]/table/tr/td/table/tr"
  else
    path = "/html/body/form/table/tr/td/table/tr/td/table/tr"
  end

  (0..pulls).each do |pull|

    print "#{team_name} - #{pull}\n"

    if (pull>0)
      form = page.forms[2]
      form.orgId = team_id
      form.academicYear = "X"
      form.sportCode = sport_code
      form.division = "X"
      form.idx = pull
      form.doWhat = 'showIdx'
      page = form.submit
    end

    page.search(path).each_with_index do |row,i|

      if (i<=pulls)
        next
      end

      r = [sport_code,team_name,team_id]
      row.search("td").each_with_index do |td,j|
        if (j==0)
          h = td.search("a").first
          if (h==nil)
            r += [td.text.strip,nil,nil,nil]
        else
          o = h["href"]
          year = o.split(",")[1].strip
          div = o.split(",")[3].strip
          r += [td.text.strip,h["href"],year,div]
        end
      else
        r += [td.text.strip]
      end
    end
      stats << r
    end
    stats.flush
  end
end

stats.close
