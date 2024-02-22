* IAS_DTA_BUILDING1.DO
* Author: John-Paul Ferguson
* Created: 18 Oct 2010
* Last modified: 16 July 2015
*
* This script looks for iast4.dta in the data directory and writes
* ias_17jan2011.dta and iast4_overlaps.dta into the same directory. 
	clear
	set seed 1234567
	use ../data/iast4.dta
* Designation and postoffice do us little good and they're large strings,
* so we'll drop them. We'll then encode level and major experience.
	drop postoffice designation
	encode level, g(nlevel)
		move nlevel level
		drop level
		rename nlevel level
	encode maj_exp, g(nmaj_exp)
		move nmaj_exp maj_exp
		drop maj_exp
		rename nmaj_exp maj_exp
* Obvious error in one of the start dates
	replace poststart = d(01may1996) if poststart == d(01may1906)
* There are several dozen records with obvious typos that show up as 
* postings with negative duration. It was a small enough number that I 
* decided to fix them by hand.
	g duration = postend-poststart
	replace postend = d(01aug1998) if id=="01TN027711" & poststart==d(01may1998) & postend==d(01aug1988) & duration==-3560
	replace postend = d(30dec1998) if id=="01UT016800" & poststart==d(30nov1998) & postend==d(30dec1989) & duration==-3257
	replace postend = d(30nov1998) if id=="01UT016800" & poststart==d(01aug1997) & postend==d(30nov1988) & duration==-3166
	drop if id=="01SK003200" & poststart==d(01nov1996) & postend==d(01sep1994) & duration==-792
	replace postend = d(31dec1999) if id=="01TN019900" & poststart==d(01sep1999) & postend==d(31dec1997) & duration==-609
	replace poststart = d(31dec1999) if id=="01TN019900" & poststart==d(31dec1997) & postend==d(24may2000) & duration==875
	replace postend = d(31oct2000) if id=="01CG035000" & poststart==d(01jun2000) & postend==d(31oct1998) & duration==-579
	replace postend = d(15nov2002) if id=="01KN027322" & poststart==d(06jun2002) & postend==d(15nov2000) & duration==-568
	replace postend = d(01feb2002) if id=="01PB021500" & poststart==d(01jan2002) & postend==d(01feb2001) & duration==-334
	drop if id=="01KN029800" & poststart==d(05sep1997) & postend==d(24nov1996) & duration==-285
	replace postend = d(11apr2003) if id=="01KN029915" & poststart==d(01jan2003) & postend==d(11apr2002) & duration==-265
	replace postend = d(01dec1979) if id=="01MP029001" & poststart==d(01sep1979) & postend==d(01jan1979) & duration==-243
	replace postend = d(04jan2004) if id=="01MP045600" & poststart==d(04sep2003) & postend==d(04jan2003) & duration==-243
	drop if id=="01GJ027700" & poststart==d(01nov2001) & postend==d(12mar2001) & duration==-234
	replace poststart = d(01jul1997) if id=="01UP033604" & poststart==d(01jul1998) & postend==d(01dec1997) & duration==-212
	replace postend = d(01dec1995) if id=="01GJ020700" & poststart==d(01aug1995) & postend==d(01feb1995) & duration==-181
	replace postend = d(01dec1993) if id=="01RJ027500" & poststart==d(01aug1993) & postend==d(01feb1993) & duration==-181
	replace poststart = d(12aug1998) if id=="01MH034101" & poststart==d(12aug1999) & postend==d(14feb1999) & duration==-179
	replace postend = d(11aug1998) if id=="01MH034101" & poststart==d(01sep1997) & postend==d(11aug1999) & duration==709
	replace postend = d(13dec2000) if id=="01TN019800" & poststart==d(10aug2000) & postend==d(13feb2000) & duration==-179
	replace postend = d(01jan2003) if id=="01KL020715" & poststart==d(07jun2002) & postend==d(01jan2002) & duration==-157
	drop if id=="01NL004712" & poststart==d(01jun1998) & postend==d(01jan1998) & duration==-151
	drop if id=="01PB020000" & poststart==d(01jun1997) & postend==d(01jan1997) & duration==-151
	drop if id=="01PB020100" & poststart==d(01jun1997) & postend==d(01jan1997) & duration==-151
	drop if id=="01PB020300" & poststart==d(01jun1997) & postend==d(01jan1997) & duration==-151
	replace poststart = d(03sep1998) if id=="01UP064000" & poststart==d(03sep1999) & postend==d(09apr1999) & duration==-147
	replace postend = d(03sep1998) if id=="01UP064000" & poststart==d(01aug1997) & postend==d(03sep1999) & duration==763
	replace poststart = d(03sep1998) if id=="01UP063900" & poststart==d(03sep1999) & postend==d(26apr1999) & duration==-130
	replace postend = d(03sep1998) if id=="01UP063900" & poststart==d(06may1998) & postend==d(03sep1999) & duration==485
	replace postend = d(01jan1990) if id=="01BH033900" & poststart==d(08jun1989) & postend==d(31jan1989) & duration==-128
	replace poststart = d(01may1998) if id=="01KN030200" & poststart==d(01may2000) & postend==d(01jan2000) & duration==-121
	drop if id=="01HY016500" & poststart==d(24sep2001) & postend==d(20jun2001) & duration==-96
	replace postend = d(01jun1998) if id=="01PB021600" & poststart==d(01sep1997) & postend==d(01jun1997) & duration==-92
	replace postend = d(15oct2001) if id=="01PB019811" & poststart==d(01jan2001) & postend==d(15oct2000) & duration==-78
	replace postend = d(01feb2001) if id=="01PB020700" & poststart==d(08jan2001) & postend==d(01nov2000) & duration==-68
	replace poststart = d(01sep1997) if id=="01WB037100" & poststart==d(01sep1998) & postend==d(25jun1998) & duration==-68
	replace postend = d(01sep1997) if id=="01WB037100" & poststart==d(01apr1997) & postend==d(01sep1998) & duration==518
	replace postend = d(01jun1988) if id=="01CG034400" & poststart==d(01apr1988) & postend==d(01feb1988) & duration==-60
	replace postend = d(01jul2001) if id=="01OR024714" & poststart==d(12jan2000) & postend==d(29nov1999) & duration==-44
	drop if id=="01AP032900" & poststart==d(01nov1999) & postend==d(20sep1999) & duration==-42
	replace poststart = d(01jan2000) if id=="01UP063311" & poststart==d(08apr2000) & postend==d(29feb2000) & duration==-39
	drop if id=="01KL020716" & poststart==d(05aug2000) & postend==d(01jul2000) & duration==-35
	drop if id=="01PB017200" & poststart==d(01jul2000) & postend==d(27may2000) & duration==-35
	drop if id=="01AP032728" & poststart==d(01aug1996) & postend==d(01jul1996) & duration==-31
	replace poststart = d(08feb2000) if id=="01WB024400" & poststart==d(08sep2000) & postend==d(13aug2000) & duration==-26
	drop if id=="01CG039200" & poststart==d(30aug2002) & postend==d(06aug2002) & duration==-24
	drop if id=="01UP062402" & poststart==d(13aug2002) & postend==d(01aug2002) & duration==-12
	drop if id=="01KL020624" & poststart==d(07jul2002) & postend==d(27jun2002) & duration==-10
	drop if id=="01TN032400" & poststart==d(08mar2003) & postend==d(02mar2003) & duration==-6
	replace postend = d(25aug1997) if id=="01KN027700" & poststart==d(01jun1997) & postend==d(28may1997) & duration==-4
	replace poststart = d(26aug1998) if id=="01KN021200" & poststart==d(29nov2002) & postend==d(26nov2002) & duration==-3
	drop if id=="01KN030412" & poststart==d(14apr2000) & postend==d(12apr2000) & duration==-2
	drop if id=="01AM019600" & poststart==d(13dec2000) & postend==d(12dec2000) & duration==-1
