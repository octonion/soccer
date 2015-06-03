begin;

create table ncaa.schools (
        school_id               integer,
        school_name             text,
	primary key (school_id)
);

copy ncaa.schools from '/tmp/ncaa_schools.csv' with delimiter as ',' csv header quote as '"';

commit;
