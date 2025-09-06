install.packages(c("tidyquant","forecast","dplyr"))
library(tidyquant)
library(forecast)
library(dplyr)

set.seed(123)

Nt <- 1000
sigma <- 1

# ---- Simulation AR(2) ----
phi0 <- 0.001
phi1 <- -0.1
phi2 <- 0.4
noise_ar <- rnorm(Nt)
ar_series <- numeric(Nt)

for(t in 3:Nt){
  ar_series[t] <- phi0 + phi1*ar_series[t-1] + phi2*ar_series[t-2] + sigma*noise_ar[t]
}

plot(cumsum(ar_series), type="l", main="AR(2) Simulate", xlab="Time", ylab="r")
acf(ar_series, main="ACF AR(2)")
pacf(ar_series, main="PACF AR(2)")

# ---- Simulation MA(2) ----
theta1 <- -0.1
theta2 <- 0.4
noise_ma <- rnorm(Nt)
ma_series <- numeric(Nt)
ma_series[1] <- noise_ma[1]
ma_series[2] <- noise_ma[2] + theta1*noise_ma[1]

for(t in 3:Nt){
  ma_series[t] <- noise_ma[t] + theta1*noise_ma[t-1] + theta2*noise_ma[t-2]
}

plot(cumsum(ma_series), type="l", main="MA(2) Simulate", xlab="Time", ylab="r")
acf(ma_series, main="ACF MA(2)")
pacf(ma_series, main="PACF MA(2)")

# ---- White noise ----
wn_series <- rnorm(Nt, mean=0, sd=sd(ar_series))
plot(wn_series, type="l", main="White Noise", xlab="Time", ylab="r")
acf(wn_series, main="ACF White Noise")
pacf(wn_series, main="PACF White Noise")

# ----Microsoft Data----
msft <- tq_get("MSFT", from="2010-01-01", to=Sys.Date())
msft <- msft %>% mutate(ret = log(adjusted / lag(adjusted))) %>% na.omit()

plot(cumsum(msft$ret), type="l", main="Cumulate Returns MSFT", xlab="Time", ylab="r")
acf(msft$ret, main="ACF Returns MSFT")
pacf(msft$ret, main="PACF Returns MSFT")
