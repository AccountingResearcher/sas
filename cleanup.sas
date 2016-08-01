/*****************************************

<MACRO to clean up libraries used by SAS>
    Copyright (C) <2016>  
Author: <Seda Oz> <www.sedaoz.net>
Author's Note: Thank you for cheking out my GitHub page. Please do let me know 
if you happen to see a crucial mistake. Happy SAS coding. 
This particular code has been written by Harry Droogendyk, 
Stratia Consulting Inc., Lynden, ON. I have added few fixes. 

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
Please note that this macro will delete all the datasets in the work library.
Make sure that you have saved your work before deleting them.
example: 
%calcret_factor(data=y,macro=n);

********************************************/


%macro cleanup(help,data=Y,macro=Y);
%if &help = ? or %upcase(&help) = HELP %then %do;
 %put;
 %put %nrstr(%cleanup(data=Y,macro=Y););
 %put %nrstr(Cleans up WORK datasets and global macro variables.);
 %put %nrstr(Parms: &data - Y=delete work datasets, default=Y);
 %put %nrstr( &macro - Y=delete global macro variables, default=Y);
 %put %nrstr(Use: %cleanup(macro=N););
%end; %else %do;
 %if &data = %str() %then %let data = Y; %else %let data = %upcase(&data);
 %if &macro = %str() %then %let macro = Y; %else %let macro = %upcase(&macro);
 %if &data = Y %then %do;
 %put NOTE: %nrstr(%cleanup is deleting WORK datasets);
 proc datasets lib=work nolist nowarn nodetails
 kill;
 quit;
 %end;
 %if &macro = Y %then %do;
 %put NOTE: %nrstr(%cleanup is deleting GLOBAL macro variables);
 data _null_;
 length cmd $200;
 set sashelp.vmacro;
 where scope = 'GLOBAL' and offset = 0 and name ne: 'SYSDB';
 cmd = '%nrstr(%symdel ' || trim(name) || ' / nowarn );';
 call execute(cmd);
 run;
 %end;
 %end;
%mend cleanup; 
