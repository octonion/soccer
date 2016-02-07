#!/usr/bin/python3

import sys
import csv
import datetime
import psycopg2

from scipy.special import comb

try:
    conn = psycopg2.connect("dbname='soccer'")
except:
    print("Can't connect to database.")
    sys.exit()

today = datetime.datetime.now()
start = today.strftime("%F")
end = today + datetime.timedelta(days=6)

select = """
select
ts.date::date,
'home',
t.league_key,
t.club_name,
(tf.exp_factor*sft.offensive),
o.league_key,
o.club_name,
(of.exp_factor*sfo.offensive),

skellam(teo.exp_factor*tf.exp_factor*sft.offensive*opd.exp_factor,opo.exp_factor*of.exp_factor*sfo.offensive*ted.exp_factor,'win') as win,
skellam(teo.exp_factor*tf.exp_factor*sft.offensive*opd.exp_factor,opo.exp_factor*of.exp_factor*sfo.offensive*ted.exp_factor,'lose') as lose,
skellam(teo.exp_factor*tf.exp_factor*sft.offensive*opd.exp_factor,opo.exp_factor*of.exp_factor*sfo.offensive*ted.exp_factor,'draw') as draw

from club.games ts
join club.teams t
  on (t.club_id,t.year)=(ts.home_team_id,ts.year)
join club._schedule_factors sft
  on (sft.team_id,sft.year)=(ts.home_team_id,ts.year)
join club.teams o
  on (o.club_id,o.year)=(ts.away_team_id,ts.year)
join club._schedule_factors sfo
  on (sfo.team_id,sfo.year)=(ts.away_team_id,ts.year)
join club._factors tf on
  tf.level='offense_home'
join club._factors of on
  of.level='defense_home'
join club._factors teo
  on (teo.parameter,teo.level)=('offense_league',t.league_key)
join club._factors ted
  on (ted.parameter,ted.level)=('defense_league',t.league_key)
join club._factors opo
  on (opo.parameter,opo.level)=('offense_league',o.league_key)
join club._factors opd
  on (opd.parameter,opd.level)=('defense_league',o.league_key)
where not(ts.date='LIVE')
and ts.date::date between current_date and current_date+6
and ts.club_id=ts.home_team_id
order by ts.date::date asc,ts.club_name asc
;
"""

cur = conn.cursor()
cur.execute(select)

rows = cur.fetchall()

csvfile = open('predict_league.csv', 'w', newline='')
predict = csv.writer(csvfile)

header = ["game_date","team_lg","team","site","opponent","opponent_lg",
          "win","lose","draw"]

predict.writerow(header)

for row in rows:
    
    game_date = row[0]
    site = row[1]
    team_league = row[2]
    team = row[3]
    to = row[4]
    opponent_league = row[5]
    opponent = row[6]
    oo = row[7]
    win = row[8]
    lose = row[9]
    draw = row[10]

    win = "%4.3f" % win
    lose = "%4.3f" % lose
    draw = "%4.3f" % draw

    data = [game_date,team_league,team,site,opponent_league,opponent,win,lose,draw]

    predict.writerow(data)

csvfile.close()
