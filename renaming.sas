/*****************************************

<MACRO to rename variables>
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

%rename2(
oldvarlist=, 
suffix=);

Variable Names:

oldvarlist = include all the variables for which you want assign new labels
Don't use commas

suffix = include one common suffix to be used in the new labels

example:
%rename2(oldvarlist=saleq aqt,suffix=firm);

************************/


%macro rename2(oldvarlist, suffix);
  %let k=1;
  %let old = %scan(&oldvarlist, &k);
     %do %while("&old" NE "");
      rename &old = &old.&suffix;
	  %let k = %eval(&k + 1);
      %let old = %scan(&oldvarlist, &k);
  %end;
%mend;
