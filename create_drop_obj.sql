accept user_name	CHAR prompt '      Submit username:'
accept filename		CHAR prompt 'Submit spool filename:'
@pre
spool &filename
select 'DROP '||object_type||' &user_name'||'.'||object_name||' CASCADE CONSTRAINTS;' from dba_objects where owner='&user_name' and object_type='TABLE';
select 'DROP '||object_type||' &user_name'||'.'||object_name||';' from dba_objects where owner='&user_name' and object_type='PACKAGE';
select 'DROP '||object_type||' &user_name'||'.'||object_name||';' from dba_objects where owner='&user_name' and object_type='FUNCTION';
select 'DROP '||object_type||' &user_name'||'.'||object_name||';' from dba_objects where owner='&user_name' and object_type='PROCEDURE';
select 'DROP '||object_type||' &user_name'||'.'||object_name||';' from dba_objects where owner='&user_name' and object_type='SEQUENCE';
select 'DROP '||object_type||' &user_name'||'.'||object_name||';' from dba_objects where owner='&user_name' and object_type='SYNONYM';
select 'DROP '||object_type||' &user_name'||'.'||object_name||';' from dba_objects where owner='&user_name' and object_type='VIEW';
@post
