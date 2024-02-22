*******************************************************************************
* NOTE: This file was reorganized in July 2015, to bring together several     *
* files that had been in the original research directory. All of the code to  *
* replicate the article's results is in here, but it has not been debugged.   *
* It is possible that some of the code calls for variables that have not been *
* created, because we had something in a different order in one of the other  *
* files. Still, it is quite a bit easier to follow than what had been in this *
* directory! JPF                                                              *
*******************************************************************************

/* Homophily */
clear
clear matrix
use ../data/working_ias
	preserve
	keep if organization == 2
	quietly tab cadre, g(cadre)
	quietly tab allotYear, g(allotYear)
	g tempyear = allotYear-1969
	sort period exp1 cadre id
	by period exp1: gen nInMajor = _N
	by period exp1 cadre: gen cadreInMajor = _N
	sort period exp1 allotYear id
	by period exp1 allotYear: gen cohortInMajor = _N
	forv i = 1/24 {
		replace cadre`i' = cadreInMajor if cadre == `i'
		replace cadre`i' = cadre`i'/nInMajor
		}
	forv i = 1/32 {
		replace allotYear`i' = cohortInMajor if cadre == `i'
		replace allotYear`i' = allotYear`i'/nInMajor
		}
	by period exp1: keep if _n == 1
	sort exp1 period
	foreach var of varlist cadre1-allotYear32 {
		by exp1: g l_`var' = `var'[_n-1]
		drop `var'
		rename l_`var' `var'
		}
	keep period exp1 nInMajor-allotYear32
	sort period exp1
	compress
	save ../data/center_composition, replace
	restore
sort period exp1
merge period exp1 using ../data/center_composition
gen myCadreInMajor = 0
forv i = 1/24 {
	replace myCadreInMajor = cadre`i' if cadre == `i'
	}
gen myCohortInMajor = 0
gen tempyear = allotYear-1969
forv i = 1/32 {
	replace myCohortInMajor = allotYear`i' if tempyear == `i'
	}
erase ../data/center_composition.dta

/* Political change */
sort cadre period
* Note that we open cmchanges.dta, keep by cadre/period if _n==_N
* and save as cmchanges2.dta
drop _merge
merge m:1 cadre period using ../data/cmchanges2.dta
sort id period
by id: generate cmchanged = cmchange == 1 | cmchange[_n-1] == 1
sort cadre cyear, stable
egen cadreyear=group(cadre cyear)
sort id period, stable

/* Grade of Membership */
* quietly tabulate exp1, g(major)
sort id period
foreach var of varlist major1-major40 {
	by id: g lg`var' = (1+sum(`var'))
	}

/* Rare Experience */
egen keep = anymatch(exp), values(20 24 30 13 26 17 1 37 32 15 5 28 16 22 99 14)
egen common = anymatch(exp1), values(20 24 30 13 26 17 1 37 32 15 5 28 16 22 99 14)
gen rare = abs(keep-1)
drop keep common

capture quietly tab numdegrees, g(degreen)

label variable myCadreInMajor "Cadre share in Centre"
label variable myCohortInMajor "Cohort share in Centre"

label variable promote "Promotion to Centre"
label variable majherf "Specialization"
label variable ln_majherf "Specialization"
label variable nummoves "Postings"
label variable  nummoves2 "(Postings)$^{2}$"
label variable age "Age"
label variable  age2 "(Age)$^{2}$"
label variable engineering "Engineering"
label variable humanities "Humanities"
label variable medicine "Medicine"
label variable professional "Professional"
label variable science "Science"
label variable business "Business"
label variable law "Law"
label variable numsubs "No. of Subjects"
label variable female "Female"
label variable hasDoctorate "Doctorate "
label variable hasGraduate "Graduate"
label variable firstdivision "First Division "
label variable degreen2 "Two degrees"
label variable degreen3 "Three degrees"
label variable degreen4 "Four degrees"
label variable hindi "Hindi"
label variable punjabi "Punjabi"
label variable bengali "Bengali"
label variable telugu "Telugu"
label variable marathi "Marathi"
label variable tamil "Tamil"
label variable _t "IAS Tenure"
label variable cmchanged "New Chief Minister"
label variable jscypromote "Empanelment as Joint Secretary"
label variable ln_postherf "Specialization (Post)"
label variable ln_firstherf "Specialization (Pre)"
label variable promotehat "P(Promotion to Centre)"

