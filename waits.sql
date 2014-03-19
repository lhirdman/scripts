set pages 999
col username format a14
col event format a60
col wait_class format a14
col status format a9
col logon format a19
col l_call format 9999999
select username, LAST_CALL_ET l_call, status, wait_class, event from v$session where username is not null order by &1;
