#!/bin/bash

echo
echo "Gamecast"
echo

cat csv/*/*/gamecast.csv >> /tmp/gamecast.csv
psql soccer -f loaders/gamecast.sql
rm /tmp/gamecast.csv

cat csv/*/*/attacks.csv >> /tmp/attacks.csv
rpl -q ",null," ",," /tmp/attacks.csv
rpl "[" "{" /tmp/attacks.csv
rpl "]" "}" /tmp/attacks.csv
rpl ",*," ",," /tmp/attacks.csv
psql soccer -f loaders/attacks.sql
rm /tmp/attacks.csv

cat csv/*/*/shots.csv >> /tmp/shots.csv
psql soccer -f loaders/shots.sql
rm /tmp/shots.csv

cat csv/*/*/parts.csv >> /tmp/parts.csv
psql soccer -f loaders/parts.sql
rm /tmp/parts.csv