* save ../data/ttemp.dta, replace

egen cusevar = rowmiss(promote nummoves age ///
	female hindi bengali telugu marathi tamil ///
	firstdivision engineering-science business law numsubs degreen2-degreen4 ///
	cmchanged ln_majherf _t)
gen cuse = cusevar==0 & recruitment==1

* estpost requires the estout package
estpost summarize promote nummoves age female ///
	hindi bengali telugu marathi tamil ///
	firstdivision engineering-science business law numsubs degreen2-degreen4 ///
	myCadreInMajor myCohortInMajor cmchanged ///
	ln_majherf if cuse == 1
esttab . using "tables/summarycentre.tex", cells("count(fmt(0)) mean(fmt(3)) sd(fmt(2))") label title(Summary statistics: First posting to central government analysis \label{summarycentre}) nomtitles nonumbers replace

eststo clear
eststo: quietly logit promote nummoves nummoves2 age age2 _t ln_majherf if recruitment == 1, cluster(id)
eststo: quietly logit promote nummoves nummoves2 age age2 _t ln_majherf i.cadre i.cohort5 i.cyear if recruitment == 1, cluster(id)
eststo: quietly logit promote nummoves nummoves2 age age2 _t ln_majherf i.cadre i.cohort5 i.cyear female hindi bengali telugu marathi tamil if recruitment == 1, cluster(id)
eststo: quietly logit promote nummoves nummoves2 age age2 _t ln_majherf i.cadre i.cohort5 i.cyear female hindi bengali telugu marathi tamil firstdivision engineering-science business law numsubs degreen2-degreen4 if recruitment == 1, cluster(id)
eststo: quietly logit promote nummoves nummoves2 age age2 _t ln_majherf i.cadre i.cohort5 i.cyear female hindi bengali telugu marathi tamil firstdivision engineering-science business law numsubs degreen2-degreen4 myCadreInMajor myCohortInMajor cmchanged if recruitment == 1, cluster(id)
esttab est1 est2 est3 est4 using "tables/centrepromote_1.tex", label se scalars(ll) keep(nummoves nummoves2 age age2 _t ln_majherf female hindi bengali telugu marathi tamil firstdivision engineering humanities medicine professional science business law numsubs degreen2 degreen3 degreen4) title(Logistic Regressions of First Posting to Central Government \label{centrepromote}) nogaps nomtitles nodepvars longtable replace
esttab est5 using "tables/centrepromote_2.tex", label se scalars(ll) keep(nummoves nummoves2 age age2 _t ln_majherf female hindi bengali telugu marathi tamil firstdivision engineering humanities medicine professional science business law numsubs degreen2 degreen3 degreen4 myCadreInMajor myCohortInMajor cmchanged) title(Logistic Regressions of First Posting to Central Government \label{centrepromote}) nogaps nomtitles nodepvars longtable replace

