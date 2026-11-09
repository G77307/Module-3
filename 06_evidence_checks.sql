-- Gabriel-Adrian Bunea - final evidence checks

USE crownfield_eye_hospital;

SELECT 'patient' AS table_name, COUNT(*) AS row_count FROM patient
UNION ALL SELECT 'clinician', COUNT(*) FROM clinician
UNION ALL SELECT 'clinic', COUNT(*) FROM clinic
UNION ALL SELECT 'medicine', COUNT(*) FROM medicine
UNION ALL SELECT 'appointment', COUNT(*) FROM appointment
UNION ALL SELECT 'diagnosis', COUNT(*) FROM diagnosis
UNION ALL SELECT 'followup_plan', COUNT(*) FROM followup_plan
UNION ALL SELECT 'prescription', COUNT(*) FROM prescription
UNION ALL SELECT 'prescription_item', COUNT(*) FROM prescription_item;

SELECT TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'crownfield_eye_hospital'
ORDER BY TABLE_NAME, CONSTRAINT_TYPE, CONSTRAINT_NAME;

SHOW PROCEDURE STATUS
WHERE Db = 'crownfield_eye_hospital' AND Name = 'gabriel_patient_history';

SHOW TRIGGERS FROM crownfield_eye_hospital
WHERE `Trigger` = 'trg_gabriel_followup_date';

CALL gabriel_patient_history('OP001');
SHOW GRANTS FOR 'gabriel_doctor_role';

