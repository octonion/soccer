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
t.club_name,
(tf.exp_factor*sft.offensive),
o.club_name,
(of.exp_factor*sfo.offensive),

skellam(tf.exp_factor*sft.offensive,of.exp_factor*sfo.offensive,'win') as win,
skellam(tf.exp_factor*sft.offensive,of.exp_factor*sfo.offensive,'lose') as lose,
skellam(tf.exp_factor*sft.offensive,of.exp_factor*sfo.offensive,'draw') as draw

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
where not(ts.date='LIVE')
and ts.date::date between current_date and current_date+6
and ts.club_id=ts.home_team_id
order by ts.date::date asc,ts.club_name asc
;
"""

cur = conn.cursor()
cur.execute(select)

rows = cur.fetchall()

csvfile = open('predict_weekly.csv', 'w', newline='')
predict = csv.writer(csvfile)

header = ["game_date","team","site","opponent",
          "win","lose","draw"]

predict.writerow(header)

for row in rows:
    
    game_date = row[0]
    site = row[1]
    team = row[2]
    to = row[3]
    opponent = row[4]
    oo = row[5]
    win = row[6]
    lose = row[7]
    draw = row[8]

    win = "%4.3f" % win
    lose = "%4.3f" % lose
    draw = "%4.3f" % draw

    data = [game_date,team,site,opponent,win,lose,draw]

    predict.writerow(data)

csvfile.close()
