select 'alter system kill session '||''''||sid||','||serial#||''''||' immediate;' KILL_SESSION from v$session where sid in (&SID_LIST);
