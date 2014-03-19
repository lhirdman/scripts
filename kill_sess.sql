select 'alter system kill session '||''''||sid||','||serial#||''''||' immediate;' KILL_SESSION from v$session where username='&username';