* There are still a number of records that have missing start and/or end
* dates. If they're missing BOTH start and end, I drop them; we can get
* no information from them. Most of the missing end dates are for the
* last observation in someone's record, and so that should obviously be
* 31dec2008. Again, with the missing start dates, there are few enough
* that I fixed them by hand. Most of the missing starts I just began
* when the posting before them ended. Some of them are one-observation
* records, in which case we have to drop them because we have no 
* reference.
	sort id poststart postend, stable
	by id: g one = _n == 1
	by id: g enn = _n == _N
	replace postend = d(31dec2008) if postend > d(31dec2008) & !mi(postend)
	replace postend = d(31dec2008) if mi(postend) & enn
	replace poststart = d(11dec2008) if id=="01AP024300" & mi(poststart)
	replace poststart = d(26jun2008) if id=="01GJ029520" & mi(poststart)
	replace poststart = d(19nov2008) if id=="01JH033100" & mi(poststart)
	drop if id=="01JH805002" & mi(poststart)
	drop if id=="01JH805003" & mi(poststart)
	drop if id=="01JH805004" & mi(poststart)
	drop if id=="01JH805005" & mi(poststart)
	drop if id=="01JH805006" & mi(poststart)
	drop if id=="01JH805007" & mi(poststart)
	replace poststart = d(27dec2008) if id=="01KL009900" & mi(poststart)
	replace poststart = d(24dec2008) if id=="01KL016601" & mi(poststart)
	drop if id=="01KL807001" & mi(poststart)
	replace poststart = d(05dec2008) if id=="01KN022600" & mi(poststart)
	replace poststart = d(22nov2008) if id=="01MH043900" & mi(poststart)
	drop if id=="01MH908001" & mi(poststart)
	drop if id=="01MP026000"
	replace poststart = d(30dec2008) if id=="01MT007800" & mi(poststart)
	replace poststart = d(18jul2008) if id=="01PB019700" & mi(poststart)
	replace poststart = d(31dec2008) if id=="01RJ020100" & mi(poststart)
	replace poststart = d(24dec2008) if id=="01TN028900" & mi(poststart)
	replace poststart = d(24dec2008) if id=="01UP055900" & mi(poststart)
	replace poststart = d(18jul2008) if id=="01UT012900" & mi(poststart)
	replace poststart = d(01dec2008) if id=="01UT014500" & mi(poststart)
	replace poststart = d(25dec2008) if id=="01WB028300" & mi(poststart)
	replace poststart = d(24jun2008) if id=="01WB036300" & mi(poststart)
