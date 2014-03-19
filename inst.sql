column host_name format a30
column instance_name format a14
select host_name, instance_name from v$instance;
