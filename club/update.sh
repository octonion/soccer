#!/bin/bash

./scrapers/all_games.rb $1 $2
./scrapers/all_xml.rb $1 $2

./scripts/all_parse_xml.sh $1 $2

./load.sh
./load_gamecast.sh

./clean.sh
./alias.sh

psql soccer -f sql/league_sizes.sql
psql soccer -f keys/intraleague_keys.sql

./sos_leagues.sh

cd python
./predict.py

cd ..
