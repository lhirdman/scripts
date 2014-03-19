--
--
col hn for a15 head "Server name"
col dbn for a15 head "Database Name"
col obn for a40 head "Object Name"
col obt for a20 head "Object Type"
set pages 9999 lines 99 feedback off verify off echo on
set echo off
select	hn, dbn
from	(select	host_name hn, name dbn
	 from	v$database, v$instance
	)
/
select object_type, count(*) from user_objects group by object_type;
select object_name obn, object_type obt from user_objects order by object_type, object_name;
set lines 80 feedback on
