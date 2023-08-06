/*长面板分析*/
/*compared to 短面板。在短面板中时期数目不多，所有可以相信随机扰动项满足独立同分布的假设。但是在长面板当中由于时期数目过多可能导致随机扰动项出现异方差和自相关的问题*/
/*长面板的主要问题：1.组间的异方差（每一个个体的随机扰动项方差不一致）  2. 组内相关 （同一组内不同时期的随机扰动项互相相关）  3.组间同期内的或者截面相关（同一时期不同个体的随机扰动项相关）*/
xtset state year
/*step1 检验是否存在以上的问题*/
/*组间异方差检验*/
xtreg vfrall spircons emppop beertax i.state, fe r
xttest3
/*原假设为同方差*/
/*or*/
xtgls vfrall spircons emppop beertax i.state year
xttest3
/*组内自相关检验*/
tab state,gen(state)
xtserial vfrall spircons emppop beertax state2-state48 year
/*note xtserial 不支持 i.state这种便捷方式的虚拟变量生成方式。所以需要手打。原假设不存在一阶的自相关。*/
/**/
/*组间同期相关的检验*/
xtreg vfrall spircons emppop beertax year,fe
xttest2 /*BP-LM test 但是只适用于长面板分析。原假设相互独立。*/
xtcsd /*对于短面板和长面板都适用,当n和t大小差不多的时候。*/
xtcsd,pesaran abs show /*如果统计量服从标准正太分布。原假设相互独立*/
xtcsd,friedman abs show  /*如果统计量服从卡方分布。同上*/
xtcsd,frees abs show   /*用得少。同上*/
/*step 2 如果存在以上问题如何做。没问题直接不管*/
/*面板矫正标准误（PCSE）---对于异方差和组间同期相关来说*/
xtpcse vfrall spircons emppop beertax,hetonly  /*由于以上问题都导致回归结果的方差估计出现问题，所以从解决问题的角度来说只需要把标准误进行修正即可*/
/*对于随机扰动项，假设其服从某种特定分布然后利用fgls进行估计减少随机扰动项对其产生的影响.hetonly这个命令意思在于假设只有异方差。如果不加这个选项则是假设异方差和自相关同时存在。*/
/*FGLS 对于组内自相关来说*/
xtpcse vfrall spircons emppop beertax,corr(ar1) 
xtpcse vfrall spircons emppop beertax,corr(psar1)
/*在FGLS 下认为随机扰动项存在所谓AR（1）关系。采用corr(ar1)--则认为在不同的个体下（AR（1）的关系不变），但是在corr(psar1)的情况下则认为不同的个体会导致函数关系的变化。如果T 比N 大很多 用后者*/
/*同时解决三种问题的方法。全面FGLS。首先利用OLS 估计残差，由残差值对于方差协方差矩阵进行估计。再将方差协方差矩阵进行利用进行FGLS估计。如若FGLS不收敛，则得到FGLS的残差对方差协方差矩阵进行二次估计。再进行FGLS，直到估计收敛为止。*/
xtgls vfrall spircons emppop beertax,panels(het) corr(ar1) igls

/* panels(iid)--假设不同个体的扰动项独立同分布。  panels(het)假设不同扰动项相互独立且有异方差。panel(cor)假设同期相关且有异方差。corr(ar1)组内自相关，但不同个体回归方程不变。corr(psar1)--组内自相关，但不同个体回归方程不一致。 igls---表示允许fgls的迭代运算。*/
/*变系数模型。长面板不仅仅可以允许每一个个体都有不同的截距项或者时间趋势（recall LSVD方法的内核以及固定效应模型的内核），同时还允许回归方程系数不一致----变系数模型*/
reg  vfrall spircons emppop beertax i.state i.state#c.spircons i.state#c.emppop i.state#c.beertax year, vce(cluster state)
/*随机系数模型*/
xtrc   vfrall spircons emppop beertax,betas /*显示对每组的系数进行估计*/
