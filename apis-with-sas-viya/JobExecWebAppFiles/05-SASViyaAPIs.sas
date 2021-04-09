/*retrieve service endpoint*/
%let BASE_URI=%sysfunc(getoption(servicesbaseurl));

/* create filenames to hold responses*/
filename rcontent temp;

/* Make request */
proc http 
	 oauth_bearer=sas_services	 
	 method="GET"
     url="&BASE_URI/reports/reports/&JESParameter/content/elements?characteristics=visualElement" 
	 /* place response in filenames */
	 	out=rcontent;
		headers
		"Accept"="application/vnd.sas.collection+json";
run;

/* read in response */
libname rcontent json;

/* return only "Graph" elements */
data reportElements;
set rcontent.items;
where Type eq "Graph";
run;


/* get number of obs */
data _NULL_;
	if 0 then set reportElements nobs=n;
	call symputx('nrows',n);
	stop;
run;


%if %upcase(&nrows)>0 %then
      %do;
			/* Print the results! */
			title "The Report's Visual Elements are Below:"; 
			proc report data=reportElements nowd;
				columns Type Label;
				define Type / group 'Report Object Type';
				define Label /display 'Report Object Label';
			run; 

%end;
%else
%do;
	  /* create message for user */
      ods text='<h3>The report VA you selected has no Graph Elements<h3>';
%end;