#!/bin/bash

first=$1
last=$2

IFS=$'\t'
while read league_id league_key rest; do

    if [ "$league_key" = "league_key" ]; then
	continue
    fi
    echo $league_key

    for year in `seq $first $last`; do
	echo $league_key/$year
	./parsers/gamecast.rb csv/$league_key/$year xml/$league_key/$year/gamecast_*.xml
    done

done <tsv/leagues.tsv
