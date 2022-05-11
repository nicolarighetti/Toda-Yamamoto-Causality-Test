# Toda-Yamamoto-Causality-Test

R function to perform the Toda-Yamamoto causality test ([Toda & Yamamoto, 1995](https://www.sciencedirect.com/science/article/abs/pii/0304407694016168)), a test of the null hypothesis than one time series does not Granger-cause another one.

The Toda-Yamamoto approach overcomes some issues that can arise when testing between two independent and irrelative processes where one of or both of them is or are non-stationary. In these circumstances, Granger causality often leads to spurious causality [He, Maekawa, 2001](https://www.sciencedirect.com/science/article/pii/S0165176501004980).

In particular, as they argue in their paper, their method:

>is applicable whether the VAR’s may be stationary (around a deterministic trend), integrated of an arbitrary order, or cointegrated of an arbitrary order. Consequently, one can test linear or nonlinear restrictions on the coefficients by estimating a levels VAR and applying the Wald criterion, paying little attention to the integration and cointegration properties of the time series data in hand. (Toda & Yamamoto, 1995, pp. 245-246).

>(...) we can estimate levels VAR’s and test general restrictions on the parameter matrices even if the processes may be integrated or cointegrated of an arbitrary order; we can apply the usual lag selection procedure (...) to a possibly integrated or cointegrated VAR (as far as the order of integration of the process does not exceed the true lag length of the model). Having chosen a lag length k, we then estimate a (k + d<sub>max</sub>)th-order VAR where d<sub>max</sub> is the maximal order of integration that we suspect might occur in the process. The coefficient matrices of the last d<sub>max</sub> lagged vectors in the model are ignored (since these are regarded as zeros), and we can test linear or nonlinear restrictions on the first k coefficient matrices using the standard asymptotic theory. (Toda & Yamamoto, 1995, p. 227).

The R code to run a bivariate version of the test was already published by [Christoph Pfeiffer](https://christophpfeiffer.org/) on his [website](https://christophpfeiffer.org/2012/11/07/toda-yamamoto-implementation-in-r/#:~:text=Data-,coffee_data.csv,-Other%2C%20Predictions). 

As clearly summarize by Christoph Pfeiffer, the Toda-Yamamoto causality test procedure is based on the following steps: 

>1. Test for integration (structural breaks need to be taken into account). Determine max order of integration (m). If none of the series in integrated, the usual Granger-causality test can be done. 
>2. Set up a VAR-model in the levels (do not difference the data). 
>3. Determine lag length. Let the lag length be p. The VAR model is thus VAR(p).
>4. Carry out tests for misspecification, especially for residual serial correlation. 
>5. Add the maximum order of integration to the number of lags. This is the augmented VAR-model, VAR(p+m). 
>6. Carry out a Wald test for the first p variables only with p degrees of freedom

More recently, [Josephine Lukito](https://github.com/jlukito) published an R function to run a "Toda-Yamamoto method for two-way Granger Causality, holding all else constant" in her [ira_3media](https://github.com/jlukito/ira_3media/blob/master/final_analysis.md) public repository for replicating results from her paper *Coordinating a Multi-Platform Disinformation Campaign: Internet Research Agency activity on three U.S. social media platforms, 2015 to 2017* (Lukito, 2020). 

The code in this repository is a very slightly modified version of the code kindly shared by Josephine Lukito. Compared to the original version, it simply adds an authomated way to detect the maximum order of integration d<sub>max</sub> that has to be added to the lag length *k* of the original VAR model to estimate the (k + d<sub>max</sub>)th-order VAR required by the Toda & Yamamoto procedure (Toda & Yamamoto, 1995). This makes the code reusable with time series with any orders of integration, also different from that of the original Lukito's series. Since the modifications to Lukito's code are minimal, if you use/reuse the code, you can simply cite her  work (Lukito, 2020) or [GitHub repository](https://github.com/jlukito/ira_3media/blob/master/final_analysis.md).

**References**

He, Z., & Maekawa, K. (2001). On spurious Granger causality. Economics Letters, 73(3), 307-313.

Lukito, J. (2020). Coordinating a multi-platform disinformation campaign: Internet Research Agency activity on three US social media platforms, 2015 to 2017. *Political Communication*, 37(2), 238-255.

Toda, H. Y., & Yamamoto, T. (1995). Statistical inference in vector autoregressions with possibly integrated processes. *Journal of econometrics*, 66(1-2), 225-250.
