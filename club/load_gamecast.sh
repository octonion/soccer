#!/bin/bash

echo
echo "Gamecast"
echo

cat csv/*/*/games.csv >> /tmp/gamecast.csv
psql soccer -f loaders/gamecast.sql
rm /tmp/gamecast.csv

cat csv/*/*/attacks.csv >> /tmp/attacks.csv
rpl -q ",null," ",," /tmp/attacks.csv
rpl "[" "{" /tmp/attacks.csv
rpl "]" "}" /tmp/attacks.csv
sort /tmp/attacks.csv | uniq > /tmp/au.csv
mv /tmp/au.csv /tmp/attacks.csv
psql soccer -f loaders/attacks.sql
#rm /tmp/attacks.csv

