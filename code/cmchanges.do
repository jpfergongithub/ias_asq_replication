clear
set mem 200m
insheet using "../data/Chief_M_5oct2011.csv", c n
keep state tookoffice leftoffice party
replace state = trim(state)
generate cadre = 0
replace cadre = 1 if state == "Goa"
replace cadre = 25 if state == "Arunachal Pradesh"
replace cadre = 26 if state == "Mizoram"
replace cadre = 2 if state == "Andhra Pradesh"
replace cadre = 3 if state == "Assam"
replace cadre = 27 if state == "Meghalaya"
replace cadre = 4 if state == "Bihar"
replace cadre = 5 if state == "Chhattisgarh"
replace cadre = 6 if state == "Gujarat"
replace cadre = 7 if state == "Haryana"
replace cadre = 8 if state == "Himachal Pradesh"
replace cadre = 9 if state == "Jammu and Kashmir"
replace cadre = 10 if state == "Jharkhand"
replace cadre = 11 if state == "Karnataka"
replace cadre = 12 if state == "Kerala"
replace cadre = 13 if state == "Madhya Pradesh"
replace cadre = 14 if state == "Maharashtra"
replace cadre = 15 if state == "Manipur"
replace cadre = 28 if state == "Tripura"
replace cadre = 16 if state == "Nagaland"
replace cadre = 17 if state == "Orissa"
replace cadre = 18 if state == "Punjab"
replace cadre = 19 if state == "Rajasthan"
replace cadre = 20 if state == "Sikkim"
replace cadre = 21 if state == "Tamil Nadu"
replace cadre = 22 if state == "Uttar Pradesh"
replace cadre = 23 if state == "Uttarakhand"
replace cadre = 24 if state == "West Bengal"
encode party, generate(cmparty)
drop party
replace tookoffice = lower(subinstr(tookoffice,"-","",.))
generate period = mofd(cond(real(substr(tookoffice,-2,.)) > 12, ///
	date(tookoffice,"DM19Y"),date(tookoffice,"DM20Y")))
format period %tm
generate cmchange = 1
drop tookoffice leftoffice
sort cadre period
compress
save ../data/cmchanges.dta, replace
