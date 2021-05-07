#!/bin/bash

psql soccer -c "drop table if exists bundesliga.results;"

psql soccer -f sos/standardized_results.sql

psql soccer -c "vacuum full verbose analyze bundesliga.results;"

psql soccer -c "drop table if exists bundesliga._basic_factors;"
psql soccer -c "drop table if exists bundesliga._parameter_levels;"

R --vanilla -f sos/lmer.R

psql soccer -c "vacuum full verbose analyze bundesliga._parameter_levels;"
psql soccer -c "vacuum full verbose analyze bundesliga._basic_factors;"

psql soccer -f sos/normalize_factors.sql
psql soccer -c "vacuum full verbose analyze bundesliga._factors;"

psql soccer -f sos/schedule_factors.sql
psql soccer -c "vacuum full verbose analyze bundesliga._schedule_factors;"

psql soccer -f sos/current_ranking.sql > sos/current_ranking.txt
cp /tmp/current_ranking.csv sos/current_ranking.csv

psql soccer -f sos/predictions.sql > sos/predictions.txt
cp /tmp/predictions.csv sos/predictions.csv
