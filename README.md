# Toda-Yamamoto-Causality-Test

R function to perform the Toda-Yamamoto causality test ([Toda & Yamamoto, 1995](https://www.sciencedirect.com/science/article/abs/pii/0304407694016168)).

The code is just a very slightly modified version of the code kindly shared by [jlukito](https://github.com/jlukito) in the [ira_3media](https://github.com/jlukito/ira_3media/blob/master/final_analysis.md) public repository for replicating results from her paper "Coordinating a Multi-Platform Disinformation Campaign: Internet Research Agency activity on three U.S. social media platforms, 2015 to 2017" (Lukito, 2020). 

Compared to the original version, it simply add an authomated way to detect the maximum order of integration d<sub>max</sub> required to be added to the lag length *k* of the original VAR model to estimate the (k + d<sub>max</sub>)th-order VAR required by the Toda & Yamamoto procedure (Toda & Yamamoto, 1995). As the change is minumal, if you use/reuse the code, you can cite the [jlukito] work or her GitHub repository.

**References**

Lukito, J. (2020). Coordinating a multi-platform disinformation campaign: Internet Research Agency activity on three US social media platforms, 2015 to 2017. *Political Communication*, 37(2), 238-255.

Toda, H. Y., & Yamamoto, T. (1995). Statistical inference in vector autoregressions with possibly integrated processes. *Journal of econometrics*, 66(1-2), 225-250.
