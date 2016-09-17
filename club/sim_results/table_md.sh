#!/bin/bash

league_key=$1

table=$league_key.md

head -n -2 table2.txt > $table
rpl -q '+' '|' $table
sed -i -e '/^$/d' $table
sed -i -e 's/^/|/' $table
sed -i -e 's/$/|/' $table
