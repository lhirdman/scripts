DECLARE
    PROCEDURE dropAll (inUser VARCHAR2)
    IS
    lSQL VARCHAR2(200);
        CURSOR constr_cur IS
           SELECT table_name, constraint_name FROM DBA_CONSTRAINTS
           WHERE owner = inUser
           AND constraint_type ='R';
       CURSOR obj_cur IS
          SELECT object_type, object_name FROM DBA_OBJECTS
          WHERE owner = inUser;
       CURSOR pubsyn_cur IS
          SELECT synonym_name
          FROM DBA_SYNONYMS 
          WHERE OWNER = 'PUBLIC' AND TABLE_OWNER = inUser;
BEGIN
FOR l IN constr_cur
LOOP
    EXECUTE IMMEDIATE 'ALTER TABLE ' || inUser || '.' || l.table_name 
                      || ' DROP CONSTRAINT ' || l.constraint_name; 
END LOOP;
FOR l IN obj_cur
LOOP
 IF l.object_type = 'SYNONYM' THEN
    EXECUTE IMMEDIATE 'DROP SYNONYM ' || inUser || '.' || l.object_name;
 ELSIF l.object_type = 'TABLE' THEN
    EXECUTE IMMEDIATE 'DROP TABLE ' || inUser || '.' || l.object_name;
 ELSIF l.object_type = 'SEQUENCE' THEN
    EXECUTE IMMEDIATE 'DROP SEQUENCE ' || inUser || '.' || l.object_name;
 ELSIF l.object_type = 'FUNCTION' THEN
    EXECUTE IMMEDIATE 'DROP FUNCTION ' || inUser || '.' || l.object_name;
 ELSIF l.object_type = 'PROCEDURE' THEN
    EXECUTE IMMEDIATE 'DROP PROCEDURE ' || inUser || '.' || l.object_name;
 ELSIF l.object_type = 'PACKAGE' THEN
    EXECUTE IMMEDIATE 'DROP PACKAGE ' || inUser || '.' || l.object_name;
 ELSIF l.object_type = 'VIEW' THEN
    EXECUTE IMMEDIATE 'DROP VIEW ' || inUser || '.' || l.object_name;
 ELSIF l.object_type = 'TYPE' THEN
  BEGIN
    EXECUTE IMMEDIATE 'DROP TYPE ' || inUser || '.' || l.object_name;
 EXCEPTION
  WHEN OTHERS THEN NULL;
 END;
 END IF;
END LOOP;
FOR l IN pubsyn_cur
LOOP
   EXECUTE IMMEDIATE 'DROP PUBLIC SYNONYM ' || l.synonym_name;
END LOOP;
END;
BEGIN
-- dropAll('TIFIC');
-- dropAll('NNM');
-- dropAll('CLAIMS');
-- dropAll('CLAIMS_USER');
-- dropAll('SE');
-- dropAll('SE_USER');
-- dropAll('SYSMAN');
-- dropAll('SCADMIN');
-- dropAll('TKADMIN');
-- dropAll('BOADMIN');
-- dropAll('UNIX_DEVICE_READ');
-- dropAll('SCREPORT');
-- dropAll('IWH_USER');
-- dropAll('JIRA');
-- dropAll('CONFLUENCE');
dropAll('ICANO');
END;
/
