set lines 300 pages 0 feedback off trimspool on echo off
accept filename CHAR prompt 'Spool filename: '
accept filesys CHAR prompt 'File system (eg. oradata1): '
set verify off
spool &filename
select 'alter database datafile '''||file_name||''' autoextend off;' from dba_data_files where file_name like '%&filesys%' and AUTOEXTENSIBLE = 'YES';
select 'alter database tempfile '''||file_name||''' autoextend off;' from dba_temp_files where file_name like '%&filesys%' and AUTOEXTENSIBLE = 'YES';
spool off
