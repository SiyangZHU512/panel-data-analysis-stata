/* panel with IV variables */
use ch10_fatality_raw, clear  
xtset state year
xtdes
/* intragroup differencing */  
xtivreg y varlist1 (varlist2=varlist_iv),fe
/*Note that the fixed effect here means that for within-group differencing - subtract the average**/
/* first order differencing */
xtivreg y varlist1 (varlist2=varlist_iv),fd
/* Random effects instrumental variable */
xtivreg y varlist1 (varlist2=varlist_iv),re vce(bootstrap)
/* GMM estimation when the number of instrumental variables exceeds the number of endogenous variables */
xtivreg2 y varlist1(varlist2=varlist_iv),fe gmm
xtivreg2 y varlist1(varlist2=varlist_iv),fd gmm
/*Note that xtivreg2 can only be used for fixed effects and not for random effects**/
/*Test for overidentification**/
xtoverid