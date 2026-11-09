-- Gabriel-Adrian Bunea
-- Feature 5: stored procedure with an input parameter
-- Feature 6: trigger that applies a meaningful date rule

USE crownfield_eye_hospital;

DROP PROCEDURE IF EXISTS gabriel_patient_history;
DELIMITER $$
CREATE PROCEDURE gabriel_patient_history(IN p_patient_ref VARCHAR(10))
BEGIN
    SELECT
        p.patient_ref,
        p.full_name AS patient,
        a.appointment_id,
        a.appointment_date,
        a.appointment_status,
        c.full_name AS clinician,
        cl.clinic_name,
        GROUP_CONCAT(d.diagnosis_text ORDER BY d.diagnosis_id SEPARATOR '; ') AS diagnoses
    FROM patient AS p
    JOIN appointment AS a ON a.patient_id = p.patient_id
    JOIN clinician AS c ON c.clinician_id = a.clinician_id
    JOIN clinic AS cl ON cl.clinic_id = a.clinic_id
    LEFT JOIN diagnosis AS d ON d.appointment_id = a.appointment_id
    WHERE p.patient_ref = p_patient_ref
    GROUP BY
        p.patient_ref, p.full_name, a.appointment_id, a.appointment_date,
        a.appointment_status, c.full_name, cl.clinic_name
    ORDER BY a.appointment_date, a.appointment_id;
END$$
DELIMITER ;

CALL gabriel_patient_history('OP001');

DROP TRIGGER IF EXISTS trg_gabriel_followup_date;
DELIMITER $$
CREATE TRIGGER trg_gabriel_followup_date
BEFORE INSERT ON followup_plan
FOR EACH ROW
BEGIN
    DECLARE v_appointment_date DATE;

    SELECT appointment_date
    INTO v_appointment_date
    FROM appointment
    WHERE appointment_id = NEW.appointment_id;

    IF v_appointment_date IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Appointment does not exist';
    END IF;

    IF NEW.due_date <= v_appointment_date THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Follow-up due date must be after the appointment date';
    END IF;

    IF NEW.status IS NULL THEN
        SET NEW.status = 'Pending';
    END IF;
END$$
DELIMITER ;

START TRANSACTION;
INSERT INTO followup_plan (appointment_id, due_date, priority, status)
VALUES (12, '2026-11-20', 'Routine', NULL);
SELECT appointment_id, due_date, priority, status
FROM followup_plan
WHERE appointment_id = 12;
ROLLBACK;

-- Invalid test to run separately when recording evidence:
-- INSERT INTO followup_plan (appointment_id, due_date, priority)
-- VALUES (12, '2026-10-16', 'Routine');

