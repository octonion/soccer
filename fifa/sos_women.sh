#!/bin/bash

psql soccer -c "drop table if exists fifa.results;"

psql soccer -f sos_women/standardized_results.sql

psql soccer -c "vacuum full verbose analyze fifa.results;"

psql soccer -c "drop table if exists fifa.women_basic_factors;"
psql soccer -c "drop table if exists fifa.women_parameter_levels;"

R --vanilla -f sos_women/lmer.R

psql soccer -c "vacuum full verbose analyze fifa.women_parameter_levels;"
psql soccer -c "vacuum full verbose analyze fifa.women_basic_factors;"

psql soccer -f sos_women/normalize_factors.sql
psql soccer -c "vacuum full verbose analyze fifa.women_factors;"

psql soccer -f sos_women/schedule_factors.sql
psql soccer -c "vacuum full verbose analyze fifa.women_schedule_factors;"

psql soccer -f sos_women/current_ranking.sql > sos_women/current_ranking.txt
cp /tmp/current_ranking.csv sos_women/current_ranking.csv
