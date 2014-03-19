--
--
compute sum of sizemb on report
break on report
col hn for a15 head "Server name"
col dbn for a15 head "Database Name"
set pages 999 lines 74 feedback off verify off echo on
set echo off
select	hn, dbn
from	(select	host_name hn, name dbn
	 from	v$database, v$instance
	)
/
select object_type, count(*) from user_objects group by object_type;
/
set lines 80 feedback on
