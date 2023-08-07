/*Unit root test and cointegration test*/
use ch10_fatality_raw, clear  
xtset state year
xtdes /*check the data set is balanced panel or not,note it is no saying the balanced panel is better than the unbalance one. it is depend on different cases /It is depend on different cases*.
/*Unit root test*/ /*LLC test*/
/*LLC test*/
xtunitroot llc vfrall
xtunitroot llc vfrall,lags(4) /*ADF test*/ /*HT test*/ /*LLC test

/*HT test*/
xtunitroot ht vfrall
/*Breitung test*/ /*HT test*/ xtunitroot ht vfrall
xtunitroot breitung vfrall
/*IPS test --for unbalance panel*/
xtunitroot ips vfrall
/*Fisher-type*/
xtunitroot fisher vfrall,pperron lags(1)
/*Hadri LM*/
xtunitroot hadri vfrall,kernel(bartlett)

/*cointegration test*/
/*kao test*/
xtcointtest kao vfrall spircons emppop beertax
/*Primary hypothesis: there is no cointegration. Alternative hypothesis: there is cointegration on all panels */
/*pedroni*/
xtcointtest pedroni vfrall spircons emppop beertax
/*Original hypothesis: that there is no autoregression on panel. */
xtcointtest pedroni vfrall spircons emppop beertax,ar(same)
/* The autoregressive equation is the same in this case, without labeling it is assumed to be different */
/*westerlund:Alternative hypothesis assumes that there are some panels with cointegration, not all. */
xtcointtest westerlund vfrall spircons emppop beertax