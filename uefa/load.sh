#!/bin/bash

cmd="psql template1 --tuples-only --command \"select count(*) from pg_database where datname = 'soccer';\""

db_exists=`eval $cmd`
 
if [ $db_exists -eq 0 ] ; then
   cmd="createdb soccer;"
   eval $cmd
fi

psql soccer -f schema/create_schema.sql

tail -q -n+2 csv/england/200[89]_E0.csv csv/england/201[012]_E0.csv >> /tmp/games.csv
psql soccer -f loaders/load_games_2008-2012.sql
rm /tmp/games.csv

tail -q -n+2 csv/england/2013_E0.csv >> /tmp/games.csv
psql soccer -f loaders/load_games_2013.sql
rm /tmp/games.csv

tail -q -n+2 csv/england/201[45]_E0.csv >> /tmp/games.csv
psql soccer -f loaders/load_games_2014-2015.sql
rm /tmp/games.csv

#psql soccer -f schema/create_teams.sql
