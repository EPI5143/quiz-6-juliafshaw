libname epi5143 '\\Mac\Home\Desktop\EPI5143 work folder\data';
proc contents data=epi5143.nencounter;
run;
*checking for and deleting duplicate encounters;
proc sort data=epi5143.nencounter out=single nodupkey;
by EncWID ;
run;
*removing all encounters before 2003;
data new;
set epi5143.nencounter;
year=year(datepart(EncStartDtm));
if year<2003 then delete;
run;
*flatfiling by patient ID;
proc sort data=new;
by EncPatWID;
run;
data flatpt;
set new;
by EncPatWID;
array nenc{28} enc1-enc28;
array ttype{28} $ type1-type28;
retain enc1-enc28 type1-type28 counter;
if first.EncPatWID=1 then do x=1 to 28;
	nenc{x}=.;
	ttype{x}= '       ';
	counter=1;
	end;
nenc{counter}=EncWID;
ttype{counter}=EncVisitTypeCd;
counter=counter+1;
if last.EncPatWID=1 then do;
	keep EncPatWID enc1-enc28 type1-type28;
	output;
	end;
run;
*keeping only inpatient encounters;
data inpatient;
set flatpt;
array ttype{28} $ type1-type28;
do x=1 to 28;
	if ttype{x}='EMERG' then delete;
	end;
run;

**** Question a) answer: there are 3064 observations in this dataset, so 3064 patients had at 
			least 1 inpatient encounter that started in 2003 ****;

*keeping only emergent encounters;
data emergency;
set flatpt;
array ttype{28} $ type1-type28;
do x=1 to 28;
	if ttype{x}='INPT' then delete;
	end;
run;

**** Question b) answer: there are 6338 observations in this dataset, so 6338 patients had at 
			least 1 emergency room encounter that started in 2003 ****;

proc contents data=flatpt;
run;

**** Question c) answer: there are 10305 observations in this dataset, so 10305 patients had at 
			least 1 visit of either type of encounter that started in 2003 ****;

*creating counter for number of encounters (any type);
data Qd;
set flatpt;
encounters=0;
array nenc{28} enc1-enc28;
do x=1 to dim(nenc);
	if nenc{x} ne . then encounters+1;
	end;
run;
ods listing;
options formchar="|----|+|---+=|-/\<>*";
proc freq data=Qd order=freq;
table encounters;
run;

*

                                         The SAS System          16:37 Monday, March 30, 2020   2

                                       The FREQ Procedure

                                                        Cumulative    Cumulative
                 encounters    Frequency     Percent     Frequency      Percent
                 ---------------------------------------------------------------
                          1        8314       80.68          8314        80.68
                          2        1442       13.99          9756        94.67
                          3         333        3.23         10089        97.90
                          4         114        1.11         10203        99.01
                          5          37        0.36         10240        99.37
                          6          28        0.27         10268        99.64
                          8          11        0.11         10279        99.75
                          7           9        0.09         10288        99.84
                          9           4        0.04         10292        99.87
                         10           4        0.04         10296        99.91
                         12           2        0.02         10298        99.93
                         13           2        0.02         10300        99.95
                         11           1        0.01         10301        99.96
                         17           1        0.01         10302        99.97
                         23           1        0.01         10303        99.98
                         27           1        0.01         10304        99.99
                         28           1        0.01         10305       100.00
;






