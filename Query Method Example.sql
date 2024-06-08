-- Query the unsigned signatures within 24 hours.

SELECT *
FROM TREATMENT_RECORD
WHERE prescriber_signature IS NULL 
  AND treatment_date < SYSDATE - 1;

SELECT *
FROM NUTRIENT_SUPPLY_PERSCRIPTION
WHERE prescriber_signature IS NULL
  AND created_at < SYSDATE - 1;