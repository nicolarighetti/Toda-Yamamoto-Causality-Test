#################################################################################################################################
# TODA-YAMAMOTO CAUSALITY TEST ----
# Function to implement the Toda and Yamamoto version of Granger causality test.
# Toda, H. Y., & Yamamoto, T. (1995). Statistical inference in vector autoregressions with possibly integrated processes. 
# Journal of econometrics, 66(1-2), 225-250.
#################################################################################################################################

toda.yamamoto <- function(var.model, test = c("kpss","adf","pp")) {
  
  require(forecast)
  require(vars)
  require(aod)
  
  ty.df <- data.frame(var.model$y)
  ty.varnames <- colnames(ty.df)
  
  # [ndiffs](https://search.r-project.org/CRAN/refmans/forecast/html/ndiffs.html) estimates the number of first differences 
  # required to make a given time series stationary. 
  d.max <- max(sapply(ty.df, function(x) forecast::ndiffs(x, test = test)))
  
  # $k + d_{max}$ according to Toda & Yamamoto (1995):
  # "Having determined a lag length k, we then estimate a (k + d_{max})th-order VAR where d_{max} is the maximal order of 
  # integration that we suspect might occur in the process." 
  ty.lags <- var.model$p + d.max
  ty.augmented_var <- vars::VAR(ty.df, ty.lags, type=var.model$type)

  ty.results <- data.frame(non_granger_cause = character(0), 
                           granger_effect = character(0), 
                           chisq = numeric(0), 
                           p = numeric(0))
  
  # Work in Progress ####
  for (k in 1:length(ty.varnames)) {
    for (j in 1:length(ty.varnames)) {
      if (k != j){

        # coefficient to test, ignoring the $d_{max}$ lags
        ty.coefres <- head(grep(ty.varnames[j], 
                                setdiff(colnames(ty.augmented_var$datamat), 
                                        colnames(ty.augmented_var$y))))
        
        wald.res <- wald.test(b=coef(ty.augmented_var$varresult[[k]]), 
                              Sigma=vcov(ty.augmented_var$varresult[[k]]),
                              Terms = ty.coefres) 
        
        ty.results <- rbind(ty.results, data.frame(
          non_granger_cause = ty.varnames[j], 
          granger_effect = ty.varnames[k], 
          chisq = as.numeric(wald.res$result$chi2[1]),
          p = wald.res$result$chi2[3])
          )
      }
    }
  }
  return(ty.results)
}

