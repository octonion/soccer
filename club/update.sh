#!/bin/bash

./scrapers/all_games.rb 2016 2016

./load.sh

#psql soccer -f cleaning/teams.sql
#./alias/

./clean.sh
./alias.sh

psql soccer -f sql/league_sizes.sql
psql soccer -f keys/intraleague_keys.sql

./sos_leagues.sh

cd sim_results

./sim.sh english+premier+league
./sim.sh english+league+championship
./sim.sh english+league+one
./sim.sh english+league+two
./sim.sh english+national+league
./sim.sh french+ligue+1
./sim.sh german+bundesliga
./sim.sh italian+serie+a
./sim.sh spanish+primera+división
