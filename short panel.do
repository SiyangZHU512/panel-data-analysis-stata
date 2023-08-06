local FILENAME SW_Ch10_data             // FILENAME is a local (replacement variable)

version 11.1                            // This program is run on StataSE 11.1
clear                                   // Clean up memory before this program works
capture log close                       // Close out old log file (if any)
log using `FILENAME'_out, replace       // Keep output in a log file 
set more off                            // Program runs from start to end 
use ch10_fatality_raw.dta,replace
xtset state year
xtdes  /*check the data set is balanced panel or not,note it is no saying the balanced panel is better than the unbalance one. It is depend on different cases*/
/*balance panel and unbalance panel：balance panels have the same number of individuals over time, unbalanced one does not have the same number of individuals over all time.*/
xtsum vfrall spircons emppop beertax
xtline vfrall
/*Mixed regression vs. clustering standard error*/
reg vfrall spircons emppop beertax
estimate sto OLS
eststo col1
estadd scalar adj_r = e(r2_a) 
reg vfrall spircons emppop beertax,vce(cluster state)
eststo col2
estadd scalar adj_r = e(r2_a) 
/* Both mixed regressions and clustered standard errors treat the panel data as if it were cross-sectional (the implication being that the regression results do not vary significantly across individuals and over time). But note that the difference between mixed regression and clustered standard errors is that clustering adjusts for standard errors. Note that the clustering standard error assumes that the random perturbation terms, while independent of each other from individual to individual, are slightly different across time for the same individual - autocorrelation - the elements of the variance covariance matrix other than the diagonal may be non-zero. all clustering will correlate to this problem */
/* Individual fixed effects */
xtreg vfrall spircons emppop beertax,fe r
estimate sto FE_R
eststo col3
estadd scalar adj_r = e(r2_a) 
xtreg vfrall spircons unrate emppop beertax,fe
estimate sto FE
eststo col4
estadd scalar adj_r = e(r2_a) 
reg  vfrall spircons emppop beertax i.state,vce(cluster state)
estimate sto LSDV
eststo col5
estadd scalar adj_r = e(r2_a) 
/*The individual fixed effect assumes that each individual has some element that is not included in the data but differs between individuals. And that this element not included is correlated with some x-variable that already exists. If the OLS is estimated directly - inconsistently. Then some method can be used to eliminate such variables before estimation. The LSDV is based on the same understanding as the individual fixed panel, but it assumes that there is a dummy for different individuals and uses this dummy to represent different individual differences. However, this method is only applicable to panels with fewer individuals. */
/* Time fixed effects */
xtreg vfrall spircons unrate emppop beertax year2-year6,fe
/* The idea is that individual changes do not affect the outcome, whereas temporal changes do - similar to how individuals merely become temporal dimensions. */
/* double fixed effects */
xtreg vfrall spircons emppop beertax i.year,fe r
estimate sto Year
eststo coll1
estadd scalar adj_r = e(r2_a) 
/* Consider that changes in both dimensions are likely to cause problems */
/* Random effects FGLS*/
xtreg vfrall spircons emppop beertax,re theta
estimate sto RE
eststo coll2
estadd scalar adj_r = e(r2_a) 
/* Among random effects it is assumed that such omitted variables are independent of the existing x and can be estimated directly by OLS, which is rarely the case. */
/* Random effects Hypothesis testing - reject if significant == fixed effects */
xttest0
/* Random effects MLE*/
xtreg vfrall spircons emppop beertax,mle nolog
estimate sto mle
eststo coll3
estadd scalar adj_r = e(r2_a) 
/* Random effects Within-group issues */
xtreg vfrall spircons emppop beertax,be
estimate sto be
eststo coll4
estadd scalar adj_r = e(r2_a) 
/*Original assumption that the random effects model is significant*/
hausman FE RE,constant sigmamore
xtreg vfrall spircons emppop beertax,re r
xtoverid 
/*xttest0, hausman, and xtoverid are all testing whether to use a random effects model or a fixed effects model. Rejecting the hypothesis uses the fixed effects model. */
estimates table OLS FE_R FE RE be mle LSDV,b se 
esttab col* using SW_Ch10_Tables.rtf, replace `setesttab'                                           ///
       title(Table 10.1: Regression Analysis of the Effect of Drunk Driving Laws on Traffic Deaths) ///
       mtitles("OLS" "cluster" "FE_r" "LSDV") 
esttab coll* using SW_Ch10_Tables1.rtf, replace `setesttab'                                           ///
       title(Table 10.1: Regression Analysis of the Effect of Drunk Driving Laws on Traffic Deaths) ///
       mtitles("FE" "Year" "RE" "be" "mle") 
/*Original assumption that the random effects model is significant*/
xtoverid 