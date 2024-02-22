# ias_asq_replication
Replication materials for Ferguson &amp; Hasan 2013

*************************************************************************
REPLICATION MATERIALS FOR "SPECIALIZATION AND CAREER DYNAMICS: EVIDENCE FROM THE INDIAN ADMINISTRATIVE SERVICE"
BY JOHN-PAUL FERGUSON AND SHARIQUE HASAN
*************************************************************************

DOI: 10.1177/0001839213486759

Herein are the materials necessary to replicate the results from our 2013 paper that was published in Administrative Science Quarterly volume 58, number 2, in June 2013.  

This was one of the first projects that both I (JPF) and Sharique worked on from scratch with a co-author. We learned a lot about keeping data organized, writing well-documented code, and the like.  That is good and bad for someone who wants to replicate this work.  We had to work hard enough to make our work replicable FOR EACH OTHER that the level of documentation was already high.  At the same time, we were learning about the clearest (and less-clear) ways to write the code itself.

Below I explain the steps to replicate our results.  I begin with a step "zero" because, while we have included the original HTML files that we parsed into Stata-formatted data, most people will probably start with or convert the Stata files.

I am always happy to answer questions.

--JP Ferguson

*************************************************************************
STEP ZERO: BUILD STATA DATA FROM HTML FILES
*************************************************************************

This is probably the hardest step to reproduce, because of old code and file dependencies.  For what it's worth, I have preserved the files that come at the end of this step.

The "canonical" data are a series of Executive Record Sheets, showing the background, training, and career experiences of IAS officers.  Within canonical/  there’s a ZIP file with these sheets, stored as HTML files, one per officer.  The HTML files each have seven tables containing various parts of the officers’ career histories.

In code/ there is a perl script, parseIAS.pl.  It inputs those HTML files, each with seven tables, and outputs seven tables, each with several thousand entries.  These are saved as CSV files: iast1.csv, iast2.csv, etc.

That perl script expects to be in the same directory as the HTML files (I hadn’t yet learned to do relative paths in perl when I wrote it), and it expects to write to a folder called "parsed" in the same directory.  It could be edited to be called from code/ and write its output to data/, which is how I’d
do things nowadays.  But...full disclosure here: I switched to python years ago and never looked back.  One of perl's worst features is its fast mental bit-rot.  I couldn’t write this script again without considerable research, and I’m nervous to make small changes to it.  Also, life is short.

The code/ folder also has a Stata do-file, ias_csv2dta.do.  This reads in each of the CSV files written by the perl script, cleans up the variables, labels them, and writes out Stata data files: last1.dta, iast2.dta, etc. THOSE FILES ARE IN DATA/ ALREADY. If you want, you can start with those.

To summarize, and be clear: these six DTA files (tables 6 and 7 are combined) have all the information from the original HTML files, in a more friendly format.

*************************************************************************
STEP ONE: BUILD THE ANALYSIS FILE
*************************************************************************

Within code/ there is ias_data_building.do.  What it does is very much in the name.  There are a lot of individual changes to the data files in here; these reflect our cleaning up the data as best we could, to deal with typos and the like.  We also discuss the judgment calls we made about assigning various experiences, which can matter for the final results.

The final result is a file called working_ias.dta, which is saved in data/.

*************************************************************************
STEP TWO: RUN THE ANALYSIS
*************************************************************************

This part should hopefully be straightforward.  There is a script called ias_analysis.do in code/.  It produces the tables that are in the paper.

A word of warning: we used Stata's estout package to produce most of the tables.  You'll need that installed in Stata for many of the commands to run.  However, some of estout's internals have changed.  Thus the esttab command no longer writes all variable coefficients are not being written to the TEX files.  (This is why R has the groundhog library!)  You can always see the output in Stata's results window by removing the "quietly" prefixes to those commands.

*************************************************************************
MISCELLANY: OTHER FILES
*************************************************************************

code/promotion_probability_figure.do: This produces a graphic that appears in the online appendix.  It draws on working_ias.dta from data/ to do so.

scripts/cmchanges.do: This creates a file with flags for each time period, indicating whether the Chief Minister in a cadre changes in that period.  This calls a CSV file from data/ called Chief_M_5oct2011.csv.  Notice that there is a similarly-named Excel file in that same folder.  This reflects how Stata could not directly read in XLS files before version...14, I think.  Thus practice was to create a CSV version of the XLS file and read that in.  Good times.

create_shared_data.do: Sometimes we get requests for our raw data.  That is, someone doesn't want all of our constructed variables but just wants a clean version of the IAS officers' career histories.  We wrote this script to produce such a file from data/working_ias.dta.  The resulting file, ferguson_hasan_2013asq_IAS_records.dta, is also in data/.

figures: There are several figures in the paper's online appendix that were requested by reviewers. Because these did not appear in the paper itself, we have not included them here. They are available from the authors on request.
