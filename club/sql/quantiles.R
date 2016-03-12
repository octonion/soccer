
f <- read.csv("points.csv",header=TRUE)

summary(f)

quantile(f$pts,probs = seq(0, 1, 0.10))

