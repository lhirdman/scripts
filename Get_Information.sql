-- $ sqlplus -m "html on" "sys/password@dbAlias as sysdba" @Get_Information.sql > result.html

-- Get Oracle version information
select * from v$version;

-- Get Oracle parameters
select name, value from v$parameter order by name;

-- Get log switch frequency map
SELECT  trunc(first_time) "Date",
        to_char(first_time, 'Dy') "Day",
        count(1) "Total",
        SUM(decode(to_char(first_time, 'hh24'),'00',1,0)) "h0",
        SUM(decode(to_char(first_time, 'hh24'),'01',1,0)) "h1",
        SUM(decode(to_char(first_time, 'hh24'),'02',1,0)) "h2",
        SUM(decode(to_char(first_time, 'hh24'),'03',1,0)) "h3",
        SUM(decode(to_char(first_time, 'hh24'),'04',1,0)) "h4",
        SUM(decode(to_char(first_time, 'hh24'),'05',1,0)) "h5",
        SUM(decode(to_char(first_time, 'hh24'),'06',1,0)) "h6",
        SUM(decode(to_char(first_time, 'hh24'),'07',1,0)) "h7",
        SUM(decode(to_char(first_time, 'hh24'),'08',1,0)) "h8",
        SUM(decode(to_char(first_time, 'hh24'),'09',1,0)) "h9",
        SUM(decode(to_char(first_time, 'hh24'),'10',1,0)) "h10",
        SUM(decode(to_char(first_time, 'hh24'),'11',1,0)) "h11",
        SUM(decode(to_char(first_time, 'hh24'),'12',1,0)) "h12",
        SUM(decode(to_char(first_time, 'hh24'),'13',1,0)) "h13",
        SUM(decode(to_char(first_time, 'hh24'),'14',1,0)) "h14",
        SUM(decode(to_char(first_time, 'hh24'),'15',1,0)) "h15",
        SUM(decode(to_char(first_time, 'hh24'),'16',1,0)) "h16",
        SUM(decode(to_char(first_time, 'hh24'),'17',1,0)) "h17",
        SUM(decode(to_char(first_time, 'hh24'),'18',1,0)) "h18",
        SUM(decode(to_char(first_time, 'hh24'),'19',1,0)) "h19",
        SUM(decode(to_char(first_time, 'hh24'),'20',1,0)) "h20",
        SUM(decode(to_char(first_time, 'hh24'),'21',1,0)) "h21",
        SUM(decode(to_char(first_time, 'hh24'),'22',1,0)) "h22",
        SUM(decode(to_char(first_time, 'hh24'),'23',1,0)) "h23"
FROM    V$log_history
group by trunc(first_time), to_char(first_time, 'Dy')
Order by 1;

-- Get tablespaces
select /*+ RULE */ a.tablespace_name,
       round(a.bytes_alloc / 1024 / 1024, 2) megs_alloc,
       round(nvl(b.bytes_free, 0) / 1024 / 1024, 2) megs_free,
       round((a.bytes_alloc - nvl(b.bytes_free, 0)) / 1024 / 1024, 2) megs_used,
       round((nvl(b.bytes_free, 0) / a.bytes_alloc) * 100,2) Pct_Free,
       100 - round((nvl(b.bytes_free, 0) / a.bytes_alloc) * 100,2) Pct_used,
       round(maxbytes/1048576,2) Max
from  ( select /*+ RULE */ f.tablespace_name,
               sum(f.bytes) bytes_alloc,
               sum(decode(f.autoextensible, 'YES',f.maxbytes,'NO', f.bytes)) maxbytes
        from dba_data_files f
        group by tablespace_name) a,
      ( select /*+ RULE */ f.tablespace_name,
               sum(f.bytes)  bytes_free
        from dba_free_space f
        group by tablespace_name) b
where a.tablespace_name = b.tablespace_name (+)
union
select /*+ RULE */ tablespace_name,
       round(sum(bytes_used + bytes_free) / 1048576, 2),
       round(sum(bytes_free) / 1048576,2),
       round(sum(bytes_used) / 1048576,2),
       round((sum(bytes_free) / sum(bytes_used + bytes_free)) * 100,2) Pct_Free,
       100 - round((sum(bytes_free) / sum(bytes_used + bytes_free)) * 100,2) Pct_used,
       round(max(bytes_used + bytes_free) / 1048576, 2)
from   sys.v_$TEMP_SPACE_HEADER
group by tablespace_name
ORDER BY 1;

