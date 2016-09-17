#!/bin/bash

league_key=$1
#year=$2

rpl "'dummy_league_key'" "'"$league_key"'" *.sql *.py

psql soccer -f table.sql > $league_key.txt

./sims2.py

dos2unix sims2.csv
rpl ",," "," sims2.csv
rpl -q ".0" "" sims2.csv

cp sims2.csv /tmp/sims.csv

mv sims2.csv $league_key.csv

psql soccer -f sims2.sql

psql soccer -f seeds.sql

psql soccer -f table2.sql > table2.txt

./table_md.sh $league_key

rm table2.txt

rpl "'"$league_key"'" "'dummy_league_key'" *.sql *.py
