create user s_nq_sched
identified by skidoo23
default tablespace users
temporary tablespace temp
quota unlimited on users
/

grant connect
, create table
, create view
, create procedure
to s_nq_sched
/
