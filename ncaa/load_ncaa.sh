#!/bin/bash

createdb soccer

psql soccer -f create_schema_ncaa.sql

tail -q -n+2 ncaa/ncaa_games_*.csv > /tmp/ncaa_games.csv
psql soccer -f load_ncaa_games.sql
rm /tmp/ncaa_games.csv

#cat ncaa/ncaa_players_*.csv > /tmp/ncaa_statistics.csv
#rpl ",-," ",," /tmp/ncaa_statistics.csv
#rpl ",-," ",," /tmp/ncaa_statistics.csv
#rpl ".," "," /tmp/ncaa_statistics.csv
#rpl ".0," "," /tmp/ncaa_statistics.csv
#rpl ".00," "," /tmp/ncaa_statistics.csv
#rpl ".000," "," /tmp/ncaa_statistics.csv
#rpl -e ",-\n" ",\n" /tmp/ncaa_statistics.csv
#psql soccer -f load_ncaa_statistics.sql
#rm /tmp/ncaa_statistics.csv

#psql soccer -f create_ncaa_players.sql

cp ncaa/schools.csv /tmp/ncaa_schools.csv
psql soccer -f load_ncaa_schools.sql
rm /tmp/ncaa_schools.csv

cp ncaa/ncaa_divisions.csv /tmp/ncaa_divisions.csv
psql soccer -f load_ncaa_divisions.sql
rm /tmp/ncaa_divisions.csv

cp ncaa/ncaa_colors.csv /tmp/ncaa_colors.csv
psql soccer -f load_ncaa_colors.sql
rm /tmp/ncaa_colors.csv

exit 0
