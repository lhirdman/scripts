REM $Id: generate_rename_logfile.sql,v 1.2 2010/01/08 08:33:34 oracle Exp $
REM ****************************************************
REM This PL/SQL block will return rename logfile statements
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
      save_group_no number;
      letter varchar2(2); 
      print_line varchar2(1000);
  begin
      save_group_no:=1000;
      for record in (
      select member,group# from v$logfile
      order by group#,member) loop
         if save_group_no != record.group# then
            letter:='a';
            save_group_no:=record.group#;
         end if;
         dirname := substr(record.member,1,instr(record.member,'/',-1));
         filename:= substr(record.member,instr(record.member,'/',-1)+1);
         newfilename:= replace(dirname,'&&targetdb','&&auxdb')||'&&auxdb'||'_redo'||lpad(to_char(record.group#),2,'0')||
                       letter||'.rdo';
           dbms_output.put_line('host mv '||record.member||' '||newfilename);
           dbms_output.put_line('alter database rename file '''||
                                record.member||''' to '''||
                                newfilename||
                                ''';');
        letter:=chr(ascii(letter)+1);
      end loop;
  end;
/

