set pages 999
col username format a25
select username, count(*) sessions from v$session where username is not null group by username;