* Some of the listed postings are future ones, starting after 31dec2008;
* I drop these. I also remove any postings of zero days; I'll do this
* again after further modifications.
	sort id poststart postend, stable
	drop duration-enn
	drop if poststart > d(31dec2008)
	drop if mi(postend) & poststart==poststart[_n-1] & id==id[_n-1]
	drop if mi(postend) & postend[_n-1]==d(31dec2008) & id==id[_n-1]
	by id: g enn = _n == _N
	replace postend = d(31dec2008) if mi(postend) & enn
	replace postend = poststart[_n+1]-1 if mi(postend)
	drop if postend == poststart
* At this point I encoded the IDs, to make the file smaller.
	encode id, g(nid)
		move nid id
		drop id
		rename nid id
* Away go the position ID, which isn't very useful (and often steers
* us wrong, it's better to go with the position start date) and the
* minor experience field.
	drop pos_id min_exp enn
* This block of code deals with the fact that many of the records list
* the same ID, same level, same organization, and same start and end
* dates, just with a different major experience. I agonized for a while
* over throwing away this type of information, since it's related to the
* thing that we're analyzing these data for. I finally decided to record
* extra experiences (if any) in a series of extra "exp" variables. This
* therefore collapses all of those otherwise-duplicate records into a
* single record listing any and all experiences. This also makes it much
* easier to eliminate some of the date conflicts later on.
	g stable = id!=id[_n-1] | ///
		level!=level[_n-1]  | ///
		organization!=organization[_n-1] | ///
		maj_exp!=maj_exp[_n-1]
	g stablesum = sum(stable)
	sort stablesum poststart postend, stable
	by stablesum: replace postend = postend[_N]
	by stablesum: keep if _n==1
	drop stable stablesum
	sort id poststart postend, stable
	by id: g one = _n == 1 
	clonevar exp2 = maj_exp
	replace exp2 = .
	clonevar exp3 = exp2
	clonevar exp4 = exp2
	clonevar exp5 = exp2
	clonevar exp6 = exp2
	clonevar exp7 = exp2
	clonevar exp8 = exp2
	clonevar exp9 = exp2
	g tochange = id==id[_n+1] & ///
		level==level[_n+1] & ///
		organization==organization[_n+1] & ///
		poststart==poststart[_n+1] & ///
		postend==postend[_n+1]
	replace exp2 = maj_exp[_n+1] if tochange
	replace exp3 = exp2[_n+1] if !mi(exp2) & !mi(exp2[_n+1])
	replace exp4 = exp3[_n+1] if !mi(exp3) & !mi(exp3[_n+1])
	replace exp5 = exp4[_n+1] if !mi(exp4) & !mi(exp4[_n+1])
	replace exp6 = exp5[_n+1] if !mi(exp5) & !mi(exp5[_n+1])
	replace exp7 = exp6[_n+1] if !mi(exp6) & !mi(exp6[_n+1])
	replace exp8 = exp7[_n+1] if !mi(exp7) & !mi(exp7[_n+1])
	replace exp9 = exp8[_n+1] if !mi(exp8) & !mi(exp8[_n+1])
	drop if tochange[_n-1] == 1 & tochange == 0
	drop if tochange == 1 & tochange[_n-1] == 1
	drop tochange
