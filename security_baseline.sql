REM $Id: security_baseline.sql,v 1.12 2009/12/18 07:52:49 oracle Exp $
REM Created by Rickard Waldenfeldt
REM This script collects all selecatable violations to ICA Oracle Security Baseline
REM
set pagesize 0
set linesize 200
set feedback off
set trimspool on

select 'Violation of Security baseline #10: Granted System Privileges:'||sp.grantee||' '||sp.privilege
from dba_sys_privs sp,dba_users u
WHERE sp.grantee not in ('OUTLN','TRACESVR','DIP','TSMSYS','SYS','SYSTEM','DBSNMP','ORACLE_OCM',
                         'EXFSYS','DBA','IMP_FULL_DATABASE','WMSYS','APPQOSSYS')
AND u.username=sp.grantee
AND u.profile!='ICA_DBA'
AND sp.privilege not in (select privilege from dba_sys_privs where grantee='ICA_APPL_OWNER_ROLE');

select 'Violation of Security baseline #39: Password Policy: '||a.name||' last pwd change: '||
        to_char(a.ptime,'YYYYMMDD')
from user$ a, dba_users b 
where sysdate - 335 > a.ptime 
and a.type#=1 
and a.name=b.username 
and b.profile='ICA_APPL_OWNER'
order by a.ptime;

select 'Violation of Security baseline #39: Missing ICA Profile: '||profile
from (select 'ICA_APPL_ADMIN' profile from dual
      union
      select 'ICA_APPL_OWNER' profile from dual
      union
      select 'ICA_ENDUSER' profile from dual
      union
      select 'ICA_INACTIVE_USER' profile from dual
      union
      select 'ICA_DBA' profile from dual) 
minus
select distinct 'Violation of Security baseline #39: Missing ICA Profile: '||profile 
from dba_profiles 
where profile in ('ICA_APPL_ADMIN','ICA_APPL_OWNER','ICA_ENDUSER','ICA_INACTIVE_USER','ICA_DBA');

select 'Violation of Security baseline #39: User not configured with ICA profile: '||username 
from dba_users where profile not like 'ICA%' 
and username not in ('SYSTEM','SYS','DBSNMP','SYSMAN','SCOTT','OUTLN','MDSYS','DIP',
                     'TSMSYS','WMSYS','EXFSYS','XDB','ORACLE_OCM') 
and account_status not like '%LOCK%';

select 'Violation of Security baseline #75: DBA role granted to non DBA:'||rp.grantee
from dba_role_privs rp,dba_users u
WHERE rp.grantee not in ('SYS','SYSTEM')
AND rp.granted_role='DBA'
AND u.username=rp.grantee
AND u.profile!='ICA_DBA';

select 'Violation of Security baseline #78: Grant ANY: '||grantee||' '||PRIVILEGE
from dba_sys_privs
where PRIVILEGE like '%ANY%'
and grantee not in ('DBA','IMP_FULL_DATABASE','AQ_ADMINISTRATOR_ROLE','DBSNMP','EXP_FULL_DATABASE',
                    'DATAPUMP_IMP_FULL_DATABASE','EXFSYS',
                    'OEM_MONITOR','OUTLN','SCHEDULER_ADMIN','SYS','SYSTEM','TRACESVR','SYSMAN',
                    'JAVADEBUGPRIV','WMSYS','ORACLE_OCM','DBA_READ_ONLY_ROLE')
minus --SELECT ANY DICTIONARY OK for APPL admins
select 'Violation of Security baseline #78: Grant ANY: '||grantee||' '||PRIVILEGE
from dba_sys_privs
where privilege='SELECT ANY DICTIONARY'
and grantee in (select username from dba_users where profile='ICA_APPL_ADMIN');

select 'Violation of Security baseline #86: ALTER USER: '||grantee
from dba_sys_privs
where PRIVILEGE='ALTER USER'
and grantee not in ('WMSYS','DBA','SYS','SYSTEM','IMP_FULL_DATABASE','DATAPUMP_IMP_FULL_DATABASE')
union
select 'Violation of Security baseline #86: ALTER PROFILE: '||grantee
from dba_sys_privs
where PRIVILEGE='ALTER PROFILE'
and grantee not in ('DBA','SYS','SYSTEM','IMP_FULL_DATABASE','DATAPUMP_IMP_FULL_DATABASE');

