/*****************************************

<code to indicate numerical value of the weekday>
< Monday = 1, Tuesday = 2, Wednesday = 3 etc

weekday function created by SAS assumes that Sunday is the first day of the week
My function assumes that Monday is the first day of the week
>

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

/*****************************************

<MACRO to change labels of variables>
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
EXAMPLE:

data test1;
  input @01 employee_id   6.
        @08 last_name     $10.
        @19 birthday      date7.;
  format employee_id   6.
         last_name     $10.
         birthday      date7.;
  datalines;
  1247 Garcia     04APR54
  1078 Gibson     23APR36
  1005 Knapp      06OCT38
  1024 Mueller    17JUN53
;  
run;

DATA test2;
set test1;
day=day(birthday); 
label day="Regular Day function used by SAS"; 
sasday=weekday(birthday);
label sasday="Weekday Function of SAS";
new_day=sas_myweekday(birthday);
LABEL NEW_DAY="New Day Function";
run;

**************/


proc fcmp outlib = work.functions.samples;
   function sas_myweekday(mydate);
        return(weekday(mydate)-1+(weekday(mydate)=1)*7);
   endsub;
run; quit;

options cmplib=work.functions;
