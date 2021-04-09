cas mysession;
caslib _ALL_ assign;

data casuser.BASEBALL;
set sashelp.baseball;
label League= "League"
 Division = "Division"
 nRuns = "Total Runs"
 Salary= "1987 Salary";
format nRuns comma8. Salary dollar18.0;
where DIV = "&DIV";
run;


proc regselect data=casuser.BASEBALL;
class League Division;
model logSalary=League Division nAtBat nHits nHome nRuns nRBI nBB YrMajor
CrAtBat CrHits CrHome CrRuns CrRbi CrBB nOuts nAssts nError / clb vif;
output out=casuser.Regselect_stats p=predicted r=residual cookd=cookd
h=leverage;
run;


ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=CASUSER.REGSELECT_STATS;
	scatter x=predicted y=residual /;
	xaxis grid;
	yaxis grid;
run;

ods graphics / reset;
