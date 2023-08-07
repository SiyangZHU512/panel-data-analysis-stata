/*Dynamic panels**/
use ch10_fatality_raw, clear  
/*compared with static one,dynamics panel in the regression the variable list of independent variable contain the dependent variable with lags.*/
/*Dynamic short panel data, n is very large t is relatively small. method 1 difference GMM 2. level GMM 3. system GMM */
/* difference GMM assumption no autocorrelation in the perturbation term */
xtabond vfrall spircons emppop beertax,lags(2) maxldep(3) twostep vce(robust) pre(emppop,lag(0,2)) endogenous(spircons,lag(0,2))
estat abond /* autocorrelation test**/
qui xtabond vfrall spircons emppop beertax,lags(2) maxldep(3) twostep pre(emppop,lag(0,2)) endogenous(spircons,lag(0,2))
estat sargan/* overidentification test, don't add vce when doing regression! */

/* The best way to determine the lags here is to analyze them with multiple regressions and then use hypothesis testing to determine which is better */
xtabond vfrall spircons emppop beertax,lags(2) maxldep(3) twostep vce(robust) pre(emppop,lag(1,2)) endogenous(spircons,lag(1,2))
estat abond /*autocorrelation test**/
qui xtabond vfrall spircons emppop beertax,lags(2) maxldep(3) twostep pre(emppop,lag(1,2)) endogenous(spircons,lag(1,2))
estat sargan
/* overidentification test, don't add vce when doing regression! */
/*lags---for dependent variable maxldap---is for dependent variable. and is treating it as an instrumental variable twostep---GMM pre()---is for pre-determined variable endogenous---endogenous variable, inst---instrumental variable*/
/*problem of this method 1. if the regression equation contains independent variables that are pre-determined (uncorrelated with the current disturbance term but may be problematically correlated with the previous disturbance term) --- then after differencing such variables will be correlated with the disturbance term. 2. the problem of weakly estimating the variables tends to arise when T is large. 3. if the persistence of the dependent variable is strong and the first order autoregressive coefficient is close to 1 then this may also lead to weak instrumental variable problems. */
/* Also note that the predetermined variables are determined by history and not by the equations of this system. So the predetermined variables cannot be said to be strictly exogenous either. Strictly exogenous variables are non-system equation determined (not determined by the current system equations nor with the equation structure of the history.) */
/* Level GMM: Prerequisite assumptions 1. absence of autocorrelation of randomly perturbed terms and disjointness of the dependent variable from the individual effect values */
/* compared to differential GMM - better can solve the last problem */
/* rarely used so don't care */

/*System GMM = Differential GMM and Horizontal GMM combined. Prerequisites: no autocorrelation in randomly perturbed terms Also dependent variable is uncorrelated with individual effect values */

xtdpdsys vfrall spircons emppop beertax,lags(2) maxldep(3) twostep vce(robust) pre(emppop,lag(0,2)) endogenous(spircons,lag(0,2)) 
estat abond

qui xtdpdsys vfrall spircons emppop beertax,lags(2) maxldep(3) twostep pre(emppop,lag(0,2)) endogenous(spircons,lag(0,2)) 
estat sargan
/* Solution of dynamic panel problem under long panel LSDVC-method*/
/*idea:first estimate the dynamic panel with LSDV, how to calculate the bias then subtract this bias value from the coefficient obtained from LSDV to the value of LSDVC*/
/* Limitations - requires that all independent variables have to be strictly exogenous. But endogeneity problems arise in many cases. */
xtlsdvc vfrall spircons emppop beertax,initial(ah) bias(2) vcov(50)
/*initial Specify initial value for bias correction ah--Anderson-Hsiao value, i(ab)--arellanon-bond Differential GMM estimate--initial value. i(bb) Blundell-bond System GMM estimate as initial value. bias(1)---first-order Taylor-expanded estimate bias(2)---second-order Taylor-expanded estimate.vcoc---specifies the number of samples needed to estimate the variance covariance matrix. */
