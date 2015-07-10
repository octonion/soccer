using Distributions

# I have got to say that I love the way Julia handles distributions
# as I discovered through this post.

# The Distributions package gives trenendous power to the user by
# providing a common framework to apply various function.

# For instance let's say you want to draw 10 draws from a Binomial(n=10, p=.25) distribution
Binomial(10, .25)
#  4  3  0  5  1  3  5  2  2  1

# Looks pretty standard right? Well, what if we want the mean?
mean(Binomial(10, .25))
# 2.5

# mode, skewness, kurtosis, median?
#a = Binomial(10, .25)
#println("mode:", mode(a), " skewness:", skewness(a),
#        " kurtosis:", kurtosis(a), " median:", median(a))
