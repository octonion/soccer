#!/bin/bash

cp rounds_updated.csv /tmp/rounds.csv

# Generic 33.3% for overtime

#psql soccer -f load_rounds.sql

# Model estimate for overtime

psql soccer -f load_rounds_eot.sql

rm /tmp/rounds.csv

psql soccer -f update_round.sql

rpl "round_id=1" "round_id=2" update_round.sql
psql soccer -f update_round.sql

rpl "round_id=2" "round_id=3" update_round.sql
psql soccer -f update_round.sql

rpl "round_id=3" "round_id=1" update_round.sql

psql soccer -f round_p.sql > round_p.txt
cp /tmp/round_p.csv .

psql soccer -f champion_p.sql > champion_p.txt
cp /tmp/champion_p.csv .
