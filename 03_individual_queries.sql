-- Gabriel-Adrian Bunea
-- Six purposeful query examples are completed across this file and 04_procedure_and_trigger.sql.

USE crownfield_eye_hospital;

-- Feature 1: aggregate with GROUP BY and HAVING
-- Question: Which clinicians handled at least two appointments?
SELECT
    c.full_name AS clinician,
    COUNT(a.appointment_id) AS total_appointments
FROM clinician AS c
JOIN appointment AS a
    ON a.clinician_id = c.clinician_id
GROUP BY c.clinician_id, c.full_name
HAVING COUNT(a.appointment_id) >= 2
ORDER BY total_appointments DESC, clinician;

-- Feature 2: INNER JOIN across five tables
-- Question: Which completed or scheduled visits have a recorded diagnosis?
SELECT
    a.appointment_id,
    p.patient_ref,
    p.full_name AS patient,
    c.full_name AS clinician,
    cl.clinic_name,
    a.appointment_date,
    d.diagnosis_text
FROM appointment AS a
JOIN patient AS p ON p.patient_id = a.patient_id
JOIN clinician AS c ON c.clinician_id = a.clinician_id
JOIN clinic AS cl ON cl.clinic_id = a.clinic_id
JOIN diagnosis AS d ON d.appointment_id = a.appointment_id
ORDER BY a.appointment_date, a.appointment_id;

-- Feature 3: LEFT JOIN for missing optional data
-- Question: Which appointments do not have a follow-up plan?
SELECT
    a.appointment_id,
    p.patient_ref,
    p.full_name AS patient,
    a.appointment_date,
    a.appointment_status
FROM appointment AS a
JOIN patient AS p ON p.patient_id = a.patient_id
LEFT JOIN followup_plan AS f ON f.appointment_id = a.appointment_id
WHERE f.followup_id IS NULL
ORDER BY a.appointment_id;

-- Feature 4: scalar subquery
-- Question: Which follow-up intervals are longer than the average interval?
SELECT
    p.patient_ref,
    p.full_name AS patient,
    a.appointment_date,
    f.due_date,
    DATEDIFF(f.due_date, a.appointment_date) AS interval_days
FROM followup_plan AS f
JOIN appointment AS a ON a.appointment_id = f.appointment_id
JOIN patient AS p ON p.patient_id = a.patient_id
WHERE DATEDIFF(f.due_date, a.appointment_date) > (
    SELECT AVG(DATEDIFF(f2.due_date, a2.appointment_date))
    FROM followup_plan AS f2
    JOIN appointment AS a2 ON a2.appointment_id = f2.appointment_id
)
ORDER BY interval_days DESC;

-- Extra query used when checking prescription data.
SELECT
    p.patient_ref,
    COUNT(pi.prescription_item_id) AS medicine_items
FROM patient AS p
JOIN appointment AS a ON a.patient_id = p.patient_id
JOIN prescription AS pr ON pr.appointment_id = a.appointment_id
JOIN prescription_item AS pi ON pi.prescription_id = pr.prescription_id
GROUP BY p.patient_id, p.patient_ref
ORDER BY medicine_items DESC, p.patient_ref;

