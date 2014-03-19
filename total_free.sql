--
--
-- col tbs for a20 head "Tablespace"
col szmb for a25 head "Total size (MB)"
col freemb for a25 head "Free size (MB)"
set pages 999 lines 74 feedback off verify off echo off
accept tbsname	char prompt ' Ange tablespace namn: '

select trunc(sum(bytes)/1024/1024) szmb
from dba_data_files
where tablespace_name = upper('&tbsname');

select trunc(sum(bytes)/1024/1024) freemb 
from dba_free_space
where tablespace_name = upper('&tbsname');
