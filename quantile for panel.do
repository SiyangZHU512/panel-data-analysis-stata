use ch10_fatality_raw.dta,clear
qregpd vfrall spircons emppop beertax,id(state) fix(year)
qregpd vfrall spircons emppop beertax,id(state) fix(year) optimize(mcmc)

xtqreg vfrall spircons emppop beertax,id(state)
qregplot spircons emppop beertax