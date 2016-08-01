/*****************************************

<MACRO to export sas datasets to excel>
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

%SASToExcel
(ImportLibrary=, library name - all the datasets in this library will be 
exported to excel
 
ExportLocation=); export location, including excel file name

example:

%SASToExcel(ImportLibrary=results, 
ExportLocation = C:\Users\smith\Desktop\project.xlsx);

**********************/

%macro SASToExcel(ImportLibrary=, ExportLocation=);

    ods output members = _Members;
    proc datasets lib = &ImportLibrary; run; quit;

    proc sql;
        select count(Name) into :NumOfDatasets from _Members;
        select Name into :Dataset1-:Dataset%trim(%left(&NumOfDatasets)) from _Members;
    quit;

    %do index = 1 %to &NumOfDatasets;
        proc export data=&ImportLibrary..&&Dataset&index.
        outfile="&ExportLocation"
        label dbms=xlsx replace;
        sheet="&&Dataset&index";
        run;
    %end;

    proc datasets;
        delete _Memebers;
    quit;

%mend;

