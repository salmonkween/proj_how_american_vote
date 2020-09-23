Notes: Since the data file is too heavy, github did not accept the push request. 
You can find a complete raw data through this link:


1) Files contained in ANES Timeseries Cumulative Data File
   release file "anes_timeseries_cdf.zip" are the following:

   anes_timeseries_cdf_rawdata.txt		-Raw data file
 
   anes_timeseries_cdf_codebook.zip		-Codebook files
     anes_timeseries_cdf_codebook_app.txt
     anes_timeseries_cdf_codebook_int.txt
     anes_timeseries_cdf_codebook_var.txt
     anes_timeseries_cdf_codebook_app.pdf
     anes_timeseries_cdf_codebook_int.pdf
     anes_timeseries_cdf_codebook_var.pdf
 
   anes_timeseries_cdf_sas.zip			-SAS syntax files
    anes_timeseries_cdf_codelabelsassign.sas
    anes_timeseries_cdf_columns.sas
    anes_timeseries_cdf_codelabelsdefine.sas
    anes_timeseries_cdf_missingdata.sas
    anes_timeseries_cdf_run.sas
    anes_timeseries_cdf_varlabels.sas
  
   anes_timeseries_cdf_spss.zip			-SPSS syntax files
    anes_timeseries_cdf_codelabelsassign.sps
    anes_timeseries_cdf_columns.sps
    anes_timeseries_cdf_missingdata.sps
    anes_timeseries_cdf_run.sps
    anes_timeseries_cdf_varlabels.sps
  
   anes_timeseries_cdf_stata.zip		-STATA syntax files
    anes_timeseries_cdf_codelabelsassign.do
    anes_timeseries_cdf_columns.dct
    anes_timeseries_cdf_codelabelsdefine.do
    anes_timeseries_cdf_missingdata.do
    anes_timeseries_cdf_run.do
    anes_timeseries_cdf_varlabels.do 
 
 
  syntax file: _codelabelsassign    Assigns code labels to variables.
  syntax file: _columns             Defines variable column locations in raw data file.
  syntax file: _codelabelsdefine    Defines (format) code labels [SAS and STATA only]
  syntax file: _missingdata         Sets default missing data statements.
  syntax file: _varlabels           Sets variable labels.
  syntax file: _run                 Creates system data file in SAS or SPSS or STATA
                                      after being edited and submitted.


2) Note on the raw [ASCII] data file:

   The structure of the raw data file ("anes_timeseries_cdf_rawdata.txt") is 
   both fixed column and delimited (delimiter character = "|" )


3) Note on variable "Version":

   The first variable in the data is variable "Version" which describes the 
   study's release version by date of production (YYYY-Month-DD).


4) Instructions for creating a SAS, SPSS, or STATA system (data) file:

i)   The raw data file and all syntax files for the statistical software 
     in use (SAS or SPSS or STATA) must be moved to a common directory location 
     (e.g. 'C:\anes\anes_cdf\20190910\'). 
ii)  The _run syntax file must be edited to include pathname for the directory
     where the files reside. The pathname must be added in every location where
     a file from the directory is named in the _run file, for example the name 
     of the raw data file, the name of any another syntax file, or (for SPSS 
     and STATA only) the name for the output system file if it will be written
     to the same directory.
     In the SAS _run file, pathname must also be added to the libname statement. 
     Users will also need to add pathname to the first line of the STATA
     dictionary (.dct) file where the input raw data file name is indicated.
iii) Submitting the edited _run file will create the output system file for SAS/
     SPSS/STATA.
     
NOTE: In the _run file, invocation of the _missingdata syntax file which 
creates default missing data assignments is considered optional and appears 
commented out (*). Users can include the default missing data assignments 
for an output SAS/SPSS/STATA system file by removing the comment character 
from its file reference (SAS "filename" or SPSS "file handle") as well as
from its invocation statement (SAS %include or SPSS include or STATA do).
     



