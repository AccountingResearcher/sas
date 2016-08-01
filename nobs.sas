
/*****************************************

<MACRO to create a variable indicating number of observations>
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
   |
   |      lib=     libname of the SAS library containing your dataset.
   |               The default is WORK.
   |
   |      dsn=     name of the SAS dataset.  No default.
   |
   |      macvar=  name of the global macro variable containing the number
   |               of observations.  Default is nobs.
   | If you specify a non-existent libname or dataset name the macro
   | variable returns a blank which will probably cause an error when the
   | macro variable is referenced later in your program.
   *------------------------------------------------------------------*
  *************/

%macro nobs(lib=WORK,dsn=,macvar=nobs);
 %local notes;
 %global &macvar;
   proc sql;
    reset noprint;
    select setting into :notes from dictionary.options
       where optname='NOTES';
    quit;
   options nonotes;
   %let lib=%upcase(&lib);
   %let dsn=%upcase(&dsn);
   %let error=0;
   %let &macvar= ;
   %let n= ;
   %if &dsn= %then %do;
      %put ERROR: NO DATASET SPECIFIED.;
      %let error=1;
   %end;
   %if &error=0 %then %do;
      proc sql;
         reset noprint;
         select nobs into :n from dictionary.tables
         where libname="&lib" & memname="&dsn";
      quit;
      %if &n= %then %do;
         %put ERROR: DATASET NOT FOUND.;
      %end;
      %else %let &macvar=&n;
   %end;
   options &notes;
%mend nobs;
 