* Next we have postings where the person said, e.g., that she started
* on 1jan1999 with Mines as her major experience and served through
* 31dec1999, AND that she started on 1jun1999 with Agriculture as her 
* major experience and served through 31dec1999. In these cases I think
* that we care about how the person listed an additional experience
* partway through the posting. I therefore create two records. In the
* example above, the first record with Mines would run from 1jan1999 to
* 31may1999 and the second with Agriculture would run from 1jun1999 to
* 31dec1999.
	g sameend = id==id[_n+1] & ///
		level==level[_n+1] & ///
		organization==organization[_n+1] & ///
		postend==postend[_n+1]
	g samestart = id==id[_n+1] & ///
		level==level[_n+1] & ///
		organization==organization[_n+1] & ///
		poststart==poststart[_n+1]
	g sameendsafe = sameend & ///
		!sameend[_n-1] & ///
		!sameend[_n+1] & ///
		!samestart & ///
		!samestart[_n-1] & ///
		!samestart[_n+1]
	replace postend = poststart[_n+1]-1 if sameendsafe
	drop sameend samestart sameendsafe
* There is a symmetric process for posts with the same start but other
* end dates.
	g sameend = id==id[_n+1] & ///
		level==level[_n+1] & ///
		organization==organization[_n+1] & ///
		postend==postend[_n+1]
	g samestart = id==id[_n+1] & ///
		level==level[_n+1] & ///
		organization==organization[_n+1] & ///
		poststart==poststart[_n+1]
	g samestartsafe = samestart & ///
		!samestart[_n-1] & ///
		!samestart[_n+1] & ///
		!sameend & ///
		!sameend[_n-1] & ///
		!sameend[_n+1]
	replace poststart = postend[_n-1]+1 if samestartsafe[_n-1]==1
	drop sameend samestart samestartsafe
* Some of the conflicting records have no experience listed at all. In
* this case the posting screws up our data and provides no information
* at all, so I delete them.
	g overlap = id==id[_n-1] & poststart<postend[_n-1]
	drop if overlap & maj_exp==24
	drop overlap
* At this point I had cleaned up most of the individuals' records, using
* methods that I think do almost no damage to the integrity of the data.
* I wanted to write these out; we could add an identifier if we wanted
* to. I'll merge the file that's produced later; for now, I save the
* records with no overlaps to file and work with the remainder.
	by id: g overlap = id==id[_n-1] & poststart<postend[_n-1]
	by id: g overlaps = sum(overlap)
	by id: replace overlaps = overlaps[_N]
	preserve
	keep if overlaps==0
	save ../data/iast4_clean1,replace
	restore
	drop if overlaps==0
* I drop a handful of records that are duplicates save for the
* organization; all of these have a second organization that's just a
* different way of saying "cadre," which is what the retained record
* says.
	drop if id==id[_n+1] & postend==postend[_n+1] & ///
		poststart==poststart[_n+1] & level==level[_n+1]
* Next I deal with those records that appear duplicates save for the 
* level (pay grade) changing. In these cases, I assume that the level
* changed halfway through the posting. This is arbitrary but preserves
* the fact that there was some change in status during that period.
	g stable = id!=id[_n-1] | postend!=postend[_n-1] | poststart!=poststart[_n-1]
	g tochange = stable==0 & stable[_n-1]==1 & stable[_n+1]==1
	replace poststart = poststart+int((postend-poststart)/2) if tochange==1
	replace postend = poststart[_n+1]-1 if tochange[_n+1]==1
	drop stable tochange overlap overlaps
* Next there are many clusters of records with the same end but differing
* start dates. These are the same as the "sameend" records above save
* that here there are clusters of more than two such records in a row.
* Here I end the prior record's posting right before the latter record's
* posting starts, thus changing the major experience whenever the record
* reports a new one.	
	g tochange = id==id[_n+1] & postend==postend[_n+1] & poststart<poststart[_n+1]
	replace postend=poststart[_n+1]-1 if tochange
	drop tochange
* Now some bookkeeping, caused by resolving some of these conflicts...	
	drop if id==id[_n-1] & postend==postend[_n-1]
	g duration = postend-poststart
	drop if duration == 0
	drop duration
* This resolves several records that have the same start dates but 
* different end dates; here I keep whichever end date is earlier, so as
* to reduce conflicts with subsequent records.	
	g tochange = id==id[_n-1] & poststart==poststart[_n-1]
	replace postend = cond(postend<postend[_n-1],postend,postend[_n-1],.) ///
		if tochange==1
	drop if tochange[_n+1]==1
	drop tochange
* Closing in on some "pure" overlaps. Here I remove any records that
* overlap an otherwise contiguous period covered by two other records.	
	by id: g overlap = id==id[_n-1] & poststart<postend[_n-1]
	drop if overlap==1 & ///
		overlap[_n-1]==0 & ///
		overlap[_n+1]==0 & ///
		(poststart[_n+1]-postend[_n-1]==0 | poststart[_n+1]-postend[_n-1]==1)
	sort id poststart postend, stable
	drop if id==id[_n-1]&poststart==poststart[_n-1]&postend==postend[_n-1]
	drop overlap
