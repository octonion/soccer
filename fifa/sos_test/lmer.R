sink("diagnostics/men_lmer.txt")

library("lme4")
#library("nortest")
library("RPostgreSQL")

#library("sp")

drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv,host="localhost",port="5432",dbname="soccer")

query <- dbSendQuery(con, "
select
distinct
r.game_id,
r.year,
r.field as field,
r.team_id as team,
r.opponent_id as opponent,
r.game_length as game_length,
team_score::float as gs,
(year-2007)^2 as w
from fifa.men_results r

where
    r.year between 2008 and 2016
and r.gender_id='men'
and r.team_id is not NULL
and r.opponent_id is not NULL

and r.team_id in
(
select team_id
from fifa.men_results
where gender_id='men'
group by team_id
having count(*)>=10)

and r.opponent_id in
(
select team_id
from fifa.men_results
where gender_id='men'
group by team_id
having count(*)>=10)

;")

games <- fetch(query,n=-1)

dim(games)

attach(games)

pll <- list()

# Fixed parameters

field <- as.factor(field)
field <- relevel(field, ref = "neutral")

game_length <- as.factor(game_length)

offense <- as.factor(team)

defense <- as.factor(opponent)

fp <- data.frame(offense,defense,field,game_length)
fpn <- names(fp)

# Random parameters

game_id <- as.factor(game_id)

rp <- data.frame(game_id)
rpn <- names(rp)

for (n in fpn) {
  df <- fp[[n]]
  level <- as.matrix(attributes(df)$levels)
  parameter <- rep(n,nrow(level))
  type <- rep("fixed",nrow(level))
  pll <- c(pll,list(data.frame(parameter,type,level)))
}

for (n in rpn) {
  df <- rp[[n]]
  level <- as.matrix(attributes(df)$levels)
  parameter <- rep(n,nrow(level))
  type <- rep("random",nrow(level))
  pll <- c(pll,list(data.frame(parameter,type,level)))
}

# Model parameters

parameter_levels <- as.data.frame(do.call("rbind",pll))
dbWriteTable(con,c("fifa","men_parameter_levels"),parameter_levels,row.names=TRUE)

g <- cbind(fp,rp)
g$gs <- gs
g$w <- w

detach(games)

dim(g)

model <- gs ~ field+game_length+offense+defense+(1|game_id)
fit <- glmer(model,
             data=g,
	     verbose=TRUE,
	     family=poisson(link=log),
	     weights=w,
	     nAGQ=0,
	     control=glmerControl(optimizer="nloptwrap")
	     )

fit
summary(fit)

# List of data frames

# Fixed factors

f <- fixef(fit)
fn <- names(f)

# Random factors

r <- ranef(fit)
rn <- names(r) 

results <- list()

for (n in fn) {

  df <- f[[n]]

  factor <- n
  level <- n
  type <- "fixed"
  estimate <- df

  results <- c(results,list(data.frame(factor,type,level,estimate)))

 }

for (n in rn) {

  df <- r[[n]]

  factor <- rep(n,nrow(df))
  type <- rep("random",nrow(df))
  level <- row.names(df)
  estimate <- df[,1]

  results <- c(results,list(data.frame(factor,type,level,estimate)))

 }

combined <- as.data.frame(do.call("rbind",results))

dbWriteTable(con,c("fifa","men_basic_factors"),as.data.frame(combined),row.names=TRUE)

quit("no")
