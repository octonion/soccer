#!/bin/bash

psql soccer -c "drop table if exists fifa.results;"

psql soccer -f sos_test/standardized_results.sql

psql soccer -c "vacuum full verbose analyze fifa.results;"

psql soccer -c "drop table if exists fifa.men_basic_factors;"
psql soccer -c "drop table if exists fifa.men_parameter_levels;"

R --vanilla -f sos_test/lmer.R

psql soccer -c "vacuum full verbose analyze fifa.men_parameter_levels;"
psql soccer -c "vacuum full verbose analyze fifa.men_basic_factors;"

psql soccer -f sos_test/normalize_factors.sql
psql soccer -c "vacuum full verbose analyze fifa.men_factors;"

psql soccer -f sos_test/schedule_factors.sql
psql soccer -c "vacuum full verbose analyze fifa.men_schedule_factors;"

psql soccer -f sos_test/current_ranking.sql > sos_test/current_ranking.txt
cp /tmp/current_ranking.csv sos_test/current_ranking.csv
