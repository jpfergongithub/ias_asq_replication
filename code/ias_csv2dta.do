clear
insheet using ../canonical/parsed/iast1.csv, c n

split scay, parse("/")
drop scay1
label define cadre  1 "AGMUT" 2 "ANDHRA PRADESH" 3 "ASSAM MEGHALAYA" ///
                    4 "BIHAR" 5 "CHHATTISGARH" 6 "GUJARAT" 7 "HARYANA" ///
                    8 "HIMACHAL" 9 "JAMMU & KASHMIR" 10 "JHARKHAND" ///
                   11 "KARNATAKA" 12 "KERALA" 13 "MADHYA PRADESH" ///
                   14 "MAHARASHTRA" 15 "MANIPUR-TRIPURA" 16 "NAGALAND" ///
                   17 "ORISSA" 18 "PUNJAB" 19 "RAJASTHAN" 20 "SIKKIM" ///
                   21 "TAMIL NADU" 22 "UTTAR PRADESH" 23 "UTTARANCHAL" ///
                   24 "WEST BENGAL"
replace scay2 = "" if scay == "NULL"
encode scay2, generate(cadre) label(cadre)
move cadre scay
label var cadre "Regional Cadre"
drop scay2
replace scay3 = "" if scay3 == "NA"
destring scay3, replace
move scay3 scay
rename scay3 allotYear
drop scay
label var allotYear "Allotment Year"

label define recruitment 1 "RR" 2 "SCS" 3 "NON SCS" 4 "SELECTION" 5 "IC" 6 "SR"
replace recruitment = "" if recruitment == "NA" | recruitment == "NULL"
encode recruitment, generate(rc) label(recruitment)
move rc recruitment
drop recruitment
rename rc recruitment
label var recruitment "Source of Recruitment"

replace dob = "" if dob == "NULL"
generate birthdate = date(dob, "DMY")
format birthdate %td
move birthdate dob
drop dob
label var birthdate "Birth Date"

label define female 0 "MALE" 1 "FEMALE"
replace sex = "" if sex == "NULL"
encode sex, generate(female) label(female)
move female sex
drop sex
label var female "1 if female"

label define domicile  1 "A&N ISLAND" 2 "AGMUT" 3 "ANDHRA PRADESH" ///
                       4 "ARUNACHAL" 5 "ASSAM" 6 "BIHAR" 7 "CHANDIGARH" ///
                       8 "CHHATTISGARH" 9 "DELHI" 10 "GOA D & D" 11 "GUJARAT" ///
                      12 "HARYANA" 13 "HIMACHAL" 14 "JAMMU & KASHMIR" ///
                      15 "JHARKHAND" 16 "KARNATAKA" 17 "KERALA" ///
                      18 "MADHYA PRADESH" 19 "MAHARASHTRA" 20 "MANIPUR" ///
                      21 "MEGHALAYA" 22 "MIZORAM" 23 "NAGALAND" 24 "ORISSA" ///
                      25 "PONDICHERRY" 26 "PUNJAB" 27 "RAJASTHAN" 28 "SIKKIM" ///
                      29 "TAMIL NADU" 30 "TRIPURA" 31 "UTTAR PRADESH" ///
                      32 "UTTARANCHAL" 33 "WEST BENGAL"
replace podom = "" if podom == "N.A." | podom == "NULL" | podom == "No"
encode podom, generate(domicile) label(domicile)
move domicile podom
drop podom
label var domicile "Place of Domicile"

label define language  1 "ADI" 2 "ASSAMESE" 3 "BENGALI" 4 "BHOJPURI" 5 "DOGRI" ///
                       6 "ENGLISH" 7 "GARO" 8 "GUJARATI" 9 "HINDI" ///
                      10 "KANNADA" 11 "KASHMIRI" 12 "KHASI" 13 "KONKANI" ///
                      14 "MAITHILI" 15 "MALAYALAM" 16 "MANIPURI" 17 "MARATHI" ///
                      18 "MIZO" 19 "NAGAMESE" 20 "NEPALESE" 21 "ORIYA" ///
                      22 "OTHERS" 23 "PUNJABI" 24 "SIKKIMESE" 25 "SINDHI" ///
                      26 "TAMIL" 27 "TELUGU" 28 "TENYIDIE(ANGAMI)" ///
                      29 "TIBETAN" 30 "TULU" 31 "URDU" 32 "ARABIC" 33 "FRENCH" ///
                      34 "GERMAN" 35 "PERSIAN" 36 "SANSKRIT" 37 "RUSSIAN" ///
                      38 "SPANISH" 39 "CHINESE" 40 "JAPANESE" 41 "ITALIAN" ///
                      42 "PORTUGESE"
