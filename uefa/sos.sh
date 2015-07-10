#!/bin/bash

psql soccer -c "drop table if exists uefa.results;"

psql soccer -f sos/standardized_results.sql

psql soccer -c "vacuum full verbose analyze uefa.results;"

psql soccer -c "drop table if exists uefa._basic_factors;"
psql soccer -c "drop table if exists uefa._parameter_levels;"

R --vanilla -f sos/lmer.R

psql soccer -c "vacuum full verbose analyze uefa._parameter_levels;"
psql soccer -c "vacuum full verbose analyze uefa._basic_factors;"

psql soccer -f sos/normalize_factors.sql
psql soccer -c "vacuum full verbose analyze uefa._factors;"

psql soccer -f sos/schedule_factors.sql
psql soccer -c "vacuum full verbose analyze uefa._schedule_factors;"

psql soccer -f sos/current_ranking.sql > sos/current_ranking.txt
cp /tmp/current_ranking.csv sos/current_ranking.csv
