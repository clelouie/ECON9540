*Summary Statistics

use "$dir_temp/town_by_year_voting.dta", clear
merge m:1 town using "$dir_temp/town state lookup.dta"

bysort state: egen avg_blank=mean(blank)

collapse blank ballot, by(state year)
