#!/usr/bin/env ruby

require 'csv'

require 'nokogiri'
require 'mechanize'

agent = Mechanize.new{ |agent| agent.history.max_size=0 }
agent.user_agent = 'Mozilla/5.0'

first_year = ARGV[0]
last_year = ARGV[1]

leagues = CSV.open("tsv/leagues_hidden.tsv",
                   "r",
                   {:col_sep => "\t", :headers => TRUE})

leagues.each do |league|

  t_league_key = league["league_key"]

  (first_year..last_year).each do |year|

    clubs = CSV.open("tsv/clubs_#{year}.tsv",
                     "r",
                     {:col_sep => "\t", :headers => TRUE})

    league_clubs = []
    clubs.each do |club|
      league_id = club["league_id"]
      league_key = club["league_key"]
      club_id = club["club_id"]
      club_key = club["club_key"]
      club_name = club["club_name"]
      club_url = club["club_url"]

      if not(league_key==t_league_key)
        next
      end

      league_clubs << club

    end

    if (league_clubs.size==0)
      next
    end

    games = CSV.open("tsv/games_#{t_league_key}_#{year}.tsv",
                     "w",
                     {:col_sep => "\t"})

    #http://www.espnfc.us/club/arsenal/359/fixtures?leagueId=0&season=2015
    #&seasonType=1
  
    # Header for game file

    games << ["year", "league_id", "league_key",
              "club_id", "club_key", "club_name", "club_url",
              "game_id", "game_url",
              "date", "date_headline", "status", "league",
              "home_logo_src", "home_logo_alt", "home_team_id", "home_team_name",
              "home_score", "home_goals", "home_pk",
              "away_score", "away_goals", "away_pk",
              "away_logo_src", "away_logo_alt", "away_team_id", "away_team_name",
              "competition", "title"
             ]

    game_xpath = '//div[@class="games-container"]/a'

    league_clubs.each do |club|

      league_id = club["league_id"]
      league_key = club["league_key"]
      club_id = club["club_id"]
      club_key = club["club_key"]
      club_name = club["club_name"]
      club_url = club["club_url"]

      if not(league_key==t_league_key)
        next
      end

      url = club_url.gsub("index", "fixtures")+"?leagueId=0&season=#{year}"
      #&seasonType=1"

      print "pulling #{league_key}/#{year}/#{club_name}"

      begin
        doc = Nokogiri::HTML(agent.get(url).body)
      # doc = Nokogiri::HTML(open(url))
      rescue
        print " ... sleeping"
        sleep 10
        retry
      end

      found = 0
      doc.xpath(game_xpath).each do |game|

        game_id = game.attribute("data-gameid").text
        game_url = game.attribute("href").text

        row = [year, league_id, league_key,
               club_id, club_key, club_name, club_url,
               game_id, game_url]
    
        #p game.attributes

        # Date, status

        #container = game.search("div[@class='score-column score-date']").first

        container = game.xpath("div[contains(@class,'score-date')]").first

        date = container.search("div[@class='date']").first.text.strip rescue nil
        headline = container.search("div[@class='headline']").first.text.strip rescue nil
        status = container.search("div[@class='status']").first.text.strip rescue nil
        league = container.search("div[@class='league']").first.text.strip rescue nil

        row += [date, headline, status, league]

        # Home team

        container = game.xpath("div[contains(@class,'score-home-team')]").first

        logo = container.search("div[@class='team-logo']/img").first
        logo_src = logo.attribute("src").text.strip rescue nil

        team_id = logo_src.split("/")[-1].split(".")[0] rescue nil
        if (team_id.include?("default"))
          team_id = nil
        end
    
        logo_alt = logo.attribute("alt").text.strip rescue nil
    
        team_name = container.search("div[contains(@class,'team-name')]").first.text.strip rescue nil

        row += [logo_src, logo_alt, team_id, team_name]

        # Result

        container = game.xpath("div[contains(@class,'score-result')]").first

        home_score = container.xpath("div/span[contains(@class,'home-score')]").first.text.strip rescue nil
        away_score = container.xpath("div/span[contains(@class,'away-score')]").first.text.strip rescue nil

        if (home_score.size==0)
          home_score = nil
        end

        if (away_score.size==0)
          away_score = nil
        end

        if not(home_score==nil) and (home_score.include?(" "))
          home_goals = home_score.split(" ")[1]
          home_pk = home_score.split(" ")[0].gsub("(","").gsub(")","")
        else
          home_goals = home_score
          home_pk = nil
        end

        if not(away_score==nil) and (away_score.include?(" "))
          away_goals = away_score.split(" ")[0]
          away_pk = away_score.split(" ")[1].gsub("(","").gsub(")","")
        else
          away_goals = away_score
          away_pk = nil
        end

        row += [home_score, home_goals, home_pk, away_score, away_goals, away_pk]

        # Away team

      container = game.xpath("div[contains(@class,'score-away-team')]").first

      logo = container.search("div[@class='team-logo']/img").first
      logo_src = logo.attribute("src").text.strip rescue nil

      team_id = logo_src.split("/")[-1].split(".")[0] rescue nil
      if (team_id.include?("default"))
        team_id = nil
      end
    
      logo_alt = logo.attribute("alt").text.strip rescue nil
    
      team_name = container.search("div[contains(@class,'team-name')]").first.text.strip rescue nil

      row += [logo_src, logo_alt, team_id, team_name]

      # Competition

      container = game.xpath("div[contains(@class,'score-competition')]").first

      competition = container.text rescue nil
      title = container.attribute("title").text rescue nil

      row += [competition, title]

      games << row
    
      #name = club.attribute("name").text
      #club_key = name.split(":")[-1]
      #club_name = club.text
      #club_url = club.attribute("href").text
      #club_id = club_url.split("/")[-2]
      #clubs << [league_id, league_key, club_id, club_key, club_name, club_url]
      found += 1
    end

    print " - found #{found} games\n"

    end

  end

end
