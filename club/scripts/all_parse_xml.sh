#!/bin/bash

first=$1
last=$2

IFS=$'\t'
while read league_id league_key rest; do

    if [ "$league_key" == "league_key" ]; then
	continue
    fi

    for ((year=$first; year<=$last; year++)); do
	echo "Parsing "$league_key/$year
	./parsers/gamecast.rb csv/$league_key/$year xml/$league_key/$year/gamecast_*.xml
    done

done <tsv/leagues.tsv
