/*动态面板*/
use ch10_fatality_raw, clear  
/*compared with static one,dynamics panel in the regression the variable list of independent variable contain the dependent variable with lags.*/
/*动态短面板数据，n很大t比较小。method 1 difference GMM 2.水平GMM 3.系统GMM*/
/*差分GMM assumption 扰动项不存在自相关*/
xtabond  vfrall spircons emppop beertax,lags(2) maxldep(3) twostep vce(robust) pre(emppop,lag(0,2)) endogenous(spircons,lag(0,2))
estat abond /*自相关检验*/
qui xtabond  vfrall spircons emppop beertax,lags(2) maxldep(3) twostep pre(emppop,lag(0,2)) endogenous(spircons,lag(0,2))
estat sargan/*过度识别检验，做回归的时候不要加vce！！*/

/*这里lags 的确定最好的方法在于用多种回归进行分析然后利用假设检验进行判断哪个比较好*/
xtabond  vfrall spircons emppop beertax,lags(2) maxldep(3) twostep vce(robust) pre(emppop,lag(1,2)) endogenous(spircons,lag(1,2))
estat abond /*自相关检验*/
qui xtabond  vfrall spircons emppop beertax,lags(2) maxldep(3) twostep pre(emppop,lag(1,2)) endogenous(spircons,lag(1,2))
estat sargan/*过度识别检验，做回归的时候不要加vce！！*/
/*lags--for dependent variable maxldap---is for dependent variable.并且是将其视作工具变量  twostep--GMM  pre()---is for 前定变量 endogenous---内生变量， inst--工具变量*/
/*problem of this method 1.如果回归方程包含的自变量属于前定变量（与当前扰动项不相关但是可能与前面的扰动项相关存在问题）---那么差分之后这种变量就会与扰动项相关。2.当T很大容易出现弱估计变量问题。 3.如果因变量的持续性很强，一阶自回归系数接近1那么也可能导致弱工具变量问题。*/
/*同时注意前定变量是由历史决定的而非本系统方程决定。所以前定变量也不能说是严格外生的。严格外生变量是非系统方程决定（不由当期系统方程决定也不随历史的方程结构决定。）*/
/*水平GMM：前提假设1.随机扰动项不存在自相关以及因变量与个体效应值不相干*/
/*相比于差分GMM --更优可以解决最后一个问题*/
/*很少用所以不管*/

/*系统GMM=差分GMM和水平GMM 结合在一起。前提：随机扰动项不存在自相关同时因变量与个体效应值不相干*/
xtdpdsys vfrall spircons emppop beertax,lags(2) maxldep(3) twostep vce(robust) pre(emppop,lag(0,2)) endogenous(spircons,lag(0,2)) 
estat abond
qui xtdpdsys vfrall spircons emppop beertax,lags(2) maxldep(3) twostep pre(emppop,lag(0,2)) endogenous(spircons,lag(0,2)) 
estat sargan
/*长面板下的动态面板问题的解决 LSDVC-method*/
/*idea:先对动态面板用LSDV进行估计，如何计算出bias 再用LSDV得到的系数减去这个bias值得到 LSDVC的值*/
/*局限性---要求所有的自变量都得是严格外生的。但是很多情况下会出现内生性问题。*/
xtlsdvc vfrall spircons emppop beertax,initial(ah) bias(2) vcov(50)
/*initial 指定偏误校正的初始值 ah--Anderson-Hsiao value，i(ab)---arellanon-bond 差分 GMM 估计量--初始值。i(bb) Blundell-bond 系统GMM 估计量作为初始值。 bias(1)---一阶泰勒展开估计  bias(2)--二阶泰勒展开估计.vcoc---指定估计方差协方差矩阵需要抽样次数。*/