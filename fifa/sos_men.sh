#!/bin/bash

psql soccer -c "drop table if exists fifa.results;"

psql soccer -f sos_men/standardized_results.sql

psql soccer -c "vacuum full verbose analyze fifa.results;"

psql soccer -c "drop table if exists fifa.men_basic_factors;"
psql soccer -c "drop table if exists fifa.men_parameter_levels;"

R --vanilla -f sos_men/lmer.R

psql soccer -c "vacuum full verbose analyze fifa.men_parameter_levels;"
psql soccer -c "vacuum full verbose analyze fifa.men_basic_factors;"

psql soccer -f sos_men/normalize_factors.sql
psql soccer -c "vacuum full verbose analyze fifa.men_factors;"

psql soccer -f sos_men/schedule_factors.sql
psql soccer -c "vacuum full verbose analyze fifa.men_schedule_factors;"

psql soccer -f sos_men/current_ranking.sql > sos_men/current_ranking.txt
cp /tmp/current_ranking.csv sos_men/current_ranking.csv
