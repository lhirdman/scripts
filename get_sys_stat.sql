set serveroutput on

DECLARE
 stat VARCHAR2(30);
 pbeg  DATE;
 pend  DATE;
 pval NUMBER;
BEGIN
  dbms_stats.get_system_stats(stat, pbeg, pend, 'cpuspeed' , pval);

  dbms_output.put_line(stat);
  dbms_output.put_line(TO_CHAR(pbeg, 'YY-MM-DD HH24:MI:SS'));
  dbms_output.put_line(TO_CHAR(pend, 'YY-MM-DD HH24:MI:SS'));
  dbms_output.put_line(pval);
END;
/
