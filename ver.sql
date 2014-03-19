--
--
compute sum of sizemb on report
break on report
col hn for a15 head "Server name"
col dbn for a20 head "Database name"
col dat for a15 head "Date"
col file_name for a60
col sizemb for 999,999,990
set pages 999 lines 74 feedback off verify off echo on
accept chgno
accept tbsname
set echo off
-- spool \\sesofp05-14\home26$\kpfd533\Checklists\verify_&chgno..txt
prompt .
prompt .
select	hn, dbn, dat
from	(select	host_name hn, name dbn, sysdate dat
	 from	v$database, v$instance, dual
	)
/
prompt .
prompt .
prompt Files in tablespace &tbsname
select file_name,bytes/1024/1024 sizemb
from dba_data_files
where tablespace_name=upper('&tbsname')
order by 1;
spool off
