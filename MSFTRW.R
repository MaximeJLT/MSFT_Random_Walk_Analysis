library(tidyquant)
library(ggplot2)
library(vrtest)

ticker <- "MSFT"
date_first <- "1987-12-31"
date_last  <- "2017-12-31"

TR <- tq_get(ticker, from=date_first, to=date_last)

plot(TR$date,TR$adjusted,type="l",xlab="Time",ylab="Price",main="MSFT Adjusted Price 1988-2017");grid()

P    <- TR$adjusted
r    <- diff(log(P))
N    <- length(r)

TR$r <- c(NA, diff(log(TR$adjusted)))

TR   <- TR[-1,]

plot(TR$date,TR$r,type="l",xlab="Time",ylab="Price",main="MSFT Daily Returns 1988-2017");grid()

plot(TR$date,rnorm(nrow(TR))*sd(TR$r),type="l",ylim=c(-0.18,0.18),xlab="Time",ylab="Price",main="White Noise Process with MSFT Volatility");grid()

summary(TR)

mean(r)*252
sd(r)*sqrt(252)

summary(r)

hist(r, breaks=50)

Variance <- var(diff(log(P)))

for (n in 2:100) {
  Variance[n] <- var(diff(log(P[seq(from=n, to=length(P), by=n)])))
}

plot(Variance,xlab="n",main="Variance of Returns From n-day Observations");grid()

variance.c <- function(X, q) {
  
  T     <- length(X) - 1
  mu    <- (X[T+1] - X[1])/T
  m     <- (T-q)*(T-q+1)*q/T
  sumsq <- 0
  for (t in q:T) {
    sumsq <- sumsq + (X[t+1] - X[t-q+1] - q*mu)^2
  }
  return(sumsq/m)
}

z <- function(X, q) {
  T <- length(X) - 1
  c <- sqrt(T*(3*q)/(2*(2*q-1)*(q-1)))
  M <- variance.c(X,q)/variance.c(X,1) - 1
  z <- c*M
  return(z)
}

Vc      <- 0; for (q in 1:100) {Vc[q] <- variance.c(log(P),q)}
zstats  <- 0; for (q in 2:100) {zstats[q] <- z(log(P),q) }
pValues <- 2*pnorm(-abs(zstats))
barplot(zstats, ylab="z",xlab="q",main="z Statistics of Variance Ratio Test")

sigma <- sqrt(252)*sd(diff(log(P)))

for (n in 2:100) {
  sigma[n] <- sqrt(252/n)*sd(diff(log(P[seq(from=n, to=length(P), by=n)])))
}

barplot(sigma,xlab="n",ylab="Standard Deviation (annualized) / sqrt(n)",main="Volatility Scaling of Returns From n-day Observations (MSFT)");grid()

P.MC <- exp(cumsum(rnorm(N)*0.02))
sigma.MC <- sqrt(252)*sd(diff(log(P.MC)))

for (n in 2:100) {
  sigma.MC[n] <- sqrt(252/n)*sd(diff(log(P.MC[seq(from=n, to=N, by=n)])))
}

barplot(sigma.MC,xlab="n",ylab="Standard Deviation (annualized) / sqrt(n)",main="Volatility Scaling of Returns From n-day Observations (Sim)");grid()

