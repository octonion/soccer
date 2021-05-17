#!/bin/bash

psql soccer -c "drop table if exists dstv.results;"

psql soccer -f sos/standardized_results.sql

psql soccer -c "vacuum full verbose analyze dstv.results;"

psql soccer -c "drop table if exists dstv._basic_factors;"
psql soccer -c "drop table if exists dstv._parameter_levels;"

R --vanilla -f sos/lmer.R

psql soccer -c "vacuum full verbose analyze dstv._parameter_levels;"
psql soccer -c "vacuum full verbose analyze dstv._basic_factors;"

psql soccer -f sos/normalize_factors.sql
psql soccer -c "vacuum full verbose analyze dstv._factors;"

psql soccer -f sos/schedule_factors.sql
psql soccer -c "vacuum full verbose analyze dstv._schedule_factors;"

psql soccer -f sos/current_ranking.sql > sos/current_ranking.txt
cp /tmp/current_ranking.csv sos/current_ranking.csv

psql soccer -f sos/predictions.sql > sos/predictions.txt
cp /tmp/predictions.csv sos/predictions.csv
