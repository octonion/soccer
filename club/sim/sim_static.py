#!/usr/bin/python3

import sys
import csv
import datetime
import psycopg2

import numpy as np

import pandas as pd

games = pd.read_csv('games.csv', dtype={'w' : np.float,
                                        'd' : np.float,
                                        'l' : np.float})
table = pd.read_csv('table.csv')

team = []
w = []
d = []
l = []

r = np.random.uniform(low=0.0, high=1.0, size=len(games))

for i, game in games.iterrows():

    team.extend([game['team_name'],game['opponent_name']])

    if (r[i] < game['w']):
        w.extend([1,0])
        d.extend([0,0])
        l.extend([0,1])
    elif (r[i] < game['w']+game['d']):
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
