-- Disable foreign key constraints
ALTER SESSION SET CONSTRAINT = DEFERRED;

-- Drop tables (only those in your schema)
BEGIN
  FOR t IN (SELECT table_name FROM user_tables) LOOP
    EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS';
  END LOOP;
END;
/

-- Drop user-created sequences (try with OWNER)
BEGIN
  FOR s IN (SELECT sequence_name FROM user_sequences WHERE OWNER = user) LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE ' || s.sequence_name;
  END LOOP;
END;
/

-- Re-enable foreign key constraints 
ALTER SESSION SET CONSTRAINT = IMMEDIATE;

COMMIT; 

--- Kill all the non-systematic tables

BEGIN
    FOR rec IN (SELECT object_name, object_type
                FROM all_objects
                WHERE owner NOT IN ('SYS', 'SYSTEM')    
                AND object_type = 'TABLE')               
    LOOP
        BEGIN
            EXECUTE IMMEDIATE 'DROP TABLE "' || rec.object_name || '" CASCADE CONSTRAINTS';
        EXCEPTION
            WHEN OTHERS THEN
                IF SQLCODE = -942 THEN
                    NULL; 
                ELSE
                    RAISE;
                END IF;
        END;
    END LOOP;
END;
/