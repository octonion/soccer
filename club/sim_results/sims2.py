#!/usr/bin/python3

import sys
import csv
import datetime
import psycopg2

import numpy as np

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
g.team_name,
g.opponent_name,
(exp(i.estimate)*y.exp_factor*tf.exp_factor*teo.exp_factor*sft.offensive*opd.exp_factor*sfo.defensive) as etg,
(exp(i.estimate)*y.exp_factor*of.exp_factor*opo.exp_factor*sfo.offensive*ted.exp_factor*sft.defensive) as eog
from club.results g

join club.teams t
  on (t.club_id,t.year)=(g.team_id,g.year)
join club._schedule_factors sft
  on (sft.team_id,sft.year)=(g.team_id,g.year)
join club.teams o
  on (o.club_id,o.year)=(g.opponent_id,g.year)
join club._schedule_factors sfo
  on (sfo.team_id,sfo.year)=(g.opponent_id,g.year)

join club._factors teo
  on (teo.parameter,teo.level)=('offense_league',t.league_key)
join club._factors ted
  on (ted.parameter,ted.level)=('defense_league',t.league_key)

join club._factors opo
  on (opo.parameter,opo.level)=('offense_league',o.league_key)
join club._factors opd
  on (opd.parameter,opd.level)=('defense_league',o.league_key)

join club._factors tf on
  tf.level='offense_home'
join club._factors of on
  of.level='defense_home'
join club.intraleague_keys ik
  on (ik.league_key,ik.intraleague_key)=(g.team_league_key,g.competition)

join club._factors y on
  y.level='2017'

join club._basic_factors i on
  i.factor='(Intercept)'

where
    g.team_league_key = 'dummy_league_key'
--and g.competition='Bund'

and ((g.game_date >= current_date) or (g.year=2017 and g.status='Postp'))

--and (g.game_date >= current_date)
--and g.status is null

and ((g.team_score is null) or
     (g.opponent_score is null) or
     (g.status='Aban') or
     (g.status like '%'''))

and g.field='offense_home'

order by g.team_name asc,g.game_date asc
;
"""

cur = conn.cursor()
cur.execute(select_games)

games = cur.fetchall()

select_table = """
select
g.team_name as team,

sum(
case when (team_score > opponent_score) then 1
else 0
end) as w,
sum(
case when (team_score=opponent_score) then 1
else 0
end) as d,
sum(
case when (team_score < opponent_score) then 1
else 0
end) as l,
sum(team_score) as gf,
sum(opponent_score) as ga

from club.results g
join club.intraleague_keys ik
  on (ik.league_key,ik.intraleague_key)=(g.team_league_key,g.competition)

where

    g.team_league_key = 'dummy_league_key'
--and g.competition='Bund'
and g.year=2017
and g.game_date <= current_date
and g.team_score is not null
and g.opponent_score is not null
and not(g.status like '%''')

group by g.team_name
order by g.team_name asc
;
"""

cur.execute(select_table)
table = pd.DataFrame(cur.fetchall(),
                     columns=['team','w','d','l','gf','ga'])

with open('sims2.csv', 'w') as f:

    header = ['team','n','rank','w','d','l','gf','ga','gd','pts']
    csv.writer(f).writerows([header])

    for j in range(10000):

        team = []
        w = []
        d = []
        l = []
        gf = []
        ga = []
    
        for i,game in enumerate(games):

            tg = np.random.poisson(lam=game[2])
            og = np.random.poisson(lam=game[3])    
    
            team.extend([game[0],game[1]])
            gf.extend([tg, og])
            ga.extend([og, tg])
            #    gd.extend([tg-og, og-tg])
    
            if (tg > og):
                w.extend([1,0])
                d.extend([0,0])
                l.extend([0,1])
            elif (tg == og):
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
               'l' : l,
               'gf' : gf,
               'ga' : ga}

        ros = pd.DataFrame(sim,
                           columns = ['team','w','d','l','gf','ga'])

        df = pd.concat([table, ros], axis=0)

        season = df.groupby(['team']).agg({'w' : sum,
                                           'd' : sum,
                                           'l' : sum,
                                           'gf' : sum,
                                           'ga' : sum})

        season['gd'] = season['gf']-season['ga']
        season['pts'] = 3*season['w']+season['d']

        final = season.sort_values(by=['pts', 'gd', 'gf'], ascending=[0, 0, 0])

        final['i'] = final['pts']*1000000+(final['gd']+100)*1000+final['gf']

        final['rank'] = final['i'].rank(ascending=0, method='min')

        final.drop(['i'],inplace=True,axis=1)
        final['n'] = j

        final.to_csv(f, columns=['team','n','rank','w','d','l','gf','ga','gd','pts'], header=False)
