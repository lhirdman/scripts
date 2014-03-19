REM $Id: generate_rename_datafile.sql,v 1.1 2009/11/16 14:20:44 oracle Exp $
REM ****************************************************
REM This PL/SQL block will return rename file statements
REM according to standard filename format
REM ****************************************************
set linesize 300
set trimspool on
set serveroutput on
set verify off
set pagesize 0
set feedback off

declare
      dirname varchar2(200);
      filename varchar2(200);
      newfilename varchar2(200);
      save_tablespace_name varchar2(200);
      counter number; 
      print_line varchar2(1000);
begin
      counter:=1;
      save_tablespace_name:='namethatdefinitelyneverwillmatchanytsname';
      for record in (
      select file_name, tablespace_name, file_id from dba_data_files
      union
      select file_name, tablespace_name, file_id from dba_temp_files
      order by 2,3) loop
         if save_tablespace_name != record.tablespace_name then
            counter:=1;
            save_tablespace_name:=record.tablespace_name;
         end if;
         dirname := substr(record.file_name,1,instr(record.file_name,'/',-1));
         filename:= substr(record.file_name,instr(record.file_name,'/',-1)+1);
         newfilename:= replace(dirname,'&&targetdb','&&auxdb')||'&&auxdb'||'_'||lower(record.tablespace_name)||
                       '_'||lpad(to_char(counter),2,'0')||'.dbf';
           dbms_output.put_line('host mv '||record.file_name||' '||newfilename);
           dbms_output.put_line('alter database rename file '''||
                                record.file_name||''' to '''||
                                newfilename||
                                ''';');
           
         counter:= counter+1;
      end loop;
end;
/