* Another such bunch.
	g overlap = id==id[_n-1] & poststart<postend[_n-1]
	drop if overlap == 1 & overlap[_n-1]==0 & overlap[_n+1]==1 & (poststart[_n+1]-postend[_n-1]==0 | poststart[_n+1]-postend[_n-1]==1)
	drop overlap
* There are a handful of records, comprising about 20 individuals, where
* there are so many overlapping entries that resolving them involves
* more or less inventing a career history for them. These I drop, and
* thus restrict any future work to records with four or fewer total date
* conflicts.	
	g overlap = id==id[_n-1] & poststart<postend[_n-1]
	by id: g overlaps = sum(overlap)
	by id: replace overlaps = overlaps[_N]
	drop if overlaps > 4
* Another group of "single" overlaps that conflict with two nearly
* contiguous records. I remove the record that can't be reconciled and
* stitch the other two together.	
	g overlap1 = overlap==1 & overlaps==1 & poststart[_n+1]-postend[_n-1]>=0
	replace poststart=postend[_n-1] if overlap1==1
	replace postend=poststart[_n+1] if overlap1==1
	drop if postend-poststart==0
	drop overlap overlaps overlap1
* At this point most of the records have been resolved. I write out the
* records that have been fixed since the last write-out, giving us
* more than 4,200 of the original 4,600 persons. The 300 or so case
* records that remain I think we could resolve by hand later, but we
* have more than enough to work with here.

* This last bit also writes the unresolved records to their own file,
* joins together the two cleaned files I created, and removes the
* cleaned sub-files.	
	g overlap = id==id[_n-1] & poststart<postend[_n-1]
	by id: g overlaps = sum(overlap)
	by id: replace overlaps = overlaps[_N]
	preserve
	keep if overlaps==0
	save ../data/iast4_clean2,replace
	restore
	drop if overlaps==0
	drop overlap overlaps
	move maj_exp one
	ren maj_exp exp1
	compress
	save iast4_overlaps,replace
	use iast4_clean1
	append using iast4_clean2
	drop overlap overlaps
	move maj_exp one
	ren maj_exp exp1
	compress
	erase ../data/iast4_clean1.dta
	erase ../data/iast4_clean2.dta
* I have then added in the code that was originally in stsetting_iast4.do,
* which in turn called ias1_tomerge.do and ias3_tomerge.do.  Now they're all
* in this one file so that we can make sense of the data directory.  This  is
* the file that our analysis file calls.
        recode organization (3=1) (4=2) (5=1) (6=1) (7/8=1) (9=2) (10=1) ///
			(11/12=2) (13/14=1) (15/17=2) (18=1) (19=2) (20=1) (21=2) ///
			(23/27=22) (28=1) (29=2)
        sort id poststart, stable
        drop one exp2-exp9
        g monthstart = mofd(poststart)
        format monthstart %tm
        g monthend = mofd(postend)
        format monthend %tm
        g duration = monthend-monthstart
        drop if duration == 0
        generate enn = _n
        decode id, g(str_id)
        sort str_id poststart, stable
        ren id num_id
        ren str_id id
           preserve
           use ../data/ias3.dta
           drop degree institution subject4
           encode subject1, g(sub)
           encode subject2, g(sub2) l(sub)
           encode subject3, g(sub3) l(sub)
           drop subject1-subject3
           g degreeorder = 1
           replace degreeorder = 2 if degreetypes == "Undergraduate":degreetypes
           replace degreeorder = 3 if degreetypes == "UGMedical":degreetypes
           replace degreeorder = 4 if degreetypes == "Diploma":degreetypes
           replace degreeorder = 5 if degreetypes == "Certification":degreetypes
           replace degreeorder = 6 if degreetypes == "Graduate":degreetypes
           replace degreeorder = 7 if degreetypes == "GRMedical":degreetypes
           replace degreeorder = 8 if degreetypes == "Doctorate":degreetypes
           replace degreeorder = 9 if degreetypes == "PostDoc":degreetypes
           replace degreeorder = 10 if degreetypes == "NA":degreetypes
           sort id degreeorder
           g hasDoctorate = degreetypes == "Doctorate":degreetypes
           g hasGraduate = degreetypes == "Graduate":degreetypes
           by id: replace hasDoctorate = sum(hasDoctorate)
           by id: replace hasDoctorate = hasDoctorate[_N]
           replace hasDoctorate = 1 if hasDoctorate > 0
           by id: replace hasGraduate = sum(hasGraduate)
           by id: replace hasGraduate = hasGraduate[_N]
           replace hasGraduate = 1 if hasGraduate > 0
           by id: g enn = _n
           drop if enn > 4
           drop ed_id degreeorder
           rename sub suba
           rename sub2 subb
           rename sub3 subc
           reshape wide division degreetypes suba subb subc, i(id) j(enn)
           sort id
           save ../data/ias3_tomerge, replace
           restore
        merge id using ../data/ias3_tomerge
        drop if _merge == 2
        sort id poststart, stable
           preserve
           use ../data/iast1
           drop name
           sort id
           save ../data/ias1_tomerge, replace
           restore
        merge m:1 id using ../data/ias1_tomerge, generate(_merge2)
        drop if _merge2==2
        drop _merge _merge2 id
        rename num_id id
        expand duration
        sort id enn
        by id enn: generate period = monthstart + _n
        format period %tm
        by id: generate notincenter = organization == 2 & organization[_n-1] == 2
        replace notincenter = abs(notincenter-1)
        sort id enn poststart, stable
        by id: generate origin = monthstart[1]
        format origin %tm
        stset period, id(id) failure(organization==2) origin(origin) if(notincenter)

