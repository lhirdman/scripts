CREATE OR REPLACE PROCEDURE TblCpRotate AS
   l_table_name VARCHAR(100) default 'devicem1';
   l_sysdate    VARCHAR(12);
BEGIN
    SELECT to_char(sysdate,'YYMMDD') INTO l_sysdate FROM dual;
      -- CREATE TABLE LIKE SOURCE TABLE
      EXECUTE IMMEDIATE 'CREATE TABLE '||l_table_name||'_'||l_sysdate||' AS SELECT * FROM '||l_table_name||';';
END TblCpRotate;
/
