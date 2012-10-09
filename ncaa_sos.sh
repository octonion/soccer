#!/bin/bash

psql soccer -f ncaa_sos/standardized_results.sql

psql soccer -c "drop table ncaa._basic_factors;"
psql soccer -c "drop table ncaa._parameter_levels;"
psql soccer -c "drop table ncaa._factors;"
psql soccer -c "drop table ncaa._schedule_factors;"
#psql soccer -c "drop table ncaa._game_results;"

R --vanilla < ncaa_sos/ncaa_lmer.R

psql soccer -f ncaa_sos/normalize_factors.sql
psql soccer -f ncaa_sos/schedule_factors.sql

psql soccer -f ncaa_sos/connectivity.sql > ncaa_sos/connectivity.txt
psql soccer -f ncaa_sos/current_ranking.sql > ncaa_sos/current_ranking.txt
psql soccer -f ncaa_sos/division_ranking.sql > ncaa_sos/division_ranking.txt

psql soccer -f ncaa_sos/test_predictions.sql > ncaa_sos/test_predictions.txt