save ../data/temp_1.dta, replace

/* Generate dominant language dummies */
quietly tabulate language, generate(lang)
drop lang1 lang2 lang4-lang7 lang9-lang15 lang17-lang21 lang23-lang24 lang27-lang30
rename lang3 bengali
rename  lang8 hindi
rename  lang16 marathi
rename lang22 punjabi
rename  lang25 tamil
rename  lang26 telugu

/*Generate age */
g age = (poststart - birthdate) / 365.25 
g age2 = age^2

/* Create variable for whether the individual graduated in the first division 
   (or higher) of their education */
g byte firstdivision = 1 if ///
	((division1 == 1) | (division1 == 5) | (division1 == 7) )
replace firstdivision = 0 if  firstdivision == .

/* Generate five-year cohorts */
gen int cohort5 = cond(allotYear<1975,1, ///
    cond(allotYear<1980,2, ///
    cond(allotYear<1985,3, ///
    cond(allotYear<1990,4, ///
    cond(allotYear<1995,5, ///
    cond(allotYear<2000,6, ///
    cond(allotYear<2005,7,8,.),.),.),.),.),.),.)
label define cohort5 1 "<1975" 2 "1975-1979" 3 "1980-1984" 4 "1985-1989" ///
	5 "1990-1994" 6 "1995-1999" 7 "2000-2004" 8 "2005-2008"
label values cohort5 cohort5
label variable cohort5 "Five-year cohort"

