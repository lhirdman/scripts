set pages 999
col comp_name format a40
col version format a12
col status format a12
select comp_name, version, status from dba_registry;
