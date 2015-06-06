#!/bin/bash

psql soccer -c "drop table if exists fifa.results;"

psql soccer -f sos2/standardized_results.sql

psql soccer -c "vacuum full verbose analyze fifa.results;"

psql soccer -c "drop table if exists fifa._basic_factors;"
psql soccer -c "drop table if exists fifa._parameter_levels;"

R --vanilla -f sos2/lmer.R

psql soccer -c "vacuum full verbose analyze fifa._parameter_levels;"
psql soccer -c "vacuum full verbose analyze fifa._basic_factors;"

psql soccer -f sos2/normalize_factors.sql
psql soccer -c "vacuum full verbose analyze fifa._factors;"

psql soccer -f sos2/schedule_factors.sql
psql soccer -c "vacuum full verbose analyze fifa._schedule_factors;"

psql soccer -f sos2/current_ranking.sql > sos2/current_ranking.txt
cp /tmp/current_ranking.csv sos2/current_ranking.csv