-- Get datafiles
Select /*+ RULE */ t.tablespace_name  "Tablespace",
 t.status "Status",  
 ROUND((MAX(d.bytes)/1024/1024) - (SUM(decode(f.bytes, NULL,0, f.bytes))/1024/1024),2) "Used MB", 
 ROUND(SUM(decode(f.bytes, NULL,0, f.bytes))/1024/1024,2) "Free MB" , 
 t.initial_extent "Initial Extent",   
 t.next_extent "Next Extent",  
 t.min_extents "Min Extents", 
 t.max_extents "Max Extents", 
 t.pct_increase "Pct Increase" 
 , SUBSTR(d.file_name,1,80) "Datafile name" 
FROM DBA_FREE_SPACE f , DBA_DATA_FILES d , DBA_TABLESPACES t 
WHERE t.tablespace_name = d.tablespace_name  
 AND f.tablespace_name(+) = d.tablespace_name  
 AND f.file_id(+) = d.file_id
GROUP BY t.tablespace_name , 
 d.file_name , 
 t.initial_extent ,  
 t.next_extent , 
 t.min_extents , 
 t.max_extents ,  
 t.pct_increase , t.status   
 ORDER BY 1,3 DESC;

-- Get free space fragmentation
Select /*+ RULE */ tablespace_name,  count(bytes) "Pieces"
, to_char(min(bytes) / 1024            , '999,999,999') "Min"
, to_char(round(avg(bytes) ,0) / 1024  , '999,999,999') "Average"
, to_char(max(bytes) / 1024            , '999,999,999') "Max"
, to_char(sum(bytes) / 1024            , '999,999,999') "Total"
from sys.dba_free_space
group by tablespace_name;

-- Get wait statistics
select * from v$system_event;

-- Get latch statistics
select * from v$latch;

-- Get system statistics
select * from v$sysstat;

-- Get SGA stats
select * from v$sgastat;

-- Get control file info
SELECT INITCAP(TYPE), record_size, records_total, records_used, 
(record_size*records_used) "Used", 
record_size*(records_total-records_used) "Free" 
 FROM V$CONTROLFILE_RECORD_SECTION ORDER BY 1;
 
-- Get rollback stats
select * from v$rollstat; 

select * from v$undostat;

-- Get library cache stats
select * from v$librarycache;


-- Get some info about recent sql
-- select * from v$sql_plan_statistics_all;

-- select * from v$rowcache;


SELECT ses.sid
, DECODE(ses.action,NULL,'online','batch') "User"
, MAX(DECODE(sta.statistic#,9,sta.value,0))
/greatest(3600*24*(sysdate-ses.logon_time),1) "Log IO/s"
, MAX(DECODE(sta.statistic#,40,sta.value,0))
/greatest(3600*24*(sysdate-ses.logon_time),1) "Phy IO/s"
, 60*24*(sysdate-ses.logon_time) "Minutes"
FROM V$SESSION ses
, V$SESSTAT sta
WHERE ses.status = 'ACTIVE'
AND sta.sid = ses.sid
AND sta.statistic# IN (9,40)
GROUP BY ses.sid, ses.action, ses.logon_time
ORDER BY
SUM( DECODE(sta.statistic#,40,100*sta.value,sta.value) )
/ greatest(3600*24*(sysdate-ses.logon_time),1) DESC;

SELECT b.SID c1, DECODE(b.username,NULL,c.NAME,b.username) c2, 
       a.event c3, a.total_waits c4, ROUND((a.time_waited / 100),2) c5, 
       a.total_timeouts c6, ROUND((average_wait / 100),2) c7, 
       ROUND((a.max_wait / 100),2) c8 
 FROM sys.v_$session_event a, sys.v_$session b, sys.v_$bgprocess c 
WHERE a.event NOT LIKE 'DFS%' 
  AND a.event NOT LIKE 'KXFX%' 
  AND a.SID = b.SID 
  AND b.paddr = c.paddr (+) 
  AND a.event NOT IN ( 'lock element cleanup', 'pmon timer', 'rdbms ipc message', 
                     'smon timer', 'SQL*Net message from client', 'SQL*Net break/reset to client', 
                     'SQL*Net message to client', 'SQL*Net more data to client', 
                     'dispatcher timer', 'Null event', 'io done', 'parallel query dequeue wait', 
                     'parallel query idle wait - Slaves', 'pipe get', 'PL/SQL lock timer', 
                     'slave wait', 'virtual circuit status', 'WMON goes to sleep' 
                   ) 
ORDER BY 4 DESC ;

select * from v$waitstat;

select * from v$tempstat;

select * from v_$buffer_pool_statistics;

-- Get advice for shared pool
select * from v$shared_pool_advice;

select * from v$db_cache_advice;

select * from v$pga_target_advice;


exit;
