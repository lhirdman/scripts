set pages 999
col username format a14
col machine format a14
col osuser format a10
col status format a9
col logon format a19
col l_call format 9999999
select username, machine, osuser, LAST_CALL_ET l_call, status, to_char(LOGON_TIME,'YYYY-MM-DD HH24:MI:SS') logon from v$session where username is not null order by &1;
