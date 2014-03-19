SET pages 0 lines 200 feedback off trimspool on
spool &1
SELECT 'ALTER DATABASE RENAME FILE '''||filename||''' TO '''||replace(filename,'oradata1','oradata2')||''';'
from
(
select file_name as filename from dba_data_files
union
select file_name as filename from dba_temp_files
)
/
spool off
spool &2
SELECT 'mv -i'||filename||' '||replace(filename,'oradata1','oradata2') from
(
select file_name as filename from dba_data_files
union
select file_name as filename from dba_temp_files
)
/
spool off

