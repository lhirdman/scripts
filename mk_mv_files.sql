SET LINES 200 PAGES 0 FEEDBACK off VERIFY off TRIMSPOOL on

accept new_sid char prompt ' New SID uppercase: '
accept old_sid char prompt ' Old SID lowercase: '

SPOOL move_files_&new_sid..sql
 
select 'ALTER DATABASE RENAME FILE '''||filename||''' TO '''||
replace(lower(filename),'&old_sid','&new_sid')||''';'
from (
	SELECT file_name AS filename FROM dba_data_files
	UNION
	SELECT file_name AS filename FROM dba_temp_files
	UNION
	SELECT member AS filename FROM v$logfile
)
/
spool off
exit;
