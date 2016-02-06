#!/bin/bash

psql soccer -f leagues/standardized_results.sql

psql soccer -c "drop table club._basic_factors;"
psql soccer -c "drop table club._parameter_levels;"
psql soccer -c "drop table club._factors;"
psql soccer -c "drop table club._schedule_factors;"

R --vanilla -f leagues/lmer.R

psql soccer -f leagues/normalize_factors.sql
psql soccer -f leagues/schedule_factors.sql

psql soccer -f leagues/current_ranking.sql > leagues/current_ranking.txt
cp /tmp/current_ranking.csv leagues/current_ranking.csv
