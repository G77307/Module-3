-- Gabriel-Adrian Bunea
-- Roles, privilege matrix, hashing/encryption, prepared statement and transaction tests.

USE crownfield_eye_hospital;

DROP VIEW IF EXISTS v_gabriel_visit_summary;
CREATE VIEW v_gabriel_visit_summary AS
SELECT
    a.appointment_id,
    p.patient_ref,
    p.full_name AS patient,
    c.full_name AS clinician,
    cl.clinic_name,
    a.appointment_date,
    a.appointment_status
FROM appointment AS a
JOIN patient AS p ON p.patient_id = a.patient_id
JOIN clinician AS c ON c.clinician_id = a.clinician_id
JOIN clinic AS cl ON cl.clinic_id = a.clinic_id;

CREATE ROLE IF NOT EXISTS
    'gabriel_administrator_role',
    'gabriel_doctor_role',
    'gabriel_receptionist_role',
    'gabriel_patient_role';

GRANT ALL PRIVILEGES ON crownfield_eye_hospital.* TO 'gabriel_administrator_role';

GRANT SELECT ON crownfield_eye_hospital.* TO 'gabriel_doctor_role';
GRANT INSERT, UPDATE ON crownfield_eye_hospital.diagnosis TO 'gabriel_doctor_role';
GRANT INSERT, UPDATE ON crownfield_eye_hospital.followup_plan TO 'gabriel_doctor_role';
GRANT INSERT, UPDATE ON crownfield_eye_hospital.prescription TO 'gabriel_doctor_role';
GRANT INSERT, UPDATE ON crownfield_eye_hospital.prescription_item TO 'gabriel_doctor_role';

GRANT SELECT, INSERT, UPDATE ON crownfield_eye_hospital.patient TO 'gabriel_receptionist_role';
GRANT SELECT, INSERT, UPDATE ON crownfield_eye_hospital.appointment TO 'gabriel_receptionist_role';
GRANT SELECT ON crownfield_eye_hospital.clinician TO 'gabriel_receptionist_role';
GRANT SELECT ON crownfield_eye_hospital.clinic TO 'gabriel_receptionist_role';

GRANT SELECT ON crownfield_eye_hospital.v_gabriel_visit_summary TO 'gabriel_patient_role';

SELECT username, password_hash, account_type
FROM user_account
ORDER BY user_id;

SET @gabriel_demo_key = 'Crownfield-Gabriel-2026';
UPDATE patient
SET postcode_encrypted = AES_ENCRYPT(postcode, @gabriel_demo_key);

SELECT
    patient_ref,
    HEX(postcode_encrypted) AS encrypted_postcode,
    CAST(AES_DECRYPT(postcode_encrypted, @gabriel_demo_key) AS CHAR) AS decrypted_postcode
FROM patient
WHERE patient_ref IN ('OP001', 'OP002');

SET @patient_search = 'OP001';
PREPARE gabriel_lookup FROM
    'SELECT patient_ref, full_name FROM patient WHERE patient_ref = ?';
EXECUTE gabriel_lookup USING @patient_search;
DEALLOCATE PREPARE gabriel_lookup;

START TRANSACTION;
UPDATE followup_plan SET priority = 'Urgent' WHERE appointment_id = 1;
SELECT appointment_id, priority FROM followup_plan WHERE appointment_id = 1;
ROLLBACK;
SELECT appointment_id, priority FROM followup_plan WHERE appointment_id = 1;

START TRANSACTION;
DELETE FROM diagnosis WHERE diagnosis_id = 11;
SELECT COUNT(*) AS diagnosis_after_delete FROM diagnosis;
ROLLBACK;
SELECT COUNT(*) AS diagnosis_after_rollback FROM diagnosis;

SHOW GRANTS FOR 'gabriel_doctor_role';

