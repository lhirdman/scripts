REM $Id: revoke_baseline.sql,v 1.5 2009/04/15 12:15:08 oracle Exp $
revoke index on SYSTEM.PLAN_TABLE from public;
revoke ALTER on SYSTEM.PLAN_TABLE from public;
revoke REFERENCES on SYSTEM.PLAN_TABLE from public;
revoke execute on SYS.DBMS_ADVISOR from public;
revoke execute on SYS.DBMS_JOB from public;
revoke execute on SYS.DBMS_LDAP from public;
revoke execute on SYS.DBMS_LOB from public;
revoke execute on SYS.DBMS_OBFUSCATION_TOOLKIT from public;
revoke execute on SYS.DBMS_RANDOM from public;
revoke execute on SYS.DBMS_SQL from public;
revoke execute on SYS.UTL_FILE from public;
revoke execute on SYS.UTL_HTTP from public;
revoke execute on SYS.UTL_INADDR from public;
revoke execute on SYS.UTL_SMTP from public;
revoke execute on SYS.UTL_TCP from public;
revoke select on SYS.ALL_USERS from public;
grant execute on SYS.DBMS_SQL to system;
grant execute on SYS.DBMS_JOB to dbsnmp;
grant execute on SYS.DBMS_OBFUSCATION_TOOLKIT to dbsnmp;
grant select on all_objects to WMSYS;
grant execute on SYS.UTL_FILE to WMSYS;
grant execute on SYS.DBMS_SQL to WMSYS;
PROMPT ORACLE_OCM is a new schema in 10.2.0.4 which by default uses som public grants
grant execute on UTL_FILE to oracle_ocm;
grant execute on DBMS_SCHEDULER to oracle_ocm;
grant execute on sys.dbms_sql to oracle_ocm;
grant execute on sys.dbms_sql to exfsys;
grant execute on sys.dbms_lob to exfsys;
grant select on sys.all_users to exfsys;


