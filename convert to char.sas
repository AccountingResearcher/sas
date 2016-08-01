/*****************************************

<MACRO to change characters to numeric variables>
    Copyright (C) <2016>  
Author: <Seda Oz> <www.sedaoz.net>
Author's Note: Thank you for cheking out my GitHub page. Please do let me know 
if you happen to see a crucial mistake. Happy SAS coding. 

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, version 3 of the License.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

**************************************************/

/************************
MACRO DETAILS

%char2num(
inputlib=, libref for input data set  
 inputdsn=, name of input data set  
 outputlib=, libref for output data set 
 outputdsn=, name of output data set  
 excludevars=); variables to exclude 

*******************/ 

%macro char2num(inputlib=, /* libref for input data set */ 
 inputdsn=, /* name of input data set */ 
 outputlib=, /* libref for output data set */ 
 outputdsn=, /* name of output data set */ 
 excludevars=); /* variables to exclude */ 
 
proc sql noprint; 
select name into :charvars separated by ' ' 
from dictionary.columns 
where libname=upcase("&inputlib") and memname=upcase("&inputdsn") and type="char" 
 and not indexw(upcase("&excludevars"),upcase(name)); 
quit; 
 
%let ncharvars=%sysfunc(countw(&charvars)); 
 
data _null_; 
set &inputlib..&inputdsn end=lastobs; 
array charvars{*} &charvars; 
array charvals{&ncharvars}; 
do i=1 to &ncharvars; 
 if input(charvars{i},?? best12.)=. and charvars{i} ne ' ' then charvals{i}+1; 
end; 
if lastobs then do; 
 length varlist $ 32767; 
 do j=1 to &ncharvars; 
 if charvals{j}=. then varlist=catx(' ',varlist,vname(charvars{j})); 
 end; 
 call symputx('varlist',varlist); 
end; 
run; 
 
%let nvars=%sysfunc(countw(&varlist)); 
 
data temp; 
set &inputlib..&inputdsn; 
array charx{&nvars} &varlist; 
array x{&nvars} ; 
do i=1 to &nvars; 
 x{i}=input(charx{i},best12.); 
end; 
drop &varlist i; 
 
%do i=1 %to &nvars; 
 rename x&i = %scan(&varlist,&i) ; 
%end; 
 
run;

proc sql noprint; 
 
select name into :orderlist separated by ' ' 
from dictionary.columns 
where libname=upcase("&inputlib") and memname=upcase("&inputdsn") 
order by varnum; 
 
select catx(' ','label',name,'=',quote(trim(label)),';') 
 into :labels separated by ' ' 
from dictionary.columns 
where libname=upcase("&inputlib") and memname=upcase("&inputdsn") and 
 indexw(upcase("&varlist"),upcase(name)); 
 
quit; 
 
data &outputlib..&outputdsn; 
retain &orderlist; 
set temp; 
&labels 
run; 
 
%mend char2num;
