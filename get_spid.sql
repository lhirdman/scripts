set pages 999 lines 300
column machine format a26
column osuser format a9
column program format a25
column event format a20
column last_call_et format 99999
column sid format 99999
column serial# format 99999
column spid format a6
ACCEPT schema_name CHAR PROMPT 'Which user: '
select s.machine,s.program, s.osuser, s.last_call_et, s.sid, s.serial#, p.spid, s.event from v$session s, v$process p where s.paddr=p.addr and s.username='&schema_name';
