#!/usr/bin/python3

import sys
import csv
import datetime
import psycopg2

import numpy

import pandas as pd

try:
    conn = psycopg2.connect("dbname='soccer'")
except:
    print("Can't connect to database.")
    sys.exit()

today = datetime.datetime.now()
start = today.strftime("%F")
end = today + datetime.timedelta(days=6)

select_games = """
select
t.club_name as team_name,
o.club_name as opponent_name,

skellam(tf.exp_factor*sft.offensive,of.exp_factor*sfo.offensive,'win') as w,
skellam(tf.exp_factor*sft.offensive,of.exp_factor*sfo.offensive,'draw') as d,
skellam(tf.exp_factor*sft.offensive,of.exp_factor*sfo.offensive,'lose') as l

from club.games g
join club.teams t
  on (t.club_id,t.year)=(g.home_team_id,g.year)
join club._schedule_factors sft
  on (sft.team_id,sft.year)=(g.home_team_id,g.year)
join club.teams o
  on (o.club_id,o.year)=(g.away_team_id,g.year)
join club._schedule_factors sfo
  on (sfo.team_id,sfo.year)=(g.away_team_id,g.year)
join club._factors tf on
  tf.level='offense_home'
join club._factors of on
  of.level='defense_home'
where
    not(g.date='LIVE')
and g.league_key = 'english+premier+league'
and g.competition='Prem'
and g.date::date >= current_date
and g.home_goals is null
and g.away_goals is null
and g.club_id=g.home_team_id
order by g.club_name asc,g.date::date asc
;
"""

cur = conn.cursor()
cur.execute(select_games)

games = cur.fetchall()

select_table = """
select
g.club_name as team,
sum(
case when g.club_id=g.home_team_id
     and (home_goals > away_goals) then 1
     when club_id=away_team_id
     and (home_goals < away_goals) then 1
else 0
end) as w,
sum(
case when (home_goals=away_goals) then 1
else 0
end) as d,
sum(
case when club_id=home_team_id
     and (home_goals < away_goals) then 1
     when club_id=away_team_id
     and (home_goals > away_goals) then 1
else 0
end) as l

from club.games g
where
    not(g.date='LIVE')
and g.league_key = 'english+premier+league'
and g.competition='Prem'
and g.year=2016
and g.date::date <= current_date
and g.home_goals is not null
and g.away_goals is not null
group by g.club_name
order by g.club_name asc
;
"""

cur.execute(select_table)
table = pd.DataFrame(cur.fetchall(), columns=['team', 'w', 'd', 'l'])

team = []
w = []
d = []
l = []

r = numpy.random.uniform(low=0.0, high=1.0, size=len(games))

for i,game in enumerate(games):
    team.extend([game[0],game[1]])
    if (r[i] < game[2]):
        w.extend([1,0])
        d.extend([0,0])
        l.extend([0,1])
    elif (r[i] < game[2]+game[3]):
        w.extend([0,0])
        d.extend([1,1])
        l.extend([0,0])
    else:
        w.extend([0,1])
        d.extend([0,0])
        l.extend([1,0])

sim = {'team' : team,
       'w' : w,
       'd' : d,
       'l' : l}

ros = pd.DataFrame(sim, columns = ['team', 'w', 'd', 'l'])

df = pd.concat([table, ros], axis=0)

season = df.groupby(['team']).agg({'w' : sum,
                                   'd' : sum,
                                   'l' : sum})

print(season)

exit()
csvfile = open('sim.csv', 'w', newline='')
sim = csv.writer(csvfile)

header = ["game_date","team","site","opponent",
          "win","lose","draw"]

sim.writerow(header)

for row in rows:
    
    draw = row[4]

    win = "%4.3f" % win
    lose = "%4.3f" % lose
    draw = "%4.3f" % draw

    data = [game_date,team,site,opponent,win,lose,draw]

    sim.writerow(data)

csvfile.close()