eststo: quietly logit promote nummoves nummoves2 age age2 _t ln_majherf i.cadre i.cohort5 i.cyear female hindi bengali telugu marathi tamil firstdivision engineering-science business law numsubs degreen2-degreen4 myCadreInMajor myCohortInMajor cmchanged if recruitment == 1 & _t < 145, cluster(id)
eststo: quietly logit promote nummoves nummoves2 age age2 _t ln_majherf i.cadre i.cohort5 i.cyear female hindi bengali telugu marathi tamil firstdivision engineering-science business law numsubs degreen2-degreen4 myCadreInMajor myCohortInMajor cmchanged rare if recruitment == 1, cluster(id)
eststo: quietly logit promote nummoves nummoves2 age age2 _t ln_majherf i.cadre i.cohort5 i.cyear female hindi bengali telugu marathi tamil firstdivision engineering-science business law numsubs degreen2-degreen4 myCadreInMajor myCohortInMajor cmchanged rare lgmajor2-lgmajor40 if recruitment == 1, cluster(id)
esttab est6 est7 est8 using "tables/centrepromote2.tex", label se scalars(ll) keep(nummoves nummoves2 age age2 _t female hindi bengali telugu marathi tamil firstdivision engineering humanities medicine professional science business law numsubs degreen2 degreen3 degreen4 myCadreInMajor myCohortInMajor cmchanged rare ln_majherf) title(Logistic Regressions of First Posting to Central Government, II \label{centrepromote2}) nogaps nomtitles nodepvars longtable replace

* preserve
*	by id: g promoted2 = sum(promote)
*	by id: replace promoted2 = promoted2[_N]
*	keep if promoted2 > 0
*	keep if recruitment == 1 & cyear > 1977
*	keep promote nummoves nummoves2 age age2 _t myCadreInMajor myCohortInMajor cmchanged ln_majherf cyear id lgmajor2-lgmajor40
*	save ../data/centre_ife_26oct2011.dta, replace
*	eststo: quietly logit promote nummoves nummoves2 age age2 _t ln_majherf myCadreInMajor myCohortInMajor cmchanged lgmajor2-lgmajor40 i.cyear i.id, iterate(20)
*	esttab using "tables/centre25oct2011.tex_3", label se scalars(ll) keep(nummoves nummoves2 age age2 _t myCohortInMajor cmchanged ln_majherf) title(Logistic Regressions of First Posting to Central Government \label{centre_promote}) nogaps nomtitles nodepvars longtable replace
*restore

egen jusevar = rowmiss(promote nummoves age ///
	female hindi bengali telugu marathi tamil ///
	firstdivision engineering-science business law numsubs degreen2-degreen4 ///
	ln_majherf _tjscy)
gen juse = jusevar==0 & recruitment==1

estpost summarize promote nummoves age female ///
	hindi bengali telugu marathi tamil ///
	firstdivision engineering-science business law numsubs degreen2-degreen4 ///
	ln_majherf if juse == 1
esttab . using "tables/summaryjscy.tex", cells("count(fmt(0)) mean(fmt(3)) sd(fmt(2))") label title(Summary statistics: Empanelment to Joint Secretary analysis \label{summaryjscy}) nomtitles nonumbers replace

eststo clear
*eststo: quietly logit jscypromote nummoves nummoves2 age age2 _tjscy ln_majherf if recruitment == 1, cluster(id)
*eststo: quietly logit jscypromote nummoves nummoves2 age age2 _tjscy ln_majherf i.cadre i.cohort5 i.cyear if recruitment == 1, cluster(id)
*eststo: quietly logit jscypromote nummoves nummoves2 age age2 _tjscy ln_majherf i.cadre i.cohort5 i.cyear female hindi bengali telugu marathi tamil if recruitment == 1, cluster(id)
eststo: quietly logit jscypromote nummoves nummoves2 age age2 _tjscy ln_majherf i.cadre i.cohort5 i.cyear female hindi bengali telugu marathi tamil firstdivision engineering-science business law numsubs degreen2-degreen4 if recruitment == 1, cluster(id)
eststo: quietly logit jscypromote nummoves nummoves2 age age2 _tjscy ln_majherf i.cadre i.cohort5 i.cyear female hindi bengali telugu marathi tamil firstdivision engineering-science business law numsubs degreen2-degreen4 promotehat if recruitment == 1, cluster(id)
eststo: quietly logit jscypromote nummoves nummoves2 age age2 _tjscy ln_majherf i.cadre i.cohort5 i.cyear female hindi bengali telugu marathi tamil firstdivision engineering-science business law numsubs degreen2-degreen4 promotehat cmchanged if recruitment == 1, cluster(id)
eststo: quietly logit jscypromote nummoves nummoves2 age age2 _tjscy ln_majherf i.cadre i.cohort5 i.cyear female hindi bengali telugu marathi tamil firstdivision engineering-science business law numsubs degreen2-degreen4 promotehat cmchanged lgmajor2-lgmajor40 if recruitment == 1, cluster(id)

