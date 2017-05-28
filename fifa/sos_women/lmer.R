sink("diagnostics/women_lmer.txt")

library("lme4")
#library("nortest")
library("RPostgreSQL")

#library("sp")

drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv,host="localhost",port="5432",dbname="soccer")

query <- dbSendQuery(con, "
select
--distinct
r.game_id,
r.year,
r.field as field,
r.team_id as team,
r.opponent_id as opponent,
r.game_length as game_length,
team_score::float as gs,
(year-2007)^2 as w
from fifa.women_results r

where
    r.year between 2008 and 2017
and r.gender_id='women'
and r.team_id is not NULL
and r.opponent_id is not NULL
;")

games <- fetch(query,n=-1)

dim(games)

attach(games)

pll <- list()

# Fixed parameters

year <- as.factor(year)

field <- as.factor(field)
field <- relevel(field, ref = "neutral")

game_length <- as.factor(game_length)

fp <- data.frame(field,game_length)
fpn <- names(fp)

# Random parameters

game_id <- as.factor(game_id)
#contrasts(game_id) <- 'contr.sum'

offense <- as.factor(team)
#contrasts(offense) <- 'contr.sum'

defense <- as.factor(opponent)
#contrasts(defense) <- 'contr.sum'

rp <- data.frame(offense,defense)
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
dbWriteTable(con,c("fifa","women_parameter_levels"),parameter_levels,row.names=TRUE)

g <- cbind(fp,rp)
g$gs <- gs
g$w <- w

detach(games)

dim(g)

model0 <- gs ~ field+game_length+(1|offense)+(1|defense)
fit0 <- glmer(model0, data=g, verbose=TRUE, family=poisson(link=log), weights=w)

model <- gs ~ field+game_length+(1|offense)+(1|defense)+(1|game_id)
fit <- glmer(model, data=g, verbose=TRUE, family=poisson(link=log), weights=w)

#model2 <- gs ~ year+field+game_length+(1|offense)+(1|defense)+(1|game_id)
#fit2 <- glmer(model2, data=g, verbose=TRUE, family=poisson(link=log), weights=w)

fit
summary(fit)
anova(fit0,fit)
#anova(fit,fit2)

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

dbWriteTable(con,c("fifa","women_basic_factors"),as.data.frame(combined),row.names=TRUE)

quit("no")
