begin;

create table ncaa.schools_divisions (
	sport_code		text,
	school_name		text,
	school_id		integer,
	pulled_name		text,
	javascript		text,
	year			integer,
	div_id			integer,
        school_year		text,
	sport			text,
	division		text,
	primary key (school_id,year)
);

copy ncaa.schools_divisions from '/tmp/ncaa_divisions.csv' with delimiter as ',' csv header quote as '"';

commit;