esttab est1 est2 est3 est4 using "tables/jscypromote.tex", label se scalars(ll) keep(nummoves nummoves2 age age2 _tjscy female hindi bengali telugu marathi tamil firstdivision engineering humanities medicine professional science business law numsubs degreen2 degreen3 degreen4 ln_majherf promotehat cmchanged) title(Logistic Regression Predicting Empanelment as Joint Secretary \label{jscypromote}) nogaps nomtitles nodepvars longtable replace
esttab, label se scalars(ll) keep(nummoves nummoves2 age age2 _tjscy female hindi bengali telugu marathi tamil firstdivision engineering humanities medicine professional science business law numsubs degreen2 degreen3 degreen4 ln_majherf promotehat) title(Logistic Regression Predicting Empanelment as Joint Secretary   \label{jscy}) nogaps nomtitles nodepvars longtable replace

/* Generate indicators for experience at each time */
quietly tabulate exp1, g(pre_major)
foreach var of varlist pre_major1-pre_major40 {
	by id: g lg`var' = (1+sum(`var'))
}
gen majmaxall = lgpre_major1
gen int majmaxlaball = 1

/* Generate counts for experience at each time */
notes majmaxlaball: Major experience in career
local i = 1
while `i' <= 40 {
   	replace majmaxlaball = `i' if lgpre_major`i' > majmaxall
   	replace majmaxall = lgpre_major`i' if lgpre_major`i' > majmaxall
   	local i = `i' + 1
}
label values majmaxlaball nmaj_exp
  
/* Generate variable indicating the major upon promotion */  
gen centremaj = exp1 if promote == 1   
label values centremaj nmaj_exp

/* Table sorted by most common majors */  
tab centremaj if promote == 1 & _t != ., sort

/* Create five dummy variables indicating whether the officer has most of their 
   pre New Delhi promotion experience in finance, industries, home, personnel 
   and commerce. */ 
g cpersonnel = majmaxlaball == "Personnel & General Admn":nmaj_exp
g ccommerce = majmaxlaball == "Commerce":nmaj_exp
g cfinance = majmaxlaball == "Finance":nmaj_exp
g cindustries = majmaxlaball == "Industries":nmaj_exp
g chome = majmaxlaball == "Home":nmaj_exp

/* Create variable labels */
label variable age "Age"
label variable nummoves "Postings"
label variable female "Female"
label variable firstdivision "First Division "
label variable ln_majherf "ln Specialization"
label variable cfinance "Finance "
label variable cindustries "Industries "
label variable chome "Home "
label variable cpersonnel "Personnel "
label variable ccommerce "Commerce "
label variable promotehat "P(Promotion to Centre)"

/* This variable is a multinomial which takes on the values representing the 
   major in which the IAS officer has been placed after their first promotion 
   to New Delhi. */
g centremajor = promote == 1 & _t != . & recruitment == 1
replace centremajor = 2 if centremaj == "Personnel & General Admn":nmaj_exp & ///
	promote == 1 & _t != . & recruitment == 1
replace centremajor = 3 if centremaj == "Commerce":nmaj_exp & ///
	promote == 1 & _t != . & recruitment == 1
replace centremajor = 4 if centremaj == "Finance":nmaj_exp & ///
	promote == 1 & _t != . & recruitment == 1
replace centremajor = 5 if centremaj == "Industries":nmaj_exp & ///
	promote == 1 & _t != . & recruitment == 1
replace centremajor = 6 if centremaj == "Home":nmaj_exp & ///
	promote == 1 & _t != . & recruitment == 1

/* This model estimates the likelihood that individuals who are posted to the 
   centre are subsequently allocated into positions that reflect their area of 
   expertise (or the area in which they have accumulated the most experience). */
eststo clear
eststo: quietly mlogit centremajor age nummoves female firstdivision  ln_majherf cpersonnel ccommerce cfinance cindustries chome promotehat if recruitment == 1 & promote == 1 & _t != ., cluster(cohort5)
esttab using "tables/centremajor.tex", label unstack compress se title(Multinomial Logistic Regression Predicting Major Position at Posting to Centre\label{centremajor}) nogaps nomtitles nodepvars addnotes("Standard errors for all models are clustered at the cadre level.") longtable replace not drop(age nummoves female firstdivision ln_majherf cfinance cindustries chome cpersonnel ccommerce promotehat _cons) scalars(ll)

/* Generate jscymatch2 which is true if there is a match between the position 
   the officer was placed into after becoming Joint Secretary and the major in 
   which he/she has accumulated the most experience after posting to New Delhi. */
tab jscymaj if jscypromote == 1, sort
g jscymatch2 = jscypromote == 1 & jscymatch == 1

/* This variable is a multinomial which takes on the values:
   2 = if they were promoted into a finance position
   3 = if they were promoted into an industries position
   4 = if they were promoted into a home position
   5 = if they were promoted into a personnel / general admin position
   1 = reference category that includes all postings excluding the previous 4. */
g jscymajor = jscypromote == 1
replace jscymajor = 2 if jscymaj == "Finance":nmaj_exp & jscypromote == 1
replace jscymajor = 3 if jscymaj == "Industries":nmaj_exp & jscypromote == 1
replace jscymajor = 4 if jscymaj == "Home":nmaj_exp & jscypromote == 1
replace jscymajor = 5 if jscymaj == "Personnel & General Admn":nmaj_exp & ///
	jscypromote == 1

/* Create five dummy variables indicating whether the officer has most of their 
   post-New Delhi promotion experience in finance, industries, home or 
   personnel. */ 
g finance = majmaxlabpost == "Finance":nmaj_exp
g industries = majmaxlabpost == "Industries":nmaj_exp
g home = majmaxlabpost == "Home":nmaj_exp
g personnel = majmaxlabpost == "Personnel & General Admn":nmaj_exp

/* This model estimates the likelihood that individuals who are made joint 
   secretary are subsequently allocated into positions that reflect their area 
   of expertise (or the area in which they have accumulated the most 
   experience). */

/* Generate a predicted probability of promotion to Joint secretary, for 
   inclusion as an independent variable in the second stage. */
quietly logit jscypromote nummoves nummoves2 age age2 female hindi bengali telugu marathi tamil firstdivision engineering-science business law numsubs degreen2-degreen4 ln_majherf promotehat i.cohort5 i.cadre i.cyear _tjscy if recruitment == 1, cluster(id)
predict jscypromotep
gen jscypromotehat = jscypromotep if jscypromote == 1
by id: replace jscypromotehat = sum(jscypromotehat)
by id: replace jscypromotehat = jscypromotehat[_N]
notes jscypromotehat: Predicted probability of promotion
notes jscypromotehat: X = nummoves(2) age(2) degrees peng sseng numsubs firstdiv numdegrees sex lang firstherf postherf cohort cadre
drop jscypromotep
label variable jscypromotehat "P(Empanelment) "

/* This model estimates the multinomial logistic regression that predicts 
   allocation into the major upon promotion to joint secretary */
eststo clear
eststo: quietly mlogit jscymajor age nummoves female firstdivision  ln_majherf finance industries home personnel jscypromotehat if recruitment == 1 & jscypromote == 1, cluster(cadre)
esttab using "tables/jscymajor.tex", label unstack compress se title(Multinomial Logistic Regression Predicting Major Position Upon Promotion to Joint Secretary \label{jscymajor}) nogaps nomtitles nodepvars addnotes("Standard errors for all models are clustered at the cadre level.") longtable replace not drop(age nummoves female firstdivision ln_majherf finance industries home personnel jscypromotehat _cons) scalars(ll)
