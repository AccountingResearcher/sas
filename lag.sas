/*****************************************

<MACRO to create lags>
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

%lag
(datain=,
dataout=,
variable=,
nlag=, 
date=)

Variable Names:

datain = input - don't forget to include library name
dataout = output
variable = variable list - don't include commas
nlag = indicate the degree of lag
date = time id variable

example:
*%lag(datain=season_average2,
dataout=example,
variable=gross,nlag=2,date=datadate);


************************/

 %macro lag(datain=,dataout=,variable=,nlag=, date=);

 proc sort data=&datain; by &date ; quit;

 data &dataout;
 set &datain;
   &variable._&nlag = lag&nlag(&variable); 
keep &date &variable._&nlag;
run;   
    
%mend; 

