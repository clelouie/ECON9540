clear

set seed 6767

*Generate initial data
set obs 10000

gen ability=rnormal(0,1)
gen omega=rnormal(0,1)
gen college=(ability-omega>0)

gen Y_0=10*ability+rnormal(0,1)
gen Y_1=Y_0+2
gen earnings=50+Y_1*college+Y_0*(1-college)

*PART A
reg earnings college, r //Baseline regression
reg earnings college ability, r //True regression accounting for ability

*PART B
**Generate parental vars
gen omega_p=rnormal(0,1)
gen ability_p=rnormal(ability,1)
gen occupation_p=(ability_p+omega_p>0)

reg earnings college occupation_p, r //Parent ability as proxy for true ability
//ssc install psacalc
local rmax=e(r2)*1.3
psacalc beta college, rmax(`rmax') //Increase R2 by 30%
psacalc beta college //Increase R2 to 1

*PART C
**Redefine parental vars
replace ability_p=rnormal(ability,0.5)
replace occupation_p=(ability_p+omega_p>0)

reg earnings college occupation_p, r //New parent ability as proxy
local rmax=e(r2)*1.3
psacalc beta college, rmax(`rmax') //Increase R2 by 30%
psacalc beta college //Increase R2 to 1

*PART D
**Define vars
gen occupation=(rnormal(0,1)>0)
gen high_ability=(ability>0)

**White collar if low-ability and college
gen occupation_low=occupation
replace occupation_low=1 if (!high_ability & college)

reg occupation_low college, r
***Earnings on college split by occupation status
reg earnings college if occupation_low==1, r
reg earnings college if occupation_low==0, r

**White collar if high-ability and college
gen occupation_high=occupation
replace occupation_high=1 if (high_ability & college)

reg occupation_high college, r
***Earnings on college split by occupation status
reg earnings college if occupation_high==1, r
reg earnings college if occupation_high==0, r

**Observing ability
reg earnings college occupation_low, r
reg earnings college occupation_low ability, r

reg earnings college occupation_high, r
reg earnings college occupation_high ability, r
