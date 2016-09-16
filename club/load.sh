#!/bin/bash

# Database

echo
echo "Creating database"
echo

cmd="psql template1 --tuples-only --command \"select count(*) from pg_database where datname = 'soccer';\""

db_exists=`eval $cmd`
 
if [ $db_exists -eq 0 ] ; then
   cmd="createdb soccer"
   eval $cmd
fi

# Schema

echo
echo "Creating schema"
echo

psql soccer -f schema/club.sql

echo
echo "Leagues"
echo

cp tsv/leagues.tsv /tmp/leagues.tsv
#tail -q -n+2 tsv/leagues_hidden.tsv >> /tmp/leagues.tsv
psql soccer -f loaders/leagues.sql
rm /tmp/leagues.tsv

echo
echo "Teams"
echo

tail -q -n+2 tsv/clubs_*.tsv >> /tmp/teams.tsv
psql soccer -f loaders/teams.sql
rm /tmp/teams.tsv

echo
echo "Games"
echo

tail -q -n+2 tsv/games_*.tsv >> /tmp/games.tsv
psql soccer -f loaders/games.sql
rm /tmp/games.tsv
