set pages 999
col owner format a12
col directory_name format a24
col directory_path format a36
select owner, directory_name, directory_path from dba_directories order by 1;
