begin;

--Div,Date,HomeTeam,AwayTeam,
--FTHG,FTAG,FTR,HTHG,HTAG,HTR,
--HS,AS,HST,AST,HF,AF,HC,AC,HY,AY,HR,AR,
--B365H,B365D,B365A,
--BWH,BWD,BWA,
--GBH,GBD,GBA,
--IWH,IWD,IWA,LBH,LBD,LBA,PSH,PSD,PSA,WHH,WHD,WHA,
--SJH,SJD,SJA,VCH,VCD,VCA,
--BSH,BSD,BSA,
--Bb1X2,BbMxH,BbAvH,BbMxD,BbAvD,BbMxA,BbAvA,BbOU,
--BbMx>2.5,BbAv>2.5,BbMx<2.5,BbAv<2.5,
--BbAH,BbAHh,BbMxAHH,BbAvAHH,BbMxAHA,BbAvAHA

--Div,Date,HomeTeam,AwayTeam,
--FTHG,FTAG,FTR,HTHG,HTAG,HTR,
--Referee,
--HS,AS,HST,AST,HF,AF,HC,AC,HY,AY,HR,AR,
--B365H,B365D,B365A,
--BWH,BWD,BWA,
--IWH,IWD,IWA,LBH,LBD,LBA,PSH,PSD,PSA,WHH,WHD,WHA,
--SJH,SJD,SJA,VCH,VCD,VCA,
--Bb1X2,BbMxH,BbAvH,BbMxD,BbAvD,BbMxA,BbAvA,BbOU,
--BbMx>2.5,BbAv>2.5,BbMx<2.5,BbAv<2.5,
--BbAH,BbAHh,BbMxAHH,BbAvAHH,BbMxAHA,BbAvAHA

drop table if exists uefa.games;

create table uefa.games (
	game_id		      serial,
	division_id	      text,
	year		      integer,
	game_date	      date,
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
	gbh		      float, --
	gbd		      float, --
	gba		      float, --
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
	bsh		      float, --
	bsd		      float, --
	bsa		      float, --
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

create temporary table g (
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
--	referee_name	      text,
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
	gbh		      float, --
	gbd		      float, --
	gba		      float, --
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
	bsh		      float, --
	bsd		      float, --
	bsa		      float, --
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

copy g from '/tmp/games.csv' with delimiter as ',' csv quote as '"';

alter table g alter column game_date type date using to_date(game_date, 'DD/MM/YY');

insert into uefa.games
(
division_id,
year,
game_date,
home_name,away_name,
fthg,ftag,ftr,
hthg,htag,htr,
--referee_name, --
home_shots,away_shots,hst,
ast,hf,af,hc,ac,hy,ay,hr,ar,
b365h,b365d,b365a,
bwh,bwd,bwa,
gbh,gbd,gba, --
iwh,iwd,iwa,
lbh,lbd,lba,
psh,psd,psa,
whh,whd,wha,
sjh,sjd,sja,
vch,vcd,vca,
bsh,bsd,bsa, --
bb1x2,bbmxh,bbavh,bbmxd,bbavd,bbmxa,bbava,
bbou,
bbmx_gt_25,bbav_gt_25,
bbmx_lt_25,bbav_lt_25,
bbah,
bbahh,
bbmxahh,bbavahh,bbmxaha,bbavaha
)
(
select
division_id,
(case when extract(month from game_date) between 7 and 12 then
           extract(year from game_date)+1
      else extract(year from game_date)
 end) as year,
game_date,
home_name,away_name,
fthg,ftag,ftr,
hthg,htag,htr,
--referee_name, --
home_shots,away_shots,hst,
ast,hf,af,hc,ac,hy,ay,hr,ar,
b365h,b365d,b365a,
bwh,bwd,bwa,
gbh,gbd,gba, --
iwh,iwd,iwa,
lbh,lbd,lba,
psh,psd,psa,
whh,whd,wha,
sjh,sjd,sja,
vch,vcd,vca,
bsh,bsd,bsa, --
bb1x2,bbmxh,bbavh,bbmxd,bbavd,bbmxa,bbava,
bbou,
bbmx_gt_25,bbav_gt_25,
bbmx_lt_25,bbav_lt_25,
bbah,
bbahh,
bbmxahh,bbavahh,bbmxaha,bbavaha
from g
);

commit;
