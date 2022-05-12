# Toda-Yamamoto-Causality-Test

This is an R function to perform the Toda-Yamamoto causality test ([Toda & Yamamoto, 1995](https://www.sciencedirect.com/science/article/abs/pii/0304407694016168)), a test of the null hypothesis than one time series does not "Granger-cause" another one. A time series is considered a Granger cause of another time series if the former predicts the latter significantly better than the latter predicts itself (Granger, 1969). 

The concept and method of Granger causality was originally developed for stationary time series. The Toda-Yamamoto approach overcomes some issues that can arise when testing non-stationary series, a condition leading to the risk of spurious causality ([He, Maekawa, 2001](https://www.sciencedirect.com/science/article/pii/S0165176501004980)). Toda and Yamamoto propose that their method:

>is applicable whether the VAR’s may be stationary (around a deterministic trend), integrated of an arbitrary order, or cointegrated of an arbitrary order. Consequently, one can test linear or nonlinear restrictions on the coefficients by estimating a levels VAR and applying the Wald criterion, paying little attention to the integration and cointegration properties of the time series data in hand. (Toda & Yamamoto, 1995, pp. 245-246).

The procedure is as follows (it is also clearly explained on the [Econometrics Beat](https://davegiles.blogspot.com/2011/04/testing-for-granger-causality.html) blog by prof. [Dave Giles](https://davegiles.blogspot.com)):

>(...) we can estimate levels VAR’s and test general restrictions on the parameter matrices even if the processes may be integrated or cointegrated of an arbitrary order; we can apply the usual lag selection procedure (...) to a possibly integrated or cointegrated VAR (as far as the order of integration of the process does not exceed the true lag length of the model). Having chosen a lag length k, we then estimate a (k + ![equation](https://latex.codecogs.com/svg.image?d_%7Bmax%7D))th-order VAR where ![equation](https://latex.codecogs.com/svg.image?d_%7Bmax%7D) is the maximal order of integration that we suspect might occur in the process. The coefficient matrices of the last ![equation](https://latex.codecogs.com/svg.image?d_%7Bmax%7D) lagged vectors in the model are ignored (since these are regarded as zeros), and we can test linear or nonlinear restrictions on the first k coefficient matrices using the standard asymptotic theory. (Toda & Yamamoto, 1995, p. 227).

An R code to run a bivariate version of the Toda Yamamoto test was published by [Christoph Pfeiffer](https://christophpfeiffer.org/) on his [website](https://christophpfeiffer.org/2012/11/07/toda-yamamoto-implementation-in-r/#:~:text=Data-,coffee_data.csv,-Other%2C%20Predictions). 
More recently, [Josephine Lukito](https://github.com/jlukito) shared an R function to run a Toda-Yamamoto method for two-way Granger Causality in the [ira_3media](https://github.com/jlukito/ira_3media/blob/master/final_analysis.md) public repository for replicating results from her paper (Lukito, 2020). 

The code I am posting here is a blended and modified version of the code by Pfeiffer,  inspired by the Lukito's idea of creating an R loop to apply the test to a multivariate case. Therefore, it is appliable both to bivariate and multivariate cases.

The function includes an authomated way to detect the maximum order of integration ![equation](https://latex.codecogs.com/svg.image?d_%7Bmax%7D) that must be added to the lag length *k* of the original VAR model to estimate the (k + ![equation](https://latex.codecogs.com/svg.image?d_%7Bmax%7D))th-order VAR required by the Toda & Yamamoto procedure (Toda & Yamamoto, 1995). More specifically, the order of integration is tested by using the function [ndiffs](https://search.r-project.org/CRAN/refmans/forecast/html/ndiffs.html) from the Rob J. Hyndman's [forecast](https://cran.r-project.org/web/packages/forecast/index.html) package. The function *ndiffs* uses a unit root test to determine the number of differences required for time series x to be made stationary. The default test is Kwiatkowski–Phillips–Schmidt–Shin (KPSS), but it can also be used the Augmented Dickey-Fuller test (*test="adf"*) or the Phillips-Perron test (*test="pp"*). 

Besides *forecast*, the function requires the library *vars*, to fit a VAR model augmented of ![equation](https://latex.codecogs.com/svg.image?d_%7Bmax%7D) lags, and *aod* to perform the Wald Test ignoring the ![equation](https://latex.codecogs.com/svg.image?d_%7Bmax%7D) lags as required by the Toda-Yamamoto procedure.

The Toda-Yamamoto causality test is applied to the multivariate case following the equation for the direct Granger procedure with more than two variables, as reported in Kirchgässner & Wolters (2007, p. 114):

>Let z_1, ..., z_m be additional variables. According to the definition of Granger causality, the estimation equation (3.21) 

![equation](https://latex.codecogs.com/svg.image?%5Clarge%20(3.21)%20%5Cspace%20y_t%20=%20%5Calpha_0%20&plus;%20%5Csum_%7Bk=1%7D%5E%7Bk_1%7D%20%5Calpha_%7B11%7D%5Ek%20y_%7Bt-k%7D%20&plus;%20%5Csum_%7Bk=1%7D%5E%7Bk_2%7D%20%5Calpha_%7B12%7D%5Ek%20x_%7Bt-k%7D%20&plus;%20u_t)

>can be extended to

![equation](https://latex.codecogs.com/svg.image?%5Clarge%20(3.23)%20%5Cspace%20%20y_t%20=%20%5Calpha_0%20&plus;%20%5Csum_%7Bk=1%7D%5E%7Bk_1%7D%20%5Calpha_%7B11%7D%5Ek%20y_%7Bt-k%7D%20&plus;%20%5Csum_%7Bk=1%7D%5E%7Bk_2%7D%20%5Calpha_%7B12%7D%5Ek%20x_%7Bt-k%7D%20&plus;%20%5Csum_%7Bj=1%7D%5E%7Bm%7D%20%5Csum_%7Bk=1%7D%5E%7Bk_%7Bj&plus;2%7D%7D%20%5Cbeta_j%5Ek%20z_%7Bj,t-k%7D%20&plus;%20u_t,)

>if we test for simple Granger causal relations, with ![equation](https://latex.codecogs.com/svg.image?%5Cbeta_j%5Ek,%20k=1,%20...,%20k_%7Bj&plus;2%7D,%20j=1,%20...,%20m), being the coefficients of the additional variables. It does not matter whether the additional variables are endogenous or exogenous since only lagged values are considered. After determining the numbers of lags ![equation](https://latex.codecogs.com/svg.image?k_1,%20k_2,%20k_3), ..., (3.23) can be estimated using OLS. As in the bivariate case, it can be checked via an F test whether the coefficients of the lagged values of x are jointly significantly different from zero. By interchanging x and y in (3.23), it can be tested whether there exists a simple Granger causal relation from y to x and/or feedback.

Adapting the above equation to the Toda-Yamamoto procedure, the coefficients of the lagged values of X are tested excluding the additional lags ![equation](https://latex.codecogs.com/svg.image?d_%7Bmax%7D) and using the Wald Chi-Squared Test instead of the F test.

```{r}
# Example from the Christoph Pfeiffer's blog
https://christophpfeiffer.org/2012/11/07/toda-yamamoto-implementation-in-r/#:~:text=Data-,coffee_data.csv,-Other%2C%20Predictions

cof <- read.csv("coffee_data.csv")[193:615,]
V.6 <- VAR(cof1[,2:3], p=6, type="both")
# add one lag ($d_{max}=1$) for the toda yamamoto procedure
V.7<- VAR(cof1[,2:3], p=7, type="both")

# run the Wald Test ignoring the ![equation](https://latex.codecogs.com/svg.image?d_%7Bmax%7D) lag
wald.test(b=coef(V.7$varresult[[1]]), Sigma=vcov(V.7$varresult[[1]]), Terms=c(2,4,6,8,10,12))
wald.test(b=coef(V.7$varresult[[2]]), Sigma=vcov(V.7$varresult[[2]]), Terms= c(1,3,5,7,9,11))

# -------------------------------------
# Using the toda.yamamoto function ####
toda.yamamoto.test(V.6)
```

For any comments or observation, you can [drop me a message](mailto:nicola.righetti@univie.ac.at?subject=[GitHub]%20Toda-Yamamoto%20)

**References**

Granger, C. W. (1969). Investigating causal relations by econometric models and cross-spectral methods. *Econometrica: journal of the Econometric Society*, 424-438.

He, Z., & Maekawa, K. (2001). On spurious Granger causality. *Economics Letters*, 73(3), 307-313.

Lukito, J. (2020). Coordinating a multi-platform disinformation campaign: Internet Research Agency activity on three US social media platforms, 2015 to 2017. *Political Communication*, 37(2), 238-255.

Kirchgässner, G., & Wolters, J. (2007). *Introduction to Modern Time Series Analysis*. Springer.

Toda, H. Y., & Yamamoto, T. (1995). Statistical inference in vector autoregressions with possibly integrated processes. *Journal of econometrics*, 66(1-2), 225-250.
