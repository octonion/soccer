#!/bin/bash

./scrapers/all_games.rb 2016 2016
#./scrapers/all_xml.rb 2016 2016

./load.sh
#./load_gamecast.sh

./clean.sh
./alias.sh

psql soccer -f sql/league_sizes.sql
psql soccer -f keys/intraleague_keys.sql

./sos_leagues.sh

cd python
./predict.py

cd ..
