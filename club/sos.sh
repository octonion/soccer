#!/bin/bash

psql soccer -f sos/standardized_results.sql

psql soccer -c "drop table club._basic_factors;"
psql soccer -c "drop table club._parameter_levels;"
psql soccer -c "drop table club._factors;"
psql soccer -c "drop table club._schedule_factors;"

R --vanilla -f sos/lmer.R

psql soccer -f sos/normalize_factors.sql
psql soccer -f sos/schedule_factors.sql

psql soccer -f sos/current_ranking.sql > sos/current_ranking.txt
cp /tmp/current_ranking.csv sos/current_ranking.csv
