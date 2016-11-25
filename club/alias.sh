#!/bin/bash

psql soccer -f alias/teams.sql

psql soccer -f alias/teams_all.sql

psql soccer -f alias/games.sql
