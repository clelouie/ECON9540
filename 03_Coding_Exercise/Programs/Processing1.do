*Clean voting data

foreach x in "ballots" "machines" "town state lookup" {
	import excel "$dir_data/Ballots and Machines.xlsx", firstrow sheet("`x'") clear
	
	replace town=upper(trim(town))
	replace town="CHATHAM" if town=="CHAT HAM"
	*replace town=subinstr(town," ","",.)
	duplicates drop
	
	if "`x'"=="machines" {
		foreach y in 92 96 {
			replace method`y'=upper(trim(method`y'))
			replace method`y'="OPTECH" if method`y'=="OP TECH"
		}
	}
	
	if "`x'"=="town state lookup"{
		keep town state
	}

	compress
	save "$dir_temp/`x'.dta", replace
}

use "$dir_temp/Ballots.dta"
merge 1:m town using "$dir_temp/Machines"

egen badmerge=min(_merge)

if badmerge == 3 {
	drop _merge badmerge
} 
else {
	display "STOP: bad merge"
}

reshape long blank ballot method, i(town) j(year)

save "$dir_temp/town_by_year_voting.dta", replace
	rm "$dir_temp/ballots.dta"
	rm "$dir_temp/machines.dta"
	
