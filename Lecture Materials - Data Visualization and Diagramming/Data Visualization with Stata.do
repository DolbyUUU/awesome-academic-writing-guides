*=====================================*
* Intro to data visualization *
* Oscar Torres-Reyna *
* DSS Princeton University *
* http://dss.princeton.edu/ *
*=====================================*

******* Setting working directory
*NOTE: If using Mac go to File -> Change Working Directory, and select the folder

cd "C:\Users\cxl87\Desktop" // set the path to your working directory

******* Opening a Stata data file

use "http://www.princeton.edu/~otorres/wdipol.dta", clear

******* Generating variables

replace unemp=. if unemp==0
replace unempf=. if unempf==0
replace unempm=. if unempm==0
bysort year: egen gdppc_mean=mean(gdppc)
bysort year: egen gdppc_median=median(gdppc)
recode polity2 (-10/-6=1 "Autocracy") ///
(-5/6=2 "Anocracy") ///
(7/10=3 "Democracy") ///
(else=.), ///
gen(regime) label(polity_rec)

******* Getting to know your data

browse
describe
summarize

******* Search Stata help files

help graph
help graph twoway

******* Line graphs

set scheme s2color

twoway line unemp unempf unempm year if country=="United States" // help twoway line

twoway line unemp unempf unempm year if country=="United States", /// help twoway_options
title("Unemployment rate in the US, 1980-2012") /// help title_options
legend(label(1 "Total") label(2 "Females") label(3 "Males")) /// help legend_options
lpattern(solid dash dot) /// help added_line_options
ytitle("Percentage") // help axis_options

******* Connected line graphs

twoway connected unemp unempf unempm year if country=="United States", /// help twoway connected
title("Unemployment rate in the US, 1980-2012") ///
legend(label(1 "Total") label(2 "Females") label(3 "Males")) ///
msymbol(circle diamond square) /// help marker_options
ytitle("Percentage")

twoway connected unemp year if country=="United States" | /// separate plots
country=="United Kingdom" | ///
country=="Australia" | ///
country=="Qatar", ///
by(country, title("Unemployment")) /// help by_option !!! see "Treatment of titles" in "by_option"
msymbol(circle_hollow)

twoway (connected unemp year if country=="United States", msymbol(diamond_hollow)) /// overlay plots
(connected unemp year if country=="United Kingdom", msymbol(triangle_hollow)) ///
(connected unemp year if country=="Australia", msymbol(square_hollow)) ///
(connected unemp year if country=="Qatar", ///
title("Unemployment") ///
msymbol(circle_hollow) ///
legend(label(1 "USA") label(2 "UK") label(3 "Australia") label(4 "Qatar")))

******* Graph markers

help palette

palette symbolpalette
palette linepalette

palette color green // help colorstyle
palette color emerald
palette color none // no color

******* Bar graphs

help graph bar

graph hbar (mean) gdppc // mean is the default
graph hbar (median) gdppc
graph hbar (max) gdppc
graph hbar (sum) gdppc

*bysort country : graph hbar (mean) gdppc // "graph may not be combined with by"

graph hbar (mean) gdppc, over(country, descending) // mean over country, for panel data

graph hbar (mean) gdppc, over(country, descending label(labsize(*0.25)))

graph hbar (mean) gdppc (median) gdppc if gdppc>40000, ///
over(country, descending label(labsize(*1))) ///
legend(label(1 "GDPpc (mean)") label(2 "GDPpc (median)"))

******* Box plots

help graph box

graph hbox gdppc

graph hbox gdppc, nooutsides

graph hbox gdppc if gdppc<40000

graph box gdppc, over(regime)

******* Scatterplots

help twoway scatter

twoway scatter import export

twoway (scatter import export)(scatter import export if export>1000000, mlabel(country) legend(off))

twoway (scatter import export, ytitle("Imports") xtitle("Exports")) ///
(scatter import export if export>1000000, mlabel(country) legend(off)) ///
(lfit import export, note("Constant values, 2005, millions US$"))

twoway (scatter gdppc year) ///
(connected gdppc_mean year, ///
msymbol(diamond_hollow) mcolor(red) lcolor(green)), xlabel(1980(5)2012, angle(90))

******* Scatterplot matrix

help graph matrix

graph matrix gdppc unemp export import, maxis(ylabel(none) xlabel(none))

graph matrix gdppc unemp export import, maxis(ylabel(none) xlabel(none)) half

******* Histograms

help hist

hist gdppc /* Shows density*/
hist gdppc, frequency /*Shows frequency*/

hist gdppc, kdensity /* Combo histogram and density plot */
hist gdppc, kdensity normal /* Adding a normal curve */
hist gdppc, kdensity normal bin(20) /*No of bins is 20*/

hist gdppc if country=="United States" | country=="United Kingdom", bin(20) by(country)
hist gdppc if gdppc>40000, bin(20) by(country)

twoway (hist gdppc if country=="United States", bin(10)) ///
(hist gdppc if country=="United Kingdom", bin(10) ///
bcolor(blue) fcolor(none)), legend(label(1 "USA") label(2 "UK"))

******* Panel data line plots

encode country, gen(country1) /*Assign numeric value to strings*/
xtset country1 year /*'country1' is coded variable*/

help xtline

xtline gdppc if country=="United States" | country=="United Kingdom"
xtline gdppc if gdppc>40000
xtline gdppc if gdppc>40000, overlay

******* Combining graphs

help graph combine

graph drop _all /*Drop graphics saved in memory*/

hist gdppc if country=="United States", name(gdppc, replace)
line unemp year if country=="United States", name(unemp, replace)
scatter import export if country=="United States", name(trade, replace)

graph combine gdppc unemp trade, col(1)
graph combine gdppc unemp trade, col(2)
graph combine gdppc unemp trade, row(1)
graph combine gdppc unemp trade, row(2)

******* Scatterplots with linear fit and confidence intervals

help twoway lfit
help twoway lfitci
help twoway qfitci

use "https://dss.princeton.edu/training/students.dta", clear

twoway (lfitci sat age) ///
(scatter sat age, mlabel(lastname)), title("SAT scores by age") ytitle("Sat")

twoway (lfit sat age) /// without confidence intervals
(scatter sat age, mlabel(lastname)), title("SAT scores by age") ytitle("Sat")

twoway (qfitci sat age) /// quadratic fit
(scatter sat age, mlabel(lastname)), title("SAT scores by age") ytitle("Sat")
