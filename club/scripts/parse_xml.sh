#!/bin/bash

league=$1
first=$2
last=$3

for ((year=$first; year<=$last; year++)); do
    echo $league/$year
    ./parsers/gamecast.rb csv/$1/$year xml/$league/$year/gamecast_*.xml
done
