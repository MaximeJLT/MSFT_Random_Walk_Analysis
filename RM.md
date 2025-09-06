# Quantitative Analysis of MSFT

## 1) Objective
The aim of this analysis is to determine whether Microsoft’s daily **adjusted prices** (1988–2017) behave like a **Random Walk** (RW), and to explore if **time series models** (AR and MA) can describe the return dynamics.

In a RW, **log-returns** behave like independent, unpredictable shocks. Past information should not help predict future returns, which aligns with the **Weak-Form Efficient Market Hypothesis**.

**Research question:** Are MSFT daily log-returns independent and uncorrelated, or do AR/MA structures exist that can partially explain short-term predictability?

---

## 2) Theoretical Background

### 2.1 Random Walk in log-prices
Adjusted prices are modeled as:

$$
\log P_t = \log P_{t-1} + r_t
$$

where:
- ($$P_t$$) = adjusted closing price at time \(t\)  
- ($$r_t$$) = daily **logarithmic return**:

$$
r_t = \log P_t - \log P_{t-1}
$$

### 2.2 Expected Properties under a Random Walk

See: `MSFTRW.R`.

If ($$r_t$$) are independent and identically distributed (IID):

1. **Variance grows linearly with the horizon \(q\)**:

$$
\mathrm{Var}(r^{(q)}) = q \cdot \mathrm{Var}(r^{(1)})
$$

2. **Volatility scales with the square root of time**:

$$
\sigma(q) \approx \sigma(1) \cdot \sqrt{q}
$$

3. **Variance Ratio**:

$$
VR(q) = \frac{\mathrm{Var}(r^{(q)})}{q \cdot \mathrm{Var}(r^{(1)})}
$$

Under RW: \(VR(q) = 1\) for all \(q\).

### 2.3 Lo & MacKinlay Variance Ratio Test
Lo & MacKinlay (1988) developed the VR test to evaluate:

- **Null hypothesis** ($$H_0$$): ($$VR(q) = 1$$) (Random Walk)  
- **Alternative**: ($$VR(q) \neq 1$$) (autocorrelation present)  

Test statistic:

$$
z(q) = \frac{VR(q) - 1}{\mathrm{StdError}(VR(q))}
$$

If ($$|z(q)| > 1.96$$), we reject the RW hypothesis at the 5% level.

---

## 3) Methodology: Time Series Simulations and Analysis

See: `simulate_AR_MA_MSFT.R`.

To complement the empirical analysis, we simulate **AR(2)** and **MA(2)** processes, and generate **white noise**, to compare with MSFT returns.  

## 3.2 Explanation of the Code

- **AR(2) simulation**: Each value depends on the previous two values plus Gaussian noise:

$$
r_t = \phi_0 + \phi_1 r_{t-1} + \phi_2 r_{t-2} + \varepsilon_t
$$

- **MA(2) simulation**: Each value depends on the current and previous two noise terms:

$$
r_t = \varepsilon_t + \theta_1 \varepsilon_{t-1} + \theta_2 \varepsilon_{t-2}
$$

- **White noise**: Purely random series with the same standard deviation as AR(2). No correlation across time.

- **Microsoft data**: Downloaded using `tidyquant`. Log-returns are calculated as:

$$
r_t = \log(P_t / P_{t-1})
$$

- **ACF / PACF plots**:
  - **ACF**: correlation between ($$r_t$$) and ($$r_{t-k}$$) for lag ($$k$$)  
  - **PACF**: correlation of ($$r_t$$) with ($$r_{t-k}$$) after removing the effect of intermediate lags

---

## 4) Analysis of Time Series

- **AR(2) series**: Shows a decaying autocorrelation pattern, typical of autoregressive processes.  
- **MA(2) series**: ACF cuts off after 2 lags; PACF decays gradually.  
- **White noise**: No significant autocorrelation; serves as a benchmark.  
- **MSFT returns**: Mostly resemble white noise, but small deviations (slight autocorrelations) may appear at short lags.  

Comparison allows us to check if MSFT returns have any **temporal structure**, or if they behave mostly like a Random Walk.

---

## 5) Conclusion

- MSFT daily returns are **mostly consistent** with a Random Walk, supporting the Weak-Form Efficient Market Hypothesis.  
- Minor autocorrelation exists at very short lags, but it is weak and likely not exploitable.  
- AR and MA simulations provide a reference to visualize how temporal dependencies would look compared to real stock returns.  

This analysis combines **empirical Random Walk testing** with **time series modeling** to better understand the statistical properties of Microsoft’s daily returns.
