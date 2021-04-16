#!/bin/bash

cmd="psql template1 --tuples-only --command \"select count(*) from pg_database where datname = 'soccer';\""

db_exists=`eval $cmd`
 
if [ $db_exists -eq 0 ] ; then
   cmd="createdb soccer;"
   eval $cmd
fi

psql soccer -f schema/create_schema.sql

mkdir /tmp/data
cp csv/mls*.csv /tmp/data

#dos2unix /tmp/data/*
tail -q -n+2 /tmp/data/*.csv >> /tmp/games.csv
sed -e 's/$/,,/' -i /tmp/games.csv

#rpl -q " FC," "," /tmp/games.csv

psql soccer -f loaders/load_games.sql

rm /tmp/data/*.csv
rmdir /tmp/data
rm /tmp/games.csv
