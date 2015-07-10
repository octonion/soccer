begin;

--Div,Date,HomeTeam,AwayTeam,FTHG,FTAG,FTR,HTHG,HTAG,HTR,Referee,HS,AS,HST,AST,HF,AF,HC,AC,HY,AY,HR,AR,B365H,B365D,B365A,BWH,BWD,BWA,IWH,IWD,IWA,LBH,LBD,LBA,PSH,PSD,PSA,WHH,WHD,WHA,SJH,SJD,SJA,VCH,VCD,VCA,Bb1X2,BbMxH,BbAvH,BbMxD,BbAvD,BbMxA,BbAvA,BbOU,BbMx>2.5,BbAv>2.5,BbMx<2.5,BbAv<2.5,BbAH,BbAHh,BbMxAHH,BbAvAHH,BbMxAHA,BbAvAHA

--Div,Date,HomeTeam,AwayTeam,FTHG,FTAG,FTR,HTHG,HTAG,HTR,Referee,HS,AS,HST,AST,HF,AF,HC,AC,HY,AY,HR,AR,B365H,B365D,B365A,BWH,BWD,BWA,IWH,IWD,IWA,LBH,LBD,LBA,PSH,PSD,PSA,WHH,WHD,WHA,SJH,SJD,SJA,VCH,VCD,VCA,Bb1X2,BbMxH,BbAvH,BbMxD,BbAvD,BbMxA,BbAvA,BbOU,BbMx>2.5,BbAv>2.5,BbMx<2.5,BbAv<2.5,BbAH,BbAHh,BbMxAHH,BbAvAHH,BbMxAHA,BbAvAHA

drop table if exists uefa.games;

create table uefa.games (
	division_id	      text,
	game_date	      text,
	home_name	      text,
	away_name	      text,
	fthg		      integer,
	ftag		      integer,
	ftr		      text,
	hthg		      integer,
	htag		      integer,
	htr		      text,
	referee_name	      text,
	home_shots	      integer,
	away_shots	      integer,
	hst		      integer,
	ast		      integer,
	hf		      integer,
	af		      integer,
	hc		      integer,
	ac		      integer,
	hy		      integer,
	ay		      integer,
	hr		      integer,
	ar		      integer,
	b365h		      float,
	b365d		      float,
	b365a		      float,
	bwh		      float,
	bwd		      float,
	bwa		      float,
	iwh		      float,
	iwd		      float,
	iwa		      float,
	lbh		      float,
	lbd		      float,
	lba		      float,
	psh		      float,
	psd		      float,
	psa		      float,
	whh		      float,
	whd		      float,
	wha		      float,
	sjh		      float,
	sjd		      float,
	sja		      float,
	vch		      float,
	vcd		      float,
	vca		      float,
	bb1x2		      integer,
	bbmxh		      float,
	bbavh		      float,
	bbmxd		      float,
	bbavd		      float,
	bbmxa		      float,
	bbava		      float,
	bbou		      integer,
	bbmx_gt_25	      float,
	bbav_gt_25	      float,
	bbmx_lt_25	      float,
	bbav_lt_25	      float,
	bbah		      integer,
	bbahh		      float,
	bbmxahh		      float,
	bbavahh		      float,
	bbmxaha		      float,
	bbavaha		      float
);

copy uefa.games from '/tmp/games.csv' with delimiter as ',' csv quote as '"';

alter table uefa.games add column game_id serial;

alter table uefa.games alter column game_date type date using to_date(game_date, 'DD/MM/YY');

commit;
