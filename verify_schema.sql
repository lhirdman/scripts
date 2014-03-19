-- Mikael Bergman 2002-09-18 
-- Verfiering av nytt databa-schema. Bilaga till checklista I-ORACLE_new_schema.
-- Peter Lundqvist, Infogrator Stockholm AB; Modifications.

SET VER OFF
SET TIM OFF
SET PAGES 50
SET LINES 100
col "Max quota" format a10

prompt ********************************************
prompt       Verification of created schema
prompt ********************************************
prompt

select to_char(sysdate,'yyyy-mm-dd hh24:mi:ss') Datum from dual;

-- Ange invarden
-- ACCEPT ch           CHAR prompt '  Ange change number:'
ACCEPT db_tb_name   CHAR PROMPT 'Ange tablespace-name:' 
ACCEPT db_user_name CHAR PROMPT '            username:'
ACCEPT Password     CHAR PROMPT '            password:'    
ACCEPT db_database  CHAR PROMPT '             databas:' 

-- spool Z:\Checklists\verify_schema_&ch..txt

prompt
prompt ********
prompt Database
prompt ********
select name from v$database;

prompt *************************
PROMPT Size of tabelspace (MB)
prompt *************************
SELECT SUBSTR(tablespace_name,1,20)"Tablespace name",
ROUND(SUM(bytes/1024/1024),1) "MB"
FROM sys.dba_data_files
WHERE tablespace_name= upper('&db_tb_name')
GROUP BY tablespace_name
/
prompt *************************
prompt Schema default tablespace
prompt *************************
SELECT SUBSTR(username,1,20) "User name", to_char(created,'YYYY-MM-DD HH24.MI.SS') "Created",
SUBSTR(default_tablespace,1,20) "Default tablespace"
FROM sys.dba_users
WHERE username=UPPER('&db_user_name')
/
prompt *************************
PROMPT Role privileges
prompt *************************
SELECT SUBSTR(GRANTEE,1,15) "Schema owner",SUBSTR(GRANTED_ROLE,1,15) "Role granted",
ADMIN_OPTION,DEFAULT_ROLE
FROM sys.dba_role_privs
WHERE grantee=UPPER('&db_user_name')
/
prompt *************************
PROMPT Tablespace quotas (Bytes)
prompt *************************
SELECT SUBSTR(username,1,20) "Schema",SUBSTR(tablespace_name,1,20) "Tablespace name", bytes "Size consumed",decode(max_bytes,-1,'Unlimited', max_bytes) "Max quota"
  FROM sys.dba_ts_quotas
 WHERE username=UPPER('&db_user_name')
/
prompt **************************
PROMPT Logging on as '&db_user_name'
prompt **************************

connect &db_user_name/&password@&db_database;
show user

disconnect;

spool off;
