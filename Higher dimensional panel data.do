/*Higher dimensional panel data*/
/*compared with general panels, high-dimensional panel data for fixed effects treatments do not only look at individuals and time, but may also have other dimensions. For example, individuals (city, province, industry, etc.). Each dimension has fixed effects. Also note that high-dimensional analytical techniques can be used for low-dimensional problems as well. */
use ch10_fatality_raw, clear  
reghdfe vfrall
reghdfe vfrall spircons emppop beertax,absorb(state)
reghdfe vfrall spircons emppop beertax,absorb(state) vce(cluster state)
reghdfe vfrall spircons emppop beertax,absorb(state year)
reghdfe vfrall spircons emppop beertax,absorb(state year breath jaild)

/* instrumental variables + high-dimensional panel fixed effects analysis*/
ivreghdfe yvariable controlvariable1 controlvariable2 (independentvariable=instrument_variable), absorb(indicator1 indicator2 indicator3)
/* Statistics for three problems 1. over-identification 2. under-identification 3. weak instrumental variable problem */

