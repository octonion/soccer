#!/bin/bash

psql soccer -f table.sql > table.txt

./sims2.py

dos2unix sims2.csv
rpl ",," "," sims2.csv
rpl -q ".0" "" sims2.csv

cp sims2.csv /tmp/sims.csv

psql soccer -f sims2.sql

psql soccer -f seeds.sql

psql soccer -f table2.sql > table2.txt

./table_md.sh