select 'Violation of Security baseline #103: PUBLIC Database Link: '||DB_LINK
from dba_db_links
where owner='PUBLIC';

select 'User never logged in: '||username
 from dba_users where username not in (select username from ICA_LOGON_HISTORY)
 and username not in ('EXFSYS','WMSYS','OUTLN','TRACESVR','DIP','TSMSYS','SYS','SYSTEM','ORACLE_OCM','FULL_EXP_USER')
 and PROFILE != 'ICA_DBA'
union  
select 'NOTE!! the site policy is not known. Check time before acting upon alert on #148'
from dual
union
select 'Violation of Security baseline #148: Expired or inactivity: Inactive:'||username 
from dba_users where username in (select username from ICA_LOGON_HISTORY
where logon_date < sysdate-365)
and username not in ('EXFSYS','WMSYS','OUTLN','TRACESVR','DIP','TSMSYS','SYS','SYSTEM','ORACLE_OCM','FULL_EXP_USER')
union
select 'Violation of Security baseline #148: Expired or inactivity: Expired:'||username
from dba_users where expiry_date < sysdate-365
and username not in ('EXFSYS','WMSYS','OUTLN','TRACESVR','DIP','TSMSYS','SYS','SYSTEM','ORACLE_OCM','FULL_EXP_USER')
union
select 'Violation of Security baseline #148: Expired or inactivity: Expired:'||username
from dba_users where lock_date < sysdate-365
and account_status='EXPIRED '||chr(38)||' LOCKED'
and username not in ('EXFSYS','WMSYS','OUTLN','TRACESVR','DIP','TSMSYS','SYS','SYSTEM','ORACLE_OCM','FULL_EXP_USER');

select decode(value,null,null,'Violation of Security baseline #186: UTL_FILE_DIR: '||value) 
from V_$PARAMETER where name='utl_file_dir';

select 'Violation of Security baseline #192: CREATE LIBRARY: '||grantee 
from dba_sys_privs 
where PRIVILEGE like 'CREATE%LIBRARY'
and grantee not in ('DBA','IMP_FULL_DATABASE','SYS','EXFSYS');

select 'Violation of Security baseline #193: Execute on Critical SYS packages: '||GRANTEE||' '||TABLE_NAME  
from DBA_TAB_PRIVS 
where owner='SYS' 
and PRIVILEGE='EXECUTE' 
and TABLE_NAME in ('DBMS_SYS_SQL','UTL_INADDR','DBMS_BACKUP_RESTORE','DBMS_OBFUSCATION_TOOLKIT',
                   'DBMS_EXPORT_EXTENTION','DBMS_LDAP')
and GRANTEE NOT IN ('SYSTEM','ORACLE_OCM','WMSYS','DBSNMP','PUBLIC') --PUBLIC checked in #230
;

select 'Violation of Security baseline #221: Role to PUBLIC: '||granted_role
from dba_role_privs
where grantee='PUBLIC';

select 'Violation of Security baseline #227: ALTER, INDEX: '||GRANTEE||' has '||PRIVILEGE||
       ' on '||OWNER||'.'||TABLE_NAME 
from DBA_TAB_PRIVS 
where PRIVILEGE in ('ALTER','INDEX')
and grantee not in ('SYS','DBA','SYSTEM');

select 'Violation of Security baseline #228: REFERENCES: '||TP.GRANTEE||' has '||TP.PRIVILEGE||
       ' on '||TP.OWNER||'.'||TP.TABLE_NAME 
from DBA_TAB_PRIVS TP
where TP.PRIVILEGE in ('REFERENCES')
and TP.grantee not in (select U.username from DBA_USERS U where profile='ICA_APPL_OWNER')
and TP.grantee not in ('SYS','DBA','SYSTEM');

select 'Violation of Security baseline #229: OBJ privs to PUBLIC: '||PRIVILEGE||' on '||OWNER||'.'||TABLE_NAME
from dba_tab_privs
where grantee='PUBLIC'
and owner not in ('SYS','SYSTEM','WMSYS','EXFSYS') --Checked elsewhere (not EXFSYS)
;

select 'Violation of Security baseline #230: EXEC on PROC: '||GRANTEE||' has '||PRIVILEGE||
       ' on '||OWNER||'.'||TABLE_NAME  
