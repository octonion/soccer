#!/bin/bash

psql soccer -f leagues/standardized_results.sql

psql soccer -c "vacuum analyze club.results;"

psql soccer -c "drop table club._basic_factors;"
psql soccer -c "drop table club._parameter_levels;"
psql soccer -c "drop table club._factors;"
psql soccer -c "drop table club._schedule_factors;"

R --vanilla -f leagues/lmer.R

psql soccer -c "vacuum full verbose analyze club._parameter_levels;"
psql soccer -c "vacuum full verbose analyze club._basic_factors;"

psql soccer -f leagues/normalize_factors.sql
psql soccer -c "vacuum full verbose analyze club._factors;"

psql soccer -f leagues/schedule_factors.sql
psql soccer -c "vacuum full verbose analyze club._schedule_factors;"

psql soccer -f leagues/current_ranking.sql > leagues/current_ranking.txt
cp /tmp/current_ranking.csv leagues/current_ranking.csv

psql soccer -f leagues/league_ranking.sql > leagues/league_ranking.txt
cp /tmp/league_ranking.csv leagues/league_ranking.csv

psql soccer -f leagues/connectivity.sql > leagues/connectivity.txt
cp /tmp/connectivity.csv leagues/connectivity.csv
