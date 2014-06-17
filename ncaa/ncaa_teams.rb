#!/usr/bin/ruby1.9.3

require 'csv'
require 'mechanize'

agent = Mechanize.new{ |agent| agent.history.max_size=0 }
agent.user_agent = 'Mozilla/5.0'

url = "http://www.ncaa.com/stats/soccer-men/d1"

results = CSV.open("ncaa_teams.csv","w")

begin
  page = agent.get(url)
rescue
  print "  -> error, retrying\n"
  retry
end

path="//*[@id='edit-searchOrg']"

#puts page.parser.xpath(path).to_html

page.parser.xpath(path).each do |menu|

  menu.xpath("option").each do |option|
    team_id = option.attributes["value"].value
    team_name = option.inner_text
    results << [team_id,team_name]
    results.flush
  end

end

results.close
