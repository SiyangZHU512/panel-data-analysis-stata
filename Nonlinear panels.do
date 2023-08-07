/*Nonlinear panels*/
use 2004.dta
drop if missing(capital)
gen time=1 if year==2004
replace time=2 if time==.
bysort codeentr: drop if _N<2
xtset codeentr time
xtdes
/*Mixed regression**/
probit exp_dum foreign_dum soe_dum reg_time employees,vce(cluster codeentr)
logit exp_dum foreign_dum soe_dum reg_time employees,vce(cluster codeentr)
/* Random effects estimation */
xtprobit exp_dum foreign_dum soe_dum reg_time employees
xtlogit exp_dum foreign_dum soe_dum reg_time employees
est sto RE
/*Fixed effects*/

xtlogit exp_dum foreign_dum soe_dum reg_time employees,fe
est sto FE

quadchk,noout/* After random effects, look at the size of the numerical integrals, if they are small then there is no problem with the operation. */
hausman FE RE /* original hypothesis: random effects model applied */
/* panel mixed Poisson regression */
poisson exp_dum foreign_dum soe_dum reg_time employees,vce(cluster codeentr) irr
/*panel Poisson regression**/
 xtpoisson exp_dum foreign_dum soe_dum reg_time employees,fe irr
 est sto FE1
 xtpoisson exp_dum foreign_dum soe_dum reg_time employees,re irr
 The following is a summary of the results of the evaluation.
 hausman FE1 RE1 
  
 /*Panel negative binomial regression**/
 nbreg exp_dum foreign_dum soe_dum reg_time employees,vce(cluster codeentr)
 xtnbreg exp_dum foreign_dum soe_dum reg_time employees,fe irr
 xtnbreg exp_dum foreign_dum soe_dum reg_time employees,re irr
 
 /*panel tobit*/
 tobit exp_dum foreign_dum soe_dum reg_time employees,ll(2) ul(2)
  xttobit exp_dum foreign_dum soe_dum reg_time employees,fe irr