/* Generate some reduced-form subject columns. This calls code that used to be
   saved in reducing_ias_subjects.do. */
   preserve
   use ../data/temp_1, clear
   by id: keep if _n == 1
   /* Create a reduced form subject column */
   foreach var of varlist suba1-subc1 suba2-subc2 suba3-subc3 suba4-subc4 {
     clonevar `var'_r = `var'
   }
   recode suba1_r-subc4_r (7 9 26 35 45 57 61 66 95 105 106 107 108 113 114 ///
	131 132 136 163 169 170 171 208 212 214 216 221 222 228 235 242 250 265 ///
	274 276 277 290 317 319 325 326 328 329 339 353 362 364 = 1) ///
	(17 18 28 31 32 39 59 115 116 117 121 137 138 144 149 150 151 158 162 ///
	206 217 229 249 252 300 301 304 315 321 327 330 336 343 344 348 371 373 ///
	374 375 376 378 = 2) ///
	(14 87 147 148 152 218 219 238 239 241 244 245 246 257 258 284 291 318 ///
	361 = 3) ///
	(3 5 6 30 34 60 70 77 84 85 88 89 90 94 96 97 98 104 109 111 112 123 124 ///
	125 126 133 145 146 153 155 161 173 175 177 178 179 180 181 182 183 184 ///
	187 188 190 191 193 194 196 200 203 205 211 223 226 233 234 236 240 259 ///
	260 266 273 281 282 283 285 286 287 288 289 292 294 295 296 297 298 303 ///
	305 306 307 308 310 312 320 323 324 331 333 334 335 337 340 341 342 349 ///
	351 357 365 367 368 369 372 = 4) ///
	(12 15 16 19 20 24 25 27 33 36 40 41 42 43 44 56 58 62 63 71 72 73 74 75 ///
	82 83 100 101 118 120 127 130 134 135 140 142 143 154 159 160 207 215 ///
	225 237 243 251 253 255 256 261 262 263 264 302 314 316 338 345 346 354 ///
	360 366 = 5) ///
	(8 10 11 21 22 23 29 37 38 67 81 86 91 92 93 102 103 141 164 165 174 176 ///
	199 201 224 230 232 267 268 269 270 271 272 280 299 309 311 313 355 = 6) ///
	(1 2 46 47 48 49 50 51 52 53 55 64 69 78 79 80 122 128 129 156 157 166 ///
	167 168 186 189 202 204 209 210 248 275 278 279 332 347 350 356 = 7) ///
	(4 65 68 76 119 172 185 192 197 198 220 247 352 = 8)
   label define sub_r 1 "Engineering" 2 "Humanities" 3 "Medicine" ///
	4 "Professional" 5 "Science" 6 "Social Science" 7 "Business" 8 "Law"
   foreach var of varlist suba1_r-subc4_r {
     label values `var' sub_r
   }
   keep id suba1_r-subc4_r
   save ../data/reducing_ias_subjects, replace
   restore
merge id using ../data/reducing_ias_subjects
drop _merge
erase ../data/reducing_ias_subjects.dta
compress

/* Generate a dependent variable for logits */
generate int promote = organization==2 & notincenter==1
notes promote: Equals 1 iff the person is promoted and hasn't been promoted before

/* Compare these. Some differences in the cohort coefficients but
   otherwise virtually identical, and logit runs a hell of a lot
   faster.
	logit promote female i.cadre firstdivision hasGraduate hasDoctorate ///
         hindi punjabi tamil i.cohort5 _t if recruitment == 1, ///
         cluster(allotYear)
	streg female i.cadre firstdivision hasGraduate hasDoctorate hindi ///
         punjabi tamil i.cohort5 if recruitment == 1, cluster(allotYear) ///
         distribution(exponential)
   So we can basically just go with the logits for discrete-time analyses. */

/* Generate dummies for different educational majors */
egen byte engineering = anymatch(suba1_r-subc4_r), values(1)
egen byte humanities = anymatch(suba1_r-subc4_r), values(2)
egen byte medicine = anymatch(suba1_r-subc4_r), values(3)
egen byte professional = anymatch(suba1_r-subc4_r), values(4)
egen byte science = anymatch(suba1_r-subc4_r), values(5)
egen byte socialscience = anymatch(suba1_r-subc4_r), values(6)
egen byte business = anymatch(suba1_r-subc4_r), values(7)
egen byte law = anymatch(suba1_r-subc4_r), values(8)

/* Generate number of degrees obtained, as well as number of subjects enrolled
   in across all degrees. Similarly, generate the number of moves across
   experiences, as well as its square. */
gen int numdegrees = cond(mi(suba2_r),1, ///
	cond(mi(suba3_r),2,cond(mi(suba4_r),3,4,.),.),.)
egen int numsubs =rsum(engineering-law)
notes numsubs: Total number of subjects majored in across ALL degrees 
* gen byte peng = professional * engineering
* notes peng: professional X engineering
* gen byte sseng = socialscience * engineering
* notes sseng: socialscience X engineering
gen int nummoves = 0
sort id period
by id: replace nummoves = cond(_n==1,nummoves, ///
	cond(exp1==exp1[_n-1],nummoves,nummoves+1,.),.)
by id: replace nummoves = sum(nummoves)
notes nummoves: Total number of switches across EXPERIENCE over the career (Ignores level changes)
gen int nummoves2=nummoves^2

/* Generate our independent variable of interest: the log of the Herfindahl of
   their experiences. */
quietly tabulate exp1, g(major)
foreach var of varlist major1-major40 {
	by id: g lg`var' = (1+sum(`var'))
	}
egen int lmajtotal=rsum(lgmajor1-lgmajor40)
notes lmajtotal: Running count of different types of experience
foreach var of varlist lgmajor1-lgmajor40 {
	replace `var'=`var'/lmajtotal
	replace `var'=`var'^2
	}
egen majherf=rowtotal(lgmajor1-lgmajor40)
notes majherf: Running HHI of diversity of experience over career
g ln_majherf = log(majherf+.01)

/* This code creates a variable that indicates the major in which the person 
   specialized */
