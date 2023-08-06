/*非线性面板*/
use 2004.dta
drop if missing(capital)
gen time=1 if year==2004
replace time=2 if time==.
bysort codeentr: drop if _N<2
xtset codeentr time
xtdes
/*混合回归*/
probit exp_dum foreign_dum soe_dum reg_time employees,vce(cluster codeentr)
logit  exp_dum foreign_dum soe_dum reg_time employees,vce(cluster codeentr)
/*随机效应估计*/
xtprobit exp_dum foreign_dum soe_dum reg_time employees
xtlogit  exp_dum foreign_dum soe_dum reg_time employees
est sto RE
/*固定效应*/

xtlogit  exp_dum foreign_dum soe_dum reg_time employees,fe
est sto FE

quadchk,noout/*随机效应之后,看数值积分大小，如果比较小则运算没有问题。*/
hausman FE RE /*原假设：适用随机效应模型*/
/*面板混合泊松回归*/
poisson exp_dum foreign_dum soe_dum reg_time employees,vce(cluster codeentr) irr
/*面板泊松回归*/
 xtpoisson  exp_dum foreign_dum soe_dum reg_time employees,fe irr
 est sto FE1
 xtpoisson  exp_dum foreign_dum soe_dum reg_time employees,re irr
 est sto RE1
 hausman FE1 RE1 
  
 /*面板负二项回归*/
 nbreg exp_dum foreign_dum soe_dum reg_time employees,vce(cluster codeentr)
 xtnbreg exp_dum foreign_dum soe_dum reg_time employees,fe irr
 xtnbreg exp_dum foreign_dum soe_dum reg_time employees,re irr
 
 /*面板tobit*/
 tobit exp_dum foreign_dum soe_dum reg_time employee,ll(2) ul(2)
  xttobit exp_dum foreign_dum soe_dum reg_time employees,fe irr