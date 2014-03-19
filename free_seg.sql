select tablespace_name, bytes/1024/1024 free_space, count(bytes) segcount,
(bytes/1024/1024 * count(bytes)) totalofsegments
from dba_free_space
where tablespace_name=UPPER('&1')
group by tablespace_name, bytes
order by tablespace_name, bytes;