gen majmaxp = lgmajor1
notes majmaxp: Size of largest experience share in the HHI
gen majmaxlabp = 1
notes majmaxlabp: Type of experience with the largest share
local i = 1
while `i' <= 40 {
	replace majmaxlabp = `i' if lgmajor`i' > majmaxp
	replace majmaxp= lgmajor`i' if lgmajor`i' > majmaxp
	local i = `i' + 1
}
label values majmaxlabp nmaj_exp

/* Generate calendar year in order to include year fixed effects */
generate cyear = int(1960+(period/12))

/* Generate a predicted probability of promotion, for inclusion as an
   independent variable in the second stage. */
quietly logit promote nummoves nummoves2 age age2 ///
	engineering-science business law numsubs firstdivision i.numdegrees ///
	female hindi bengali marathi tamil telugu ///
	ln_majherf i.cohort5 i.cadre i.cyear _t if recruitment == 1, cluster(id)
predict promotep
gen promotehat = promotep if promote == 1
by id: replace promotehat = sum(promotehat)
by id: replace promotehat = promotehat[_N]
notes promotehat: Predicted probability of promotion
notes promotehat: X = nummoves(2) age(2) degrees peng sseng numsubs firstdiv numdegrees sex lang majherf cohort cadre
drop promotep

/* Generate time variable that counts from entry into data set */
by id: gen int tbegin = _n
replace tbegin = . if notincenter == 0 & promote == 0
notes tbegin: _t with correction for missing months

/* create multiple promotions variable */
by id: gen int numpromote = sum(promote)
replace numpromote = numpromote*promote
notes numpromote: Indicates count of promotion (first, second etc.)

/* I'm now going to clean up the dataset somewhat. */
compress
drop duration suba1-subc1 suba2-subc2 suba3-subc3 suba4-subc4 ///
	enn _t0 _st _d _origin lgmajor1-lgmajor40 

/* Below we calculate variables that track the running total of promotions as
   well as pulling out as its own variable the experience HHI at the time of
   promotion to Delhi, and flagging the observations that occur five, six,
   ten and fifteen years after promotion to Delhi. */
sort id period
by id: gen int cpromote = organization == 2 & exp1 != exp1[_n-1]
by id: gen int cpromotes = sum(cpromote)
by id: gen int promotes = sum(promote)
notes promotes: Running total of promotions to Delhi over career
drop cpromote cpromotes
by id: g firstpromote = promotes == 1 & promotes[_n-1]==0
notes firstpromote: Indicates first-ever promotion to Delhi
g firstherf = majherf*firstpromote
by id: replace firstherf = sum(firstherf)
notes firstherf: HHI of experience at the time of first promotion to Delhi
g ln_firstherf = log(firstherf+.01)
g periodfirstpromote = period * firstpromote
by id: replace periodfirstpromote = sum(periodfirstpromote)
by id: gen byte fiveyearflag = period == periodfirstpromote+60
by id: gen byte sixyearflag = period == periodfirstpromote+72
by id: gen byte tenyearflag = period == periodfirstpromote+120
by id: gen byte fteenyearflag = period == periodfirstpromote+180
drop periodfirstpromote

/* For the following, we want to generate an experience HHI for the period
   after the initial promotion to Delhi. This requires dropping the records
   before that promotion, though we may want them later for calulations. So
   I'm going to preserve the data, write out the calculated variables as a
   separate file and merge them back in. */ 
   preserve
   drop if promotes == 0
   foreach var of varlist major1-major40 {
   	by id: gen lg`var' = (1+sum(`var'))
   	}
   egen lmajtotalpost=rsum(lgmajor1-lgmajor40)
   foreach var of varlist lgmajor1-lgmajor40 {
   	replace `var'=`var'/lmajtotalpost
   	replace `var'=`var'^2
   	}
   egen postherf=rsum(lgmajor1-lgmajor40)
   notes postherf: Running HHI of post-first-promotion experience
   gen majmaxpost = lgmajor1
   gen int majmaxlabpost = 1
   notes majmaxlabpost: Major experience in post-promotion career
   local i = 1
   while `i' <= 40 {
   	replace majmaxlabpost = `i' if lgmajor`i' > majmaxpost
   	replace majmaxpost = lgmajor`i' if lgmajor`i' > majmaxpost
   	local i = `i' + 1
   	}
   label values majmaxlabpost nmaj_exp
   keep id period postherf majmaxlabpost
   sort id period
   save ../data/postherf.dta, replace
   restore
sort id period
merge id period using ../data/postherf.dta
drop _merge
g ln_postherf = log(postherf+.01)
erase ../data/postherf.dta

/* Create indicator variable for whether the person was promoted to the 
   joint secretary level */
sort id period
gen int jscy = level == "Joint Secy":nlevel & organization == 2
by id: replace jscy = sum(jscy)
replace jscy = 1 if jscy > 0 & !mi(jscy)
notes jscy: Equal to 1 for ALL periods after promotion to joint secretary

/* Create an indicator variable for the first transition to joint secretary */
gen int jscypromote = jscy[_n-1] == 0 & jscy[_n] == 1 
notes jscypromote: Indicates first-ever promotion to joint secretary

/* Create variable that indicates the major experience of the candidate 
   when promoted to Joint Secretary */
gen jscymaj = exp1 if jscypromote == 1
by id: replace jscymaj = sum(jscymaj)
label values jscymaj nmaj_exp
notes jscymaj: Major experience in the Joint Secretary job when first promoted

/* Does the major in which the officer has maximum experience match the 
   major of the first promotion to joint secretary? */
g jscymatch = jscy == 1 & majmaxlabpost == jscymaj
notes jscymatch: Indicates a match between the single greatest post-promotion experience and that of the js promotion

/* This creates the time variable for the joint-secretary event-history
   models */
by id: g _tjscy = _n
replace _tjscy = . if _t != .
replace _tjscy = . if jscy == 1 & jscypromote == 0

save ../data/working_ias, replace
erase ../data/temp_1.dta

