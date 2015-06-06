#!/usr/bin/env ruby

require 'csv'
require 'open-uri'
require 'json'
require 'mechanize'
agent = Mechanize.new{ |agent| agent.history.max_size=0 }
agent.user_agent = 'Mozilla/5.0'

base = "http://www.fifa.com/live/world-match-centre/library/fixtures/bymonth/idcupseason"

title_path = '//*[@class="compName"]'
st1_path = '//*[@class="m-listSubT"]'
live_path = '//*[@class="liveLabel"]'
mlist_path = '//*[@class="m-list indexwmc"]'

match_path = '//*[@class="m-head" or @class="m filterable-match mc-match-is-result"]'

head_type = "m-head"
result_type = "m filterable-match mc-match-is-result"

gender_id = ARGV[0]

year_file = "json/years_#{gender_id}.json"
years = JSON.parse(File.read(year_file))

years.each do |year_row|

  year = year_row[0]

  results = CSV.open("csv/results_#{gender_id}_#{year}.csv","w")

  comp_file = "json/competitions_#{gender_id}_#{year}.json"

  comp_months = JSON.parse(File.read(comp_file))

comp_months.each do |comp_month|

  month_text = comp_month[0]
  month_start = Date.strptime(month_text, "%Y-%m-%d")
  month = month_start.month

  comp_month[1].each do |comp|
    cup_name = comp["CupName"]
    idcupseason = comp["IdCupSeason"]
    num_order = comp["NumOrder"]

    date = month_text.gsub("-","")

    url = "#{base}=#{idcupseason}/date=#{date}/_matchesBoxed.html"

    print "#{gender_id} - #{year} - #{month} - #{cup_name}\n"

    page = agent.get(url)
    doc = page.parser

    title = doc.xpath(title_path).first.text.scrub.strip rescue nil
    st1 = doc.xpath(st1_path).first.text.scrub.strip rescue nil
    live = doc.xpath(live_path).first.text.scrub.strip rescue nil

    match_date = nil
    comp_group = nil

    doc.xpath(match_path).each_with_index do |m,i|
    
      class_id = m.attributes["class"].to_s
      case class_id
      when head_type
        match_date = m.xpath('div[@class="m-date"]').first.text.scrub.strip rescue nil
        comp_group = m.xpath('div/span[@class="m-compgroup-text"]').first.text.scrub.strip rescue nil
      when result_type
        data_id = m.attributes["data-id"].to_s.scrub.strip rescue nil
        data_matchdate = m.attributes["data-matchdate"].to_s.scrub.strip rescue nil

        home_name = nil
        home_url = nil
        home_id = nil
        m.xpath('div[@class="t home"]').each do |th|
          home_name = th.text.scrub.strip rescue nil
          a = th.xpath("a").first
          home_url = a.attributes["href"].to_s.scrub.strip rescue nil
          home_id = home_url.split("=")[1].split("/")[0]
        end

        away_name = nil
        away_url = nil
        away_id = nil
        m.xpath('div[@class="t away"]').each do |ta|
          away_name = ta.text.scrub.strip rescue nil
          a = ta.xpath("a").first
          away_url = a.attributes["href"].to_s.scrub.strip rescue nil
          away_id = away_url.split("=")[1].split("/")[0]
        end
               
        score = m.xpath('div[@class="s"]').first.text.scrub.strip rescue nil
        venue = m.xpath('div[@class="m-venue"]').first.text.scrub.strip rescue nil

        row = [gender_id, year, month, cup_name, idcupseason,
               match_date, comp_group, data_id, data_matchdate,
               home_id, home_name, home_url,
               away_id, away_name, away_url,
               score, venue]

        results << row
          
      end
      
    end

  end
  results.flush

end

results.close
end