replace language = "TULU" if language == "Tulu"
replace language = "" if language == "-" | language == "N.A." | language == "NULL"
encode language, generate(lang) label(language)
move lang language
drop language
rename lang language
label var language "Native Language"

split indlang
forv i = 1/5 {
	replace indlang`i' = "" if indlang`i' == "N.A." | indlang`i' == "NULL"
	encode indlang`i', generate(xlang`i') label(language)
	}
drop indlang indlang1-indlang5
split forlang
replace forlang1 = "" if forlang1 == "N.A." | forlang1 == "N.A" | ///
	forlang1 == "NULL"
encode forlang1, generate(xlang6) label(language)
replace forlang2 = "" if forlang2 == "N.A." | forlang2 == "N.A" | ///
	forlang2 == "NULL"
encode forlang2, generate(xlang7) label(language)
drop forlang forlang1-forlang2

label define retire	1 "AGE-SCIENTISTS" 2 "ON EXTN SERVICE" ///
			3 "ON SUPERANNUATION" 4 "RETD VOL"
replace retire = "" if retire == "NULL"
encode retire, generate(ret) label(retire)
move ret retire
drop retire
rename ret retire
label variable retire "Reason for retirement"
drop v12

generate ticker = 0
forv i = 1/6 {
	forv j = 1/6 {
		local k = `j' + 1
		replace ticker = 1 if mi(xlang`j')
		replace xlang`j' = xlang`k' if mi(xlang`j')
		replace xlang`k' = . if ticker == 1
		replace ticker = 0 if ticker == 1
		}
	}
drop xlang7 ticker
drop if id == "No"
compress
save ../data/iast1.dta, replace

clear
insheet using ../canonical/parsed/iast2.csv, c n
drop if !mi(v9)
drop v9-v17
rename deputation id
rename depstart deputation
rename depend depstart
rename tenurecode depend
rename deprever tenurecode
rename depdebar deprever
rename debarperiod depdebar
rename v8 debarperiod

label define yes 0 "No" 1 "Yes"
encode deputation, g(dep) label(yes)
move dep deputation
drop deputation
rename dep deputation
label variable deputation "Presently on Deputation to GOI"

replace depstart = "" if depstart == "NULL"
generate depstartdate = date(depstart, "DMY")
format depstartdate %td
move depstartdate depstart
drop depstart
rename depstartdate depstart
label var depstart "Date of Start of Central Deputation"

replace depend = "" if depend == "NULL"
generate dependdate = date(depend, "DMY")
format dependdate %td
move dependdate depend
drop depend
rename dependdate depend
label var depend "Date of End of Central Deputation"

label define tenure 1 "AFTER EXT REVTD" 2 "EXTENDED TENURE" 3 "LAST REVERTED" ///
		    4 "NORMAL TENURE" 5 "PRE-MATURE REV" 6 "TENURE NOT APP" ///
		    7 "TERMS"
replace tenurecode = "" if tenurecode == "N-A" | tenurecode == "NULL"
encode tenurecode, g(tenure) label(tenure)
move tenure tenurecode
drop tenurecode

replace deprever = "" if deprever == "NULL"
generate depreverdate = date(deprever, "DMY")
format depreverdate %td
move depreverdate deprever
drop deprever
rename depreverdate deprever
label var deprever "Date of Reversion from GOI to Cadre, if Any"

encode depdebar, g(depbar) label(yes)
move depbar depdebar
drop depdebar
rename depbar depdebar
label variable depdebar "Debarred from Central Deputation?"

replace debarperiod = "" if debarperiod == "-"
split debarperiod, parse(" - ")
generate debarstart = date(debarperiod1, "DMY")
format debarstart %td
move debarstart debarperiod
generate debarend = date(debarperiod2, "DMY")
format debarend %td
move debarstart debarperiod
drop debarperiod debarperiod1 debarperiod2
label variable debarstart "Start of Debarment Period"
label variable debarend "End of Debarment Period"
compress
save ../data/iast2.dta, replace

clear
insheet using ../canonical/parsed/iast3.csv, c n
drop if !mi(v6)
drop v6 v7

rename slno ed_id

split qiup, parse("WATERLOO")
move qiup1 qiup
rename qiup1 degree
move qiup2 qiup
rename qiup2 institution
drop qiup

replace subjects = lower(subjects)
local subject_words `" "accountancy\.chd" "administrative mgt" "administrativ sc" "adminstrativ sc" "administratv law" "admn\.sc\.&dev problem" "aero engg" "agri\.engg\." "agri statistics" "air pollution modelling" "analytical chem" "animal breeding" "animal husby" "applied demography" "applied eco\." "applied geology" "applied maths" "applied mech" "applied optics" "auto\.engg\." "bio chemistry" "bio-physics" "bio-technology" "building sc" "business admn\." "business&co\.law" "business econ" "business mgt" "business\.orgn" "bus\.statistics\." "capital mkts" "chartered fincl analyst" "chemical engg" "chem\.physics" "civil aviation" "civil engg" "clic psychology" "clinical pathgy" "commercial law" "commn\.engg" "communication" "company law" "company mgt\." "computer application" "computer networks" "computer sc" "computer system" "computer tech" "constl\.law" "construction mgt" "corporate finance" "intrntl finance" "corporate mgmt" "cost acct" "cost audit" "dairy production" "defence & strategic studies" "defence studies" "dev adm" "development management" "dev mgt" "dev & regional plg" "dev studies" "digital commn engg" "economic dev\." "agrl\.economics" "development economics" "eco planning" "eco policy & mgt" "electrical engg" "electrical machines&desig" "electronics engg" "energy planning" "energy & environmental policy" "energy studies" "english literature" "english lit" "eng\. mech\." "environmental laws" "environmntl sc\." "executive devlopment" "export mgt" "farm management" "fibre sc\.&tech\." "fincl mgt" "fluid mechanics" "food technology" "foreign affairs" "foreign trade" "forensic sc\." "foundation engg" "gandhian studies" "gender analysis" "globalization and urban dev" "governance & dev\." "health management" "hindu law" "ancient history" "modern ind\.hist" "ancient ind\.history" "euro\.history" "indian history" "br\.cons history" "eco\.history" "history \(hons\)" "housing and environment" "human res\.mgt" "human res mngmt" "iformation&tech" "income tax" "indl\.dev\." "indl engg\." "indl\.economics" "indl\.mgt" "indl\.orgn\." "indus relations" "information sc" "integrated electronics" "integ rural engy tech\." "intellectual property" "intel\.property law" "international dev" "intnl\.affairs" "intnl comm&policy" "intnl economics" "intnl eco" "intnl\.law" "intnl marketing" "intnl organisation" "intnl policy&studies" "intnl politics" "intnl relations" "intnl studies" "intnl taxation" "intnl trade\." "intrnl business" "intrnl deve policy" "intrnl deve pol" "intrnl dev" "labour admin" "labour laws" "labour legisln" "labour welfare" "land reclamation mgmt" "land reforms" "land scaping" "legal history" "local self govt" "macro eco policy & plg" "management&system" "managerial eco" "manpower plg" "marine biology" "marine\.engg\." "marketing mgt" "mass commn" "material engg" "material sc" "materials mgmt" "mech\.engg\." "mediaeval hty" "medical&dental" "ayurvedic medicine" "mercantile law" "metallurgy engg" "mgmt info system" "mgt&admn" "microlevel planning" "micro &macro eco" "mineral exploration" "mining\.engg\." "monetary\.eco\." "national dev" "project planning" "national security" "natural resource" "naval architre" "nl\.dev&proj\.plg\." "nuclear physics" "opration resear" "optical communi" "optical communication" "organic chemistry" "patents law" "pers\.mgt\." "petroleum engg" "pharm\.chem" "physical chem" "physical engg" "physics \(hons\)" "physilogy\(orgl behaviour\)" "planning &policy" "plant botany" "plant breeding" "plant pathology" "plant physiology" "plant physioloy" "plasti techlogy" "police admn" "political eco" "political sc\." "political studies" "political systems" "population&devlp" "poverty alleviation" "power sys engg" "prodn\.control" "prodn\.engg\." "prodn mgnt" "project mgt" "public admn" "public eco\." "public finance" "public health" "public policy" "public relation" "public sc\.& managt" "public service" "quality management" "radar engg" "regional plg" "rural dev economics" "rural dev planning\." "rural dev" "rural mgt" "rural social dev" "rural sociology" "rur social dev" "behav science" "dairy science" "fishery science" "soil science" "sectt\.practices" "security relatn" "sino-burmese rl" "small scale sector" "social planning" "social policy" "social pol&planning -uk" "social sciences" "social services" "social studies" "social work" "strategic export mkt" "structural engg" "sustainable dev" "system analysis" "system mgt" "tamil literature" "technology environmntl st" "tel comn engg" "telecomm engg" "textile engg\." "thermal sc\." "town planning" "trng & developmemt" "urban economic dev" "urban planning" "urban studies" "utility regulation" "veterinary sc\." "water management" "water r dev" "watershed development" "web pages designing" "west asian studies" "western history" "west european st" "wildlife mgt" "accountancy" "advertising" "agriculture" "agronomy" "anaesthology" "anatomy" "anthropology" "arabic" "archaeology" "architecture" "art" "assamese" "astronomy" "auditing" "banking" "bengali" "microbiology" "biology" "botany" "business" "census" "chemistry" "chinese" "commerce" "computers" "cooperation" "criminology" "crimnology" "demography," "dentistry" "development" "diplomacy" "gynaecology" "ecology" "econometrics" "economics" "education" "optoelectronics" "electronics" "empowerment" "engineeriing" "english" "entomology" "equity" "export" "federalism" "finance" "forestry" "french" "genetics" "geophysics" "geography" "geology" "german" "hindi" "history" "homeopathy" "hons" "horticulture" "humanities" "hydromech" "ichthyology" "instrumentation" "journalism" "kannada" "labour" "law" "linguistics" "logic" "malayalam" "management" "marathi" "marketing" "mathematics" "medicine" "metallurgy" "mycology" "napalese" "nursing" "nutrition" "obstetrics" "opthalmology" "oriya" "orthopaedics" "paediatrics" "parasitology" "persian" "pharmacology" "pharmacy" "philosophy" "physics" "physiology" "planning\." "politics" "poltics" "power" "psychology" "punjabi" "radiology" "russian" "sanskrit" "science" "silviculture" "sociology" "spanish" "statistics" "surgery" "tamil" "taxation" "technology" "telugu" "tibetan" "tourism" "urdu" "zoology" "culture""'

replace subjects = "" if regexm(subjects,"n\.a\.")
replace subjects = regexr(subjects,"policywatershed","policy watershed")
replace subjects = regexr(subjects,"economicsindl","economics indl")
replace subjects = ///
  regexr(subjects,"economicsdevelopment","economics development")

clonevar subs = subjects
generate ticker = 0
forvalues i = 1/4 {
	  generate subj`i' = ""
          foreach k of local subject_words {
            replace ticker = 1 if regexm(subjects,`"`k'"') & subj`i' == ""
            replace subj`i' = `"`k'"' if subj`i' == "" & ticker == 1
            replace subjects = regexr(subjects,`"`k'"',"") if subj`i' ///
             != "" & ticker == 1
            replace ticker = 0
          }
        }

drop subs ticker
forv i = 1/4 {
	move subj`i' subjects
	rename subj`i' subject`i'
}
drop subjects

label define division   1 "First" 2 "Second" 3 "Third" 4 "Pass" ///
			5 "First with Distinction" 6 "Ordinary" ///
			7 "Gold Medalist" 8 "Grade 'A'" 9 "Outstanding" ///
			10 "Not Awarded"
encode division, g(div) label(division)
move div division
drop division
rename div division
label var division "Educational Division Awarded"
compress
save ../data/iast3.dta, replace

clear
insheet using ../canonical/parsed/iast4.csv, c n
rename slno pos_id

rename deptoffice postoffice

label define organization 1 "CADRE" 2 "CENTRE-N.DELHI" 3 "CDR-OTHER STATE" ///
			 4 "CENTRE-NOT ND" 5 "CDR-FOREIGN TRG" 6 "CADRE-F.ASSGNT" ///
			 7 "CADRE-ABROAD" 8 "CDR-STUDY LEAVE" 9 "CENTRE-ABROAD" ///
			10 "CADRE DEPUTATION" 11 "CENTRE OTHERS" 12 "CEN-FOREIGN TRG" ///
			13 "CADRE-DEP UND.6(2)(III)" 14 "CADRE-PUB.SEC" 15 "CEN-STUDY LEAVE" ///
			16 "CENTRE-F.ASSNGT" 17 "CENTRE-PS-NO ND" 18 "EX-CADRE" ///
			19 "CENTRE-PS-ND" 20 "CDR-FORGN TRG(P.F)" 21 "CEN-FORGN TRG(P.F)" ///
			22 "CADRE-OTHERS" 23 "ADMINISTRATIVE STAFF COLLEGE OF INDIA" 24 "ADMINISTRATIVE TRAINING INSTITUTE" ///
			25 "IIT" 26 "NATIONAL INSTITUTE OF RURAL DEVELOPMENT" 27 "TATA MANAGEMENT TRAINING CENTRE"
replace organization = "" if organization == "N.A."
encode organization, g(org) label(organization)
move org organization
drop organization
rename org organization
label variable organization "Organization of posting"

replace experience = "" if experience =="HYDERABAD"
replace experience = "" if experience =="MYSORE"
replace experience = "" if experience =="N.Applicable/N.Available Not Applicable"
replace experience = "" if experience =="N.Applicable/N.Available Not Available"
replace experience = "" if experience =="PUNE"

split experience, parse("WATERLOO")
move experience1 experience
rename experience1 maj_exp
move experience2 experience
rename experience2 min_exp
drop experience

split period, parse(" WATERLOO")
drop period
generate poststart = date(period1, "DMY")
format poststart %td
label var poststart "Start Date of Posting"
generate postend = date(period2, "DMY")
format postend %td
label var postend "End Date of Posting"
drop period1 period2

split deslev, parse("WATERLOO")
move deslev1 deslev
rename deslev1 designation
move deslev2 deslev
rename deslev2 level
drop deslev

replace designation = "" if designation == "N.A."
replace postoffice = subinstr(postoffice,"WATERLOO","|",.)

compress
save ../data/iast4.dta, replace

clear
insheet using ../canonical/parsed/iast5.csv, c n

rename slno strain_id

split year, parse("-")
destring year1, replace
rename year1 strainstartyr
destring year2, replace
rename year2 strainendyr
move strainstartyr year
label var strainstartyr "Year In-Service Training Started"
move strainendyr year
label variable strainendyr "Year In-Service Training Ended"
drop year

label var training "Topic of training"
label var institute "Provider of training"

label define city	 1 "AHMEDABAD" 2 "BANGALORE" 3 "BHOPAL" ///
			 4 "BHUBANESWAR" 5 "CALCUTTA" 6 "CHANDIGARH" ///
			 7 "CHENNAI" 8 "DELHI" 9 "FARIDABAD" 10 "GURGAON" ///
			11 "GUWAHATI" 12 "HYDERABAD" 13 "JAIPUR" ///
			14 "JAMSHEDPUR" 15 "KOLKATA" 16 "LUCKNOW" ///
			17 "MUMBAI" 18 "MUSSOORIE" 19 "MYSORE" ///
			20 "NAINITAL" 21 "NEW DELHI" 22 "NOIDA,UP" ///
			23 "PANCHGANI" 24 "PUNE" 25 "SIMLA" ///
			26 "THIRUVANANTHAPURAM"
replace city = "" if city == "39"
replace city = "JAIPUR" if city == "JAIPUR "
replace city = "SIMLA" if city == "SHIMLA"
encode city, g(straincity) l(city)
move straincity city
drop city
label var straincity "Location of In-Service Training (City)"

rename duration sduration
label var sduration "Duration of In-Service Training (Weeks)"

compress
save ../data/iast5.dta, replace

clear
insheet using ../canonical/parsed/iast6.csv, c n

rename slno train_id
rename year trainyr
label variable trainyr "Year of Training"
label variable training "Provider/Type of Training"
label define train_subject	 1 "Agriculture & Cooperation" 2 "Commerce" ///
				 3 "Communications & Information Technology" ///
				 4 "Consumer Affairs, Food & PD" 5 "Corporate Management" ///
				 6 "Defence" 7 "Energy" 8 "Environment & Forests" ///
				 9 "Finance" 10 "Health & Family Welfare" 11 "Home" ///
				12 "Human Resource Dev" 13 "Industries" 14 "Information & Broadcasting" ///
				15 "Labour & Employment" 16 "Law & Justice" 17 "Mines & Minerals" ///
				18 "Personnel & General Admn" 19 "Planning & Prog Implementation" ///
				20 "Public Administration" 21 "Public Works" 22 "Rural Dev" ///
				23 "Science & Technology" 24 "Social Justice & Empowerment" ///
				25 "Tourism" 26 "Transport" 27 "Urban Development" 28 "Water Resources"
replace subject = "Corporate Management" if subject == ///
	"Corporate Management (New)"
encode subject, g(trainsubj) label(train_subject)
move trainsubj subject
drop subject
label var trainsubj "Subject of Training"

label var duration "Duration of Training (Weeks)"

rename v7 country
replace country = "INDIA" if mi(country)
label var country "Country of Training"

generate foreign = 0
replace foreign = 1 if country != "INDIA"

compress
save ../data/iast6.dta,replace

clear
insheet using ../canonical/parsed/iast7.csv, c n

rename slno train_id
rename year trainyr
label variable trainyr "Year of Training"
label variable training "Provider/Type of Training"
label define train_subject	 1 "Agriculture & Cooperation" 2 "Commerce" ///
				 3 "Communications & Information Technology" ///
				 4 "Consumer Affairs, Food & PD" 5 "Corporate Management" ///
				 6 "Defence" 7 "Energy" 8 "Environment & Forests" ///
				 9 "Finance" 10 "Health & Family Welfare" 11 "Home" ///
				12 "Human Resource Dev" 13 "Industries" 14 "Information & Broadcasting" ///
				15 "Labour & Employment" 16 "Law & Justice" 17 "Mines & Minerals" ///
				18 "Personnel & General Admn" 19 "Planning & Prog Implementation" ///
				20 "Public Administration" 21 "Public Works" 22 "Rural Dev" ///
				23 "Science & Technology" 24 "Social Justice & Empowerment" ///
				25 "Tourism" 26 "Transport" 27 "Urban Development" 28 "Water Resources" ///
				29 "External Affairs" 30 "Women & Child Dev" 31 "Youth Affairs & Sports"
replace subject = "Corporate Management" if subject == ///
	"Corporate Management (New)"
encode subject, g(trainsubj) label(train_subject)
move trainsubj subject
drop subject
label var trainsubj "Subject of Training"

label var duration "Duration of Training (Weeks)"

rename v7 country
label var country "Country of Training"

generate foreign = 1

compress
save ../data/iast7.dta,replace

use ../data/iast6.dta
append using ../data/iast7.dta

label define countries 	 1 "AUSTRALIA" 2 "AUSTRIA" 3 "BANGLADESH" ///
			 4 "BELGIUM" 5 "CANADA" 6 "CHINA" 7 "DENMARK" ///
			 8 "FINLAND" 9 "FRANCE" 10 "GERMANY EAST" ///
			11 "HONG KONG" 12 "INDIA" 13 "INDONESIA" ///
			14 "ISRAEL" 15 "ITALY" 16 "JAPAN" 17 "KENYA" ///
			18 "KOREA" 19 "MALAYSIA" 20 "NEPAL" 21 "NETHERLANDS" ///
			22 "NEW ZEALAND" 23 "NORWAY" 24 "PAKISTAN" ///
			25 "PHILIPPINES" 26 "SINGAPORE" 27 "SLOVENIA" ///
			28 "SOUTH AFRICA" 29 "SPAIN" 30 "SRI LANKA" ///
			31 "SWEDEN" 32 "SWITZERLAND" 33 "TANZANIA" ///
			34 "THAILAND" 35 "TURKEY" 36 "UNITED KINGDOM" ///
			37 "USA" 38 "USSR" 39 "VIETNAM" 40 "YUGOSLAVIA"
replace country = "NETHERLANDS" if country == "HOLLAND"
replace country = "SWITZERLAND" if country == "GENEVA"
replace country = "YUGOSLAVIA" if country == "YUGASLAVIA"
replace country = "" if country == "NA/OTHERS"
replace country = "" if country == "NOT AVAILABLE"
encode country, g(cntry) l(countries)
move cntry country
drop country
rename cntry country
label var country "Country of Training"

compress
save ../data/iast6_7.dta,replace
erase ../data/iast6.dta
erase ../data/iast7.dta
