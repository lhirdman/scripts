--
--
compute sum of sizemb on report
break on report
col hn for a15 head "Server name"
col dbn for a15 head "Database Name"
col username for a10
col password for a18
col account_status for a20
col def_tbl for a10
col profile for a10
set pages 999 lines 74 feedback off verify off
accept usernm char prompt "Username: "
select	hn, dbn
from	(select	host_name hn, name dbn
	 from	v$database, v$instance
	)
/
select username, account_status, default_tablespace def_tbl, profile, password
from dba_users
where username=upper('&usernm')
order by 1
/
set lines 80 feedback on
