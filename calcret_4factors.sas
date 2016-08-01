/*****************************************

<MACRO to calculate cumulative abnormal returns using 4 factors model>
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

%CALCRET_FACTOR (
DATAIN=,
DATAOUT=,
DAYS=);

Variable Names:

DATAIN = Input Dataset  - Don't forget to include library name 
unless you want to use a dataset from "work" library

DATAOUT = Output Dataset - Don't forget to include library name 
unless you want your output to be in the "work" library

DAYS = Indicate the number of days over which you want 
to calculate the cumulative abnormal returns

example: 
%calcret_factor(datain=abnormal.withbeta,dataout=abnormal.subset,days=20);

********************************************/

/*Macro to calculate cumulative abnormal returns (4 factors) for xx days */
%MACRO CALCRET_factor(datain=,dataout=,days=);

proc sort data=&datain;
by permno descending date; run; quit;

data &dataout&days;
set &datain;
  by permno;

   lfret=log(exret+1);   
   lsret=log(mktrf+1);
   lzret=log(smb+1);
   lxret=log(hml+1);   
   lcret=log(umd+1);

    array lagfret[&days] lagfret1-lagfret&days;
    array lagsret[&days] lagsret1-lagsret&days;
    array lagzret[&days] lagzret1-lagzret&days;
    array lagxret[&days] lagxret1-lagxret&days;	
    array lagcret[&days] lagcret1-lagcret&days;	
	
    %do j=1 %to &days;
       lagfret&j=lag&j(lfret);
       lagsret&j=lag&j(lsret);
       lagzret&j=lag&j(lzret);
       lagxret&j=lag&j(lxret);
       lagcret&j=lag&j(lcret);	   
    %end;


    if first.permno then count=1;  
    do i=count to &days;
      lagfret[i] = .;
      lagsret[i] = .;
      lagzret[i] = .;
      lagxret[i] = .;
      lagcret[i] = .;	  
    end;
    count +1 ;

    fcumret= exp( sum(of lagfret1-lagfret&days)) -1;
    scumret= exp( sum(of lagsret1-lagsret&days)) -1;
    zcumret= exp( sum(of lagzret1-lagzret&days)) -1;
    xcumret= exp( sum(of lagxret1-lagxret&days)) -1;
    ccumret= exp( sum(of lagcret1-lagcret&days)) -1;
		
    drop l: count i;
run;

data &dataout&days; set &dataout&days;
a1=beta1*scumret;
a2=beta2*zcumret;
a3=beta3*xcumret;
a4=beta4*ccumret;
ar&days=fcumret-a1-a2-a3-a4;

drop a1-a4 fcumret scumret zcumret xcumret ccumret;
label AR&days="Abnormal Ret[1,&days]";

run;

proc sort data=&dataout&days; 
  by permno date;run; quit;

%mend calcret_factor;   



  
