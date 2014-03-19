set pages 999
col username format a25
col account_status format a20
col last_seen format a19
-- select username, to_char(logon_date,'YYYY-MM-DD HH24:MI:SS') last_seen from ica_logon_history order by &1;
select u.username, u.account_status, to_char(l.logon_date,'YYYY-MM-DD HH24:MI:SS') last_seen from dba_users u, ica_logon_history l where u.username=l.username order by &1;
