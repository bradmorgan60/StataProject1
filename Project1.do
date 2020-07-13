set more off
clear


* This next line of code changes where STATA will look for files and save files
cap cd "\\prism.nas.gatech.edu\jmorgan67\vlab\desktop\HW5 Data"
use stardata_Kindergarten


* Start log file to record what Stata does below
log using Assignment5_log, replace

* Read in Data
use stardata_Kindergarten, clear

* Create percentiles of test scores (using only reg and reg+aide classes), apply percentiles to entire sample to create mean score
replace readk=. if readk==999
replace mathk=. if mathk==999
pctile readkpct=readk if ctypek==2|ctypek==3, nq(100)
pctile mathkpct=mathk if ctypek==2|ctypek==3, nq(100)
xtile readkperc=readk if ctypek~=9, cutpoints(readkpct)
xtile mathkperc=mathk if ctypek~=9, cutpoints(mathkpct)
gen mnscorek=(readkperc+mathkperc)/2
replace mnscorek=readkperc if mathkperc==.
replace mnscorek=mathkperc if readkperc==.
label var mnscorek "mean reading and math score, grade k"

* Create age variable
replace yob=. if yob==9999
replace qob=. if qob==99

gen mob=.
replace mob=2.5 if qob==1
replace mob=5.5 if qob==2
replace mob=8.5 if qob==3
replace mob=11.5 if qob==4 
gen agein1985=1985-yob+(9-mob)/12 
label var agein1985 "Age in (September) 1985"

* Your code to complete the assignment will start here...

*-----PART I-----
*Getting the data ready for analysis
* Question a) 

twoway (scatter mnscorek readk)
graph export mean_read.png
twoway (scatter mnscorek mathk)
graph export mean_math.png

* Question b) 
gen freelunch=.
replace freelunch=1 if sesk==1
replace freelunch=0 if sesk==2

gen whiteorasian=.
replace whiteorasian=1 if race==1|race==3
replace whiteorasian=0 if race==2|race==4|race==5|race==6

summarize freelunch whiteorasian


*c)
gen Twhiteorasian=.
replace Twhiteorasian=1 if race==1|race==3
replace Twhiteorasian=0 if race==2|race==4|race==5|race==6

summarize Twhiteorasian totexpk

*d) 
 tabstat freelunch whiteorasian Twhiteorasian totexpk csizek, by (ctypek)
 
 display "Yes! The means of the variables appear to be evenly (randomly) distributed across the class types."
*1 = small class
*2 = regualr class
*3 = regular + aid

*Based off of the chart:
* - the majority of the kids do not get a free lunch (<0.5)
* - the majority of kids are either white or Asian
* - the majority of the teachers are either white or Asian
* - all of the teachers have an average of about 9 years of teaching

* - Class size:
* - small class size average: 15.3771
* - regular class size average: 22.38029
* - regular class size plus aid average: 23. 2082



log close

