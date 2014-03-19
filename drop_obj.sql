REM Generate script dropping objects by owner
set heading off
set feedback off
spool dropobj_x.sql
-- select 'alter system set recyclebin=off scope=memory;' from dual;
select 'drop '||object_type||' '||owner||'."'||object_name||'" cascade constraints ;'
from dba_objects where owner in (
'OBJECTIVE'
)
and object_type = 'TABLE'
order by created;
select 'drop '||object_type||' '||owner||'."'||object_name||'" ;'
from dba_objects where owner in (
'OBJECTIVE'
)
and object_type <> 'INDEX'
and object_type <> 'DATABASE LINK'
and object_type <> 'PACKAGE BODY'
and object_type <> 'TRIGGER'
and object_type <> 'LOB'
and object_type <> 'TABLE'
and object_type <> 'TABLE PARTITION'
order by created;
-- select 'alter system set recyclebin=on scope=memory;' from dual;
spool off 
set heading on
set feedback on