from DBA_TAB_PRIVS 
where owner='SYS' 
and PRIVILEGE='EXECUTE' 
and grantee='PUBLIC'
and TABLE_NAME in ('UTL_SMTP','UTL_TCP','UTL_HTTP','UTL_FILE','UTL_INADDR','DBMS_RANDOM','DBMS_LOB','DBMS_SQL','DBMS_JOB',
                 'DBMS_BACKUP_RESTORE','DBMS_OBFUSCATION_TOOLKIT','DBMS_EXPORT_EXTENTION','DBMS_LDAP','DBMS_ADVISOR');

select 'Violation of Security baseline #232: ADMIN OPTION: '||grantee||' on '||PRIVILEGE
from dba_sys_privs 
where ADMIN_OPTION='YES'
and grantee not in ('DBA','SYS','AQ_ADMINISTRATOR_ROLE','SCHEDULER_ADMIN','SYSTEM','WMSYS');

select 'Violation of Security baseline #233: GRANT OPTION: '||TP.GRANTEE||' has grantable=YES'||
       ' on '||TP.OWNER||'.'||TP.TABLE_NAME 
from DBA_TAB_PRIVS TP
where TP.GRANTABLE='YES'
and TP.grantee not in (select U.username from DBA_USERS U where profile='ICA_APPL_OWNER')
and TP.grantee not in ('SYS','DBA','SYSTEM')
and owner not in ('SYS','SYSTEM','WMSYS') --Checked elsewhere
;

select 'Violation of Security baseline #234: ADMIN OPTION: '||grantee||' on '||granted_role
from dba_role_privs
where ADMIN_OPTION='YES'
and granted_role
in ('CONNECT','RESOURCE','DBA','SELECT_CATALOG_ROLE','EXECUTE_CATALOG_ROLE','DELETE_CATALOG_ROLE',
    'EXP_FULL_DATABASE','IMP_FULL_DATABASE','RECOVERY_CATALOG_OWNER','GATHER_SYSTEM_STATISTICS',
    'LOGSTDBY_ADMINISTRATOR','AQ_USER_ROLE','GLOBAL_AQ_USER_ROLE','SCHEDULER_ADMIN',
    'HS_ADMIN_ROLE','OEM_ADVISOR','OEM_MONITOR','WM_ADMIN_ROLE', 
    'LOGSTDBY_ADMINISTRATOR','AQ_USER_ROLE','DATAPUMP_EXP_FULL_DATABASE','DATAPUMP_IMP_FULL_DATABASE',
    'JAVAUSERPRIV','JAVAIDPRIV','JAVASYSPRIV','JAVADEBUGPRIV','EJBCLIENT','JMXSERVER','JAVA_ADMIN',
    'JAVA_DEPLOY','ICA_TOAD_ROLE','ICA_ENDUSER_ROLE','ICA_APPL_OWNER_ROLE',
    'ICA_APPL_ADMIN_ROLE',
    'DBA_READ_ONLY_ROLE') -- not in list: AQ_ADMINISTRATOR_ROLE
    -- list is 11g and ICA aware
and grantee not in ('DBA','SYS','SYSTEM','WMSYS');

select 'Violation of Security baseline #235: ADMIN OPTION: '||grantee||' on '||granted_role
from dba_role_privs
where ADMIN_OPTION='YES'
and grantee not in (select username from DBA_USERS where profile='ICA_APPL_ADMIN' or profile='ICA_DBA')
and grantee not in ('SYS','DBA','SYSTEM','WMSYS');

select 'Violation of Security baseline #270: ALTER SYSTEM: '||grantee
from dba_sys_privs 
where PRIVILEGE='ALTER SYSTEM'
and grantee not in ('DBA','SYS','SYSTEM');

select 'Violation of Security baseline #273: PUBLIC ACCESS TO SYS.ALL_USERS  '
from DBA_TAB_PRIVS 
where owner='SYS'  
and grantee='PUBLIC'
and TABLE_NAME='ALL_USERS';

REM Is this really relevant???
REM select 'Violation of Security baseline #274: PUBLIC ACCESS TO SYS.ALL_% : '||table_name
REM from DBA_TAB_PRIVS 
REM where owner='SYS'  
REM and grantee='PUBLIC'
REM and TABLE_NAME like 'ALL_%';

select 'Violation of Security baseline #297: Database NOT in archivelog mode'
from v$database
where log_mode='NOARCHIVELOG';
