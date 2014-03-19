-- First run:
-- select segment_name from dba_lobs where table_name='<TABLE_NAME>';
-- Then use result in the following
set pages 99 lines 74
break on report
compute sum of MBytes on report
col object_name for a25 Head "Object Name"
col MBytes for 999999.00 Head "Used MB"
select  distinct segment_name object_name, sum(bytes/1024/1024) MBytes from dba_segments where segment_name IN ('SYS_LOB0000050979C00004$$','SYS_LOB0000060565C00004$$','SYS_LOB0000064629C00004$$') group by segment_name
/
