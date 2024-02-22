use ../working_ias.dta
la var id "Unique officer ID"
la var level "Pay-scale level"
la var exp1 "Major experience of posting"
la var monthstart "Starting month of posting"
la var monthend "Ending month of posting"
forv i = 1/4 {
	la var division`i' "Graduating division: degree `i'"
	la var degreetypes`i' "Degree type: degree `i'"
}
la de yesno 1 "Yes" 2 "No"
la val hasDoctorate yesno
la val hasGraduate yesno
la var hasDoctorate "Holds doctorate"
la var hasGraduate "Holds graduate degree"
la de recruitment 1 "Regular recruitment" 2 "State civil service" ///
	3 "Non SCS" 4 "Selection" 5 "IC", modify
forv i = 1/6 {
	la var xlang`i' "Other languages (if listed)"
}
la var period "Month of spell"
la var origin "Start of spell observations"
drop notincenter
drop _t
drop bengali-cohort5
la var suba1_r "Subject (up to 3) of first degree"
la var subb1_r "Subject (up to 3) of first degree"
la var subc1_r "Subject (up to 3) of first degree"
la var suba2_r "Subject (up to 3) of second degree"
la var subb2_r "Subject (up to 3) of second degree"
la var subc2_r "Subject (up to 3) of second degree"
la var suba3_r "Subject (up to 3) of third degree"
la var subb3_r "Subject (up to 3) of third degree"
la var subc3_r "Subject (up to 3) of third degree"
la var suba4_r "Subject (up to 3) of fourth degree"
la var subb4_r "Subject (up to 3) of fourth degree"
la var subc4_r "Subject (up to 3) of fourth degree"
drop promote-_tjscy
order id origin period 
la data "Ferguson & Hasan 2013 ASQ IAS Officer Records, 1974-2008"
save ../data/ferguson_hasan_2013asq_IAS_records.dta, replace
