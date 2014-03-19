set heading on
set pages 99 lines 74 verify off feedback off
break   on report
compute sum of MB on report
compute sum of free on report
compute sum of used on report
col name for a25 Head "Tablespace"
col MB for 999999990 Head "Size MB"
col USED for 999999990 Head "Used MB"
col FREE for 999999990 Head "Free MB"
col PCT_USED for 9990.00 Head "PCT"
col MAX_FREE for a9 Head "MaxFree"
accept tbsname char prompt ' Ange tablespace namn: ' 
select	nvl(FULL.tablespace_name,nvl(FREE.tablespace_name,'UNKNOWN')) Name
,MB_used MB
,MB_used-nvl(MB_free,0) Used
,nvl(MB_free,0)	     Free
,trunc(((MB_used-nvl(MB_free,0)) / MB_used)*100,2) Pct_used
-- ,nvl(max_free,0) Max_free
from
( select  trunc(sum(bytes)/1024/1024,0) MB_free
,trunc(max(bytes)/1024/1024,0)    max_free
 ,tablespace_name
from    sys.DBA_FREE_SPACE
group by tablespace_name ) FREE,
( select  trunc(sum(bytes)/1024/1024,0)    MB_used
,tablespace_name
from    sys.DBA_DATA_FILES
group by tablespace_name ) FULL
where  FREE.tablespace_name (+) = FULL.tablespace_name AND FREE.tablespace_name = '&tbsname'
/
