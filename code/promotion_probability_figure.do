*******************************************************************************
* PROMOTION PROBABILITY BY FIELD (Part of status analysis, which only         *
* appears in the online appendix)                                             *
*******************************************************************************

clear
use ../data/working_ias
by id: generate promoted = sum(promote)
replace promoted = 0 if promote == 1
drop if promoted == 1
drop if _t < 48
bysort majmaxlabp: egen npromoted = total(promote)
by majmaxlabp: gen majpromoterate = npromoted/_N
sort majpromoterate majmaxlabp
gen group = majmaxlabp != majmaxlabp[_n-1]
replace group = sum(group)
generate rankpromote = (-1*(group-37))+1
label define groups 1 "Petroleum" 2 "Commerce" 3 "Pub Wks" 4 "Lab & Emp" 5 "Mines" ///
	6 "Defence" 7 "HR Dev" 8 "Personnel" 9 "Energy" 10 "Environ" 11 "Industries" ///
	12 "Information" 13 "Comms & IT" 14 "Youth & Sport" 15 "Culture" 16 "Finance" ///
	17 "Agric" 18 "Tourism" 19 "Sci & Tech" 20 "Cons Aff" 21 "LRM & DA" 22 "Transport" ///
	23 "Home" 24 "Health & Fam" 25 "Soc Just" 26 "Corp Mgmt" 27 "Law & Just" 28 "Urban Dev" ///
	29 "Water" 30 "NA" 31 "Textiles" 32 "Women & Child" 33 "Rural Dev" 34 "Planning" ///
	35 "Staff Offs" 36 "Parliament" 37 "Loc Self Gov"
label values rankpromote groups
graph hbox ln_majherf, over(rankpromote) intensity(0) nooutsides ysize(9) xsize(6) ///
	ytitle(Logged Specialization) alsize(0) ///
	graphregion(fcolor(white)) ylabel(-2.09 -1.83 -1.59 -1.30 -.854, alternate nogrid)
graph export "../figures/specialization_promote_probability.eps", ///
	as(eps) preview(on)
* Added for the ASQ graph, which I fixed up with the editor
graph export "../figures/Promote_probability.eps", as(eps) preview(on)

*******************************************************************************
* FIGURE SHOWING DIFFERENT SKILL LEARNING BY SPECIALIZATION -- deprecated,    *
* because we no longer discuss this conceptual model in the paper.            *
*******************************************************************************
/*twoway (function y=exp(-(2-x)), range(0 2) lcolor(black) lpattern(dash)) ///
	(function y=-exp(-x), range(0 2) lcolor(black) lpattern(dash)) ///
	(function y=-exp(-x)+exp(-(2-x)), range(0 2) lcolor(black)), ///
	legend(off) graphregion(fcolor(white)) ///
	ytitle(V(t)) ylabel(-1 "Low" 0 "Med" 1 "Hi", angle(0) nogrid) ///
	xscale(off) yline(0, lstyle(foreground)) ///
	text(-.075 2 "T") text(.3 .4 "K(t)") text(-.8 .4 "U(t)") ///
	text(.25 1.5 "K+U") text(-.075 1 "t*")
graph export "../figures/model1.eps", as(eps) preview(on) replace
graph export "../figures/model1.png", as(png) replace

twoway (function y=exp(-(2-x)), range(0 2) lcolor(gs8) lpattern(dot)) ///
	(function y=-exp(-x), range(0 2) lcolor(gs8) lpattern(dot)) ///
	(function y=-exp(-x)+exp(-(2-x)), range(0 2) lcolor(gs8)) ///
	(function y=2*exp(-(2-x)), range(0 2) lcolor(black) lpattern(dash)) ///
	(function y=-exp(-2*x), range(0 2) lcolor(black) lpattern(dash)) ///	
	(function y=-exp(-2*x)+2*exp(-(2-x)), range(0 2) lcolor(black)), ///
	legend(off) graphregion(fcolor(white)) ///
	ytitle(V(s,t)) ///
	ylabel(-1 "Low" 0 "Med" 1 "Hi" 2 "Hi*", angle(0) nogrid) ///
	xscale(off) yline(0, lstyle(foreground)) ///
	text(-.075 2 "T") text(.2 1.5 "K+U (s=1)", color(gs8)) ///
	text(.65 1.25 "K+U (s=2)") ///
	text(-.075 .45 "t*'") text(-.075 1 "t*", color(gs8))
graph export "../figures/model2.eps", as(eps) preview(on) replace
graph export "../figures/model2.png", as(png) replace*/

