-- Crownfield Eye Hospital teaching database
-- Module CPU4:103

CREATE DATABASE IF NOT EXISTS crownfield_eye_hospital
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE crownfield_eye_hospital;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS audit_log;
DROP TABLE IF EXISTS user_account;
DROP TABLE IF EXISTS prescription_item;
DROP TABLE IF EXISTS prescription;
DROP TABLE IF EXISTS followup_plan;
DROP TABLE IF EXISTS diagnosis;
DROP TABLE IF EXISTS appointment;
DROP TABLE IF EXISTS medicine;
DROP TABLE IF EXISTS clinic;
DROP TABLE IF EXISTS clinician;
DROP TABLE IF EXISTS patient;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE patient (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_ref VARCHAR(10) NOT NULL UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    postcode VARCHAR(10) NOT NULL,
    postcode_encrypted VARBINARY(255) NULL
);

CREATE TABLE clinician (
    clinician_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    specialty VARCHAR(60) NOT NULL,
    CONSTRAINT uq_clinician_name UNIQUE (full_name)
);

CREATE TABLE clinic (
    clinic_id INT AUTO_INCREMENT PRIMARY KEY,
    clinic_name VARCHAR(100) NOT NULL,
    location VARCHAR(100) NOT NULL,
    CONSTRAINT uq_clinic_name UNIQUE (clinic_name)
);

CREATE TABLE medicine (
    medicine_id INT AUTO_INCREMENT PRIMARY KEY,
    medicine_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE appointment (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    clinician_id INT NOT NULL,
    clinic_id INT NOT NULL,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    appointment_status ENUM('Scheduled','Completed','Cancelled')
        NOT NULL DEFAULT 'Scheduled',
    CONSTRAINT uq_appointment_slot
        UNIQUE (clinician_id, appointment_date, appointment_time),
    CONSTRAINT fk_appointment_patient
        FOREIGN KEY (patient_id) REFERENCES patient(patient_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_appointment_clinician
        FOREIGN KEY (clinician_id) REFERENCES clinician(clinician_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_appointment_clinic
        FOREIGN KEY (clinic_id) REFERENCES clinic(clinic_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE diagnosis (
    diagnosis_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    diagnosis_text VARCHAR(255) NOT NULL,
    CONSTRAINT fk_diagnosis_appointment
        FOREIGN KEY (appointment_id) REFERENCES appointment(appointment_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE followup_plan (
    followup_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL UNIQUE,
    due_date DATE NOT NULL,
    priority ENUM('Routine','High','Urgent') NOT NULL DEFAULT 'Routine',
    status ENUM('Pending','Completed','Cancelled') NOT NULL DEFAULT 'Pending',
    CONSTRAINT fk_followup_appointment
        FOREIGN KEY (appointment_id) REFERENCES appointment(appointment_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE prescription (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    prescribed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_prescription_appointment
        FOREIGN KEY (appointment_id) REFERENCES appointment(appointment_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE prescription_item (
    prescription_item_id INT AUTO_INCREMENT PRIMARY KEY,
    prescription_id INT NOT NULL,
    medicine_id INT NOT NULL,
    dose VARCHAR(50) NOT NULL,
    route VARCHAR(50) NOT NULL,
    frequency VARCHAR(50) NOT NULL,
    duration VARCHAR(50) NOT NULL,
    CONSTRAINT uq_prescription_medicine UNIQUE (prescription_id, medicine_id),
    CONSTRAINT fk_item_prescription
        FOREIGN KEY (prescription_id) REFERENCES prescription(prescription_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_item_medicine
        FOREIGN KEY (medicine_id) REFERENCES medicine(medicine_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE user_account (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash CHAR(64) NOT NULL,
    account_type ENUM('Administrator','Doctor','Receptionist','Patient') NOT NULL
);

CREATE TABLE audit_log (
    log_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    action_name VARCHAR(50) NOT NULL,
    table_name VARCHAR(50) NOT NULL,
    record_id INT NOT NULL,
    detail_text VARCHAR(255) NOT NULL,
    changed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
