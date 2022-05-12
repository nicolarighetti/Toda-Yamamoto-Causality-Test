# Toda-Yamamoto-Causality-Test

R function to perform the Toda-Yamamoto causality test ([Toda & Yamamoto, 1995](https://www.sciencedirect.com/science/article/abs/pii/0304407694016168)), a test of the null hypothesis than one time series does not Granger-cause another one.

The Toda-Yamamoto approach overcomes some issues that can arise when testing between two independent and irrelative processes where one of or both of them is or are non-stationary. In these circumstances, Granger causality often leads to spurious causality [He, Maekawa, 2001](https://www.sciencedirect.com/science/article/pii/S0165176501004980).

In particular, this method:

>is applicable whether the VAR’s may be stationary (around a deterministic trend), integrated of an arbitrary order, or cointegrated of an arbitrary order. Consequently, one can test linear or nonlinear restrictions on the coefficients by estimating a levels VAR and applying the Wald criterion, paying little attention to the integration and cointegration properties of the time series data in hand. (Toda & Yamamoto, 1995, pp. 245-246).

>(...) we can estimate levels VAR’s and test general restrictions on the parameter matrices even if the processes may be integrated or cointegrated of an arbitrary order; we can apply the usual lag selection procedure (...) to a possibly integrated or cointegrated VAR (as far as the order of integration of the process does not exceed the true lag length of the model). Having chosen a lag length k, we then estimate a (k + d_{max})th-order VAR where d_{max} is the maximal order of integration that we suspect might occur in the process. The coefficient matrices of the last d_{max} lagged vectors in the model are ignored (since these are regarded as zeros), and we can test linear or nonlinear restrictions on the first k coefficient matrices using the standard asymptotic theory. (Toda & Yamamoto, 1995, p. 227).

An R code to run a bivariate version of the test was published by [Christoph Pfeiffer](https://christophpfeiffer.org/) on his [website](https://christophpfeiffer.org/2012/11/07/toda-yamamoto-implementation-in-r/#:~:text=Data-,coffee_data.csv,-Other%2C%20Predictions) and the procedure is clearly explained on his website as well as by prof. [Dave Giles](https://davegiles.blogspot.com) on his blog [Econometrics Beat](https://davegiles.blogspot.com/2011/04/testing-for-granger-causality.html):

>Now, here are the basic steps for the T-Y procedure:

>  1. Test each of the time-series to determine their order of integration. Ideally, this should involve using a test (such as the ADF test) for which the null hypothesis is non-stationarity; as well as a test (such as the KPSS test) for which the null is stationarity. It's good to have a cross-check.
  2. Let the **maximum** order of integration for the group of time-series be m. So, if there are two time-series and one is found to be I(1) and the other is I(2), then m = 2. If one is I(0) and the other is I(1), then m = 1, etc.
  3. Set up a VAR model in the **levels** of the data, regardless of the orders of integration of the various time-series. Most importantly, you **must not** difference the data, no matter what you found at Step 1.
  4. Determine the appropriate maximum lag length for the variables in the VAR, say p, using the usual methods. Specifically, base the choice of p on the usual information criteria, such as AIC, SIC.
  5. Make sure that the VAR is well-specified. For example, ensure that there is no serial correlation in the residuals. If need be, increase p until any autocorrelation issues are resolved.
  6. If two or more of the time-series have the same order of integration, at Step 1, then test to see if they are cointegrated, preferably using Johansen's methodology (based on your VAR) for a reliable result.
  7. No matter what you conclude about cointegration at Step 6, this is not going to affect what follows. It just provides a possible cross-check on the validity of your results at the very end of the analysis.
  8. Now take the preferred VAR model and add in m additional lags of each of the variables into each of the equations.
  9. Test for Granger non-causality as follows. For expository purposes, suppose that the VAR has two equations, one for X and one for Y. Test the hypothesis that the coefficients of (only) the first p lagged values of X are zero in the Y equation, using a standard Wald test. Then do the same thing for the coefficients of the lagged values of Y in the X equation.
  10. It's **essential** that you **don't** include the coefficients for the 'extra' m lags when you perform the Wald tests. They are there just to fix up the asymptotics.
  11. The Wald test statistics will be asymptotically chi-square distributed with p d.o.f., under the null.
  12. Rejection of the null implies a rejection of Granger non-causality. That is, a rejection supports the presence of Granger causality.
  13. Finally, look back at what you concluded in Step 6 about cointegration

As summarized by Pfeiffer, the Toda-Yamamoto causality test procedure is based on the following steps: 

>1. Test for integration (structural breaks need to be taken into account). Determine max order of integration (m). If none of the series in integrated, the usual Granger-causality test can be done. 
>2. Set up a VAR-model in the levels (do not difference the data). 
>3. Determine lag length. Let the lag length be p. The VAR model is thus VAR(p).
>4. Carry out tests for misspecification, especially for residual serial correlation. 
>5. Add the maximum order of integration to the number of lags. This is the augmented VAR-model, VAR(p+m). 
>6. Carry out a Wald test for the first p variables only with p degrees of freedom

More recently, [Josephine Lukito](https://github.com/jlukito) shared an R function to run a "Toda-Yamamoto method for two-way Granger Causality, holding all else constant" in the [ira_3media](https://github.com/jlukito/ira_3media/blob/master/final_analysis.md) public repository for replicating results from her paper *Coordinating a Multi-Platform Disinformation Campaign: Internet Research Agency activity on three U.S. social media platforms, 2015 to 2017* (Lukito, 2020). 

The code I am posting here is a blended and modified version of the code by Pfeiffer. In particular, the functions and procedures are those basically described by Pfeiffer, but extended to the multivariate case. However, it is inspired by the Lukito's idea of creating a loop to apply the test to a multivariate case. 

The function also includes an authomated way to detect the maximum order of integration $d_{max}$ that must be added to the lag length *k* of the original VAR model to estimate the ($k + d_{max}$)th-order VAR required by the Toda & Yamamoto procedure (Toda & Yamamoto, 1995). This makes the code usable with time series with any orders of integration. The order of integration is tested by using the function [ndiffs](https://search.r-project.org/CRAN/refmans/forecast/html/ndiffs.html) from the Rob J. Hyndman's [forecast](https://cran.r-project.org/web/packages/forecast/index.html) package. THe function *uses a unit root test to determine the number of differences required for time series x to be made stationary*. The default test is KPSS, but it can also be used the Augmented Dickey-Fuller test (test="adf") or the Phillips-Perron test (test="pp"). 

Besides *forecast*, the function requires the library *vars*, to fit a VAR model augmented of $d_{max}$ lags, and the *aod* library to perform the Wald Test ignoring the $d_{max}$ lags.

The Toda-Yamamoto procedure is applied to multivariate cases following the equation for the direct Granger procedure with more than two variables, as reported in Kirchgässner & Wolters (2007, p. 114):

>Let z_1, ..., z_m be additional variables. According to the definition of Granger causality, the estimation equation (3.21) 

$$(3.21) \space y_t = \alpha_0 + \sum_{k=1}^{k_1} \alpha_{11}^k y_{t-k} + \sum_{k=1}^{k_2} \alpha_{12}^k x_{t-k} + u_t$$

>can be extended to

$$(3.23) \space y_t = \alpha_0 + \sum_{k=1}^{k_1} \alpha_{11}^k y_{t-k} + \sum_{k=1}^{k_2} \alpha_{12}^k x_{t-k} + \sum_{j=1}^{m} \sum_{k=1}^{k_{j+2}} \beta_j^k z_{j,t-k} + u_t,$$

>if we test for simple Granger causal relations, with $\beta_j^k$, k = 1, ..., $k_{j+2}$, j = 1, ..., m, being the coefficients of the additional variables. It does not matter whether the additional variables are endogenous or exogenous since only lagged values are considered. After determining the numbers of lags $k_1$, $k_2$, $k_3$, ..., (3.23) can be estimated using OLS. As in the bivariate case, it can be checked via an F test whether the coefficients of the lagged values of x are jointly significantly different from zero. By interchanging x and y in (3.23), it can be tested whether there exists a simple Granger causal relation from y to x and/or feedback.

Adapting the above equation to the Toda-Yamamoto procedure, the coefficients of the lagged values of $X$ are tested excluding the additional lags $d_{max}$ and using the Wald Chi-Squared Test instead of the F test.

```{r}
# Example from the Christoph Pfeiffer's blog
https://christophpfeiffer.org/2012/11/07/toda-yamamoto-implementation-in-r/#:~:text=Data-,coffee_data.csv,-Other%2C%20Predictions

cof <- read.csv("coffee_data.csv")[193:615,]

# 6 lags are fine
V.6 <- VAR(cof1[,2:3], p=6, type="both")

# add one lag ($d_{max}=1$) for the toda yamamoto procedure
V.7<- VAR(cof1[,2:3], p=7, type="both")

# run the Wald Test ignoring the $d_{max}$ lag
wald.test(b=coef(V.7$varresult[[1]]), Sigma=vcov(V.7$varresult[[1]]), Terms=c(2,4,6,8,10,12))

wald.test(b=coef(V.7$varresult[[2]]), Sigma=vcov(V.7$varresult[[2]]), Terms= c(1,3,5,7,9,11))

# Using the toda.yamamoto function
toda.yamamoto.test(V.6)
```


**References**

He, Z., & Maekawa, K. (2001). On spurious Granger causality. Economics Letters, 73(3), 307-313.

Lukito, J. (2020). Coordinating a multi-platform disinformation campaign: Internet Research Agency activity on three US social media platforms, 2015 to 2017. *Political Communication*, 37(2), 238-255.

Kirchgässner, G., & Wolters, J. (2007). *Introduction to Modern Time Series Analysis*. Springer.

Toda, H. Y., & Yamamoto, T. (1995). Statistical inference in vector autoregressions with possibly integrated processes. *Journal of econometrics*, 66(1-2), 225-250.
