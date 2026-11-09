# Crownfield Eye Hospital Database - Gabriel Bunea

This folder contains my individual CPU4:103 Database Development submission. The database uses fictional records and runs on MySQL 8.0.

Run the files in this order:

1. `01_schema.sql`
2. `02_sample_data.sql`
3. `03_individual_queries.sql`
4. `04_procedure_and_trigger.sql`
5. `05_security_and_transactions.sql`
6. `06_evidence_checks.sql`

In the installed MySQL Workbench version, use **Run Script** (`Ctrl+Enter`) for each whole file. The complete sequence was re-run on 3 November 2026: 12 patients, 12 appointments and 20 prescription items loaded, and the individual procedure, trigger and view all returned a verification value of `1`.

My six demonstrated features are an aggregate query, a five-table INNER JOIN, a LEFT JOIN for missing follow-up work, a subquery, a stored procedure with an input parameter, and a trigger that validates follow-up dates.

Useful tests:

```sql
CALL gabriel_patient_history('OP001');

START TRANSACTION;
INSERT INTO followup_plan (appointment_id, due_date, priority)
VALUES (12, '2026-11-20', 'Routine');
SELECT * FROM followup_plan WHERE appointment_id = 12;
ROLLBACK;
```

`ERD.png` shows the final model.

