Title "Display class data for &gender";
proc print data=sashelp.class;
	where sex="&gender";
run;