/*Long panel analysis*/
/*compared to short panel. In the short panel, the number of periods is small, and the randomly perturbed terms can be trusted to satisfy the assumption of being independently and identically distributed. However, in the long panel, the large number of periods may lead to heteroskedasticity and autocorrelation problems in the randomly perturbed terms */.
/*The main problems in the long panel: 1. Heteroskedasticity between groups (the variance of the random perturbation term is not the same for each individual) 2. Intra-group correlation (random perturbation terms in different periods within the same group are correlated with each other) 3. Intra-contemporaneous or cross-sectional correlation between groups (the random perturbation terms of different individuals in the same period are correlated)*/
local FILENAME SW_Ch10_data             // FILENAME is a local (replacement variable)

version 11.1                            // This program is run on StataSE 11.1
clear                                   // Clean up memory before this program works
capture log close                       // Close out old log file (if any)
log using `FILENAME'_out, replace       // Keep output in a log file 
set more off                            // Program runs from start to end 
use ch10_fatality_raw.dta,replace
xtset state year
xtdes  
/*step1 test to see if any of the above exist*/
/* test for heteroskedasticity between groups */
xtreg vfrall spircons emppop beertax i.state, fe r
xttest3
/* original hypothesis of homoskedasticity */
/*or*/
xtgls vfrall spircons emppop beertax i.state year
xttest3
/* within-group autocorrelation test */
tab state,gen(state)
xtserial vfrall spircons emppop beertax state2-state48 year
/*note xtserial does not support i.state as a convenient way to generate dummy variables. So it needs to be typed by hand. The original assumption is that there is no first-order autocorrelation. */
/**/
/* Test for contemporaneous correlation between groups */
xtreg vfrall spircons emppop beertax year,fe
xttest2 /*BP-LM test But only for long panel analysis. The original hypotheses are independent of each other. */
xtcsd /* For both short and long panels, when n and t are about the same size. */
xtcsd,pesaran abs show /* If the statistic obeys the standard positive-tai distribution. The original hypotheses are independent of each other */
xtcsd,friedman abs show /* If the statistic follows a chi-square distribution. Same as above */
xtcsd,frees abs show /* Used sparingly. Ibid */
/*step 2 What to do if the above problem exists. No problem just ignore it */
/* panel corrected standard error (PCSE) - for heteroskedasticity and contemporaneous correlation between groups */
xtpcse vfrall spircons emppop beertax,hetonly /*Since the above problems all lead to problems with the estimation of the variance of the regression results, from the point of view of solving the problem, it is only necessary to correct the standard error */
/* For the random disturbance term, assume that it follows a particular distribution and then use fgls to estimate it to reduce the effect of the random disturbance term on it. hetonly This command means to assume that there is only heteroskedasticity. If you do not add this option, you are assuming both heteroskedasticity and autocorrelation. */
/*FGLS For within-group autocorrelation */
xtpcse vfrall spircons emppop beertax,corr(ar1) 
xtpcse vfrall spircons emppop beertax,corr(psar1)
/* The so-called AR(1) relation is considered to exist for the random perturbation term under FGLS. Using corr(ar1) - then it is considered that under different individuals (the AR(1) relation is unchanged), but under corr(psar1) it is considered that different individuals lead to a change in the functional relation. If T is much larger than N Use the latter */
/* Methods for solving all three problems simultaneously. Full FGLS. first estimate the residuals using OLS and from the residual values for the variance covariance matrix. The variance covariance matrix is then used for FGLS estimation. If the FGLS does not converge, the residuals from the FGLS are obtained for the quadratic estimation of the variance covariance matrix. FGLS is performed again until the estimation converges. */
xtgls vfrall spircons emppop beertax,panels(het) corr(ar1) igls

/* panels(iid)-assume that the perturbation terms of different individuals are independently and identically distributed.  panels(het) assumes that the different perturbation terms are independent of each other and heteroskedastic. panels(cor) assumes that they are correlated and heteroskedastic over the same period. corr(ar1) autocorrelation within the group but the regression equations are constant across individuals. corr(psar1) - autocorrelation within the group but the regression equations are not consistent across individuals. igls - indicates that the iterative operation of fgls is allowed. */
/* Variable coefficient models. Long panels not only allow each individual to have a different intercept term or time trend (kernel for the recall LSVD method as well as the kernel for the fixed effects model), but also allow for regression equation coefficients to be inconsistent ---- Variable coefficient models */
reg vfrall spircons emppop beertax i.state i.state#c.spircons i.state#c.emppop i.state#c.beertax year, vce(cluster state)
/* stochastic coefficient model */
xtrc vfrall spircons emppop beertax,betas /*shows coefficients estimated for each group**/
