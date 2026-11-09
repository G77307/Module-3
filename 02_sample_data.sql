USE crownfield_eye_hospital;

INSERT INTO patient (patient_ref, full_name, postcode) VALUES
('OP001','Amina Yusuf','NE1 4AB'),
('OP002','Daniel Reed','N16 7QP'),
('OP003','Sofia Bennett','E8 2LD'),
('OP004','Michael Okoro','SE6 3RT'),
('OP005','Hannah Cole','SW3 9RT'),
('OP006','James Turner','NW1 5DL'),
('OP007','Priya Patel','E14 6GH'),
('OP008','Oliver Grant','EC1A 4AB'),
('OP009','Maria Lopez','W1F 7HG'),
('OP010','Ethan Brooks','CR0 2YR'),
('OP011','Grace Wilson','LS1 4DY'),
('OP012','Noah Evans','B1 1AA');

INSERT INTO clinician (full_name, specialty) VALUES
('Dr Maya Shah','Glaucoma'),
('Dr Leo Grant','Retina'),
('Dr Priya Nair','Cornea'),
('Dr Samuel Wright','Cataract'),
('Dr Helen Morris','Oculoplastics'),
('Dr Omar Rahman','Retina'),
('Dr Chloe Adams','Glaucoma'),
('Dr Victor Lin','Neuro-ophthalmology'),
('Dr Sarah Khan','Uveitis'),
('Dr Mark Ellis','General Ophthalmology');

INSERT INTO clinic (clinic_name, location) VALUES
('City Road Clinic','City Road'),
('Bedford Clinic','Bedford'),
('Croydon Eye Centre','Croydon'),
('Greenford Eye Unit','Greenford'),
('Bow Vision Centre','Bow'),
('Leeds Eye Hub','Leeds'),
('Manchester Retina Unit','Manchester'),
('Birmingham Cornea Centre','Birmingham'),
('Cambridge Glaucoma Clinic','Cambridge'),
('Oxford Eye Hospital','Oxford');

INSERT INTO medicine (medicine_name) VALUES
('Latanoprost'),
('Timolol'),
('Aflibercept'),
('Sodium Chloride Drops'),
('Prednisolone Acetate'),
('Cyclopentolate'),
('Brimonidine'),
('Dorzolamide'),
('Acetazolamide'),
('Ofloxacin');

INSERT INTO appointment
    (patient_id, clinician_id, clinic_id, appointment_date, appointment_time, appointment_status)
VALUES
(1,1,1,'2026-10-05','09:00','Completed'),
(2,2,1,'2026-10-05','09:30','Completed'),
(1,1,2,'2026-11-16','10:15','Scheduled'),
(3,1,1,'2026-10-06','11:00','Completed'),
(4,3,3,'2026-10-07','14:00','Completed'),
(5,4,4,'2026-10-10','10:00','Completed'),
(6,5,5,'2026-10-11','13:45','Completed'),
(7,6,6,'2026-10-12','15:00','Completed'),
(8,7,7,'2026-10-13','09:15','Completed'),
(9,8,8,'2026-10-14','16:30','Completed'),
(10,2,9,'2026-10-15','10:30','Completed'),
(11,3,10,'2026-10-16','12:00','Scheduled');

INSERT INTO diagnosis (appointment_id, diagnosis_text) VALUES
(1,'Ocular hypertension'),
(2,'Diabetic macular oedema'),
(3,'Ocular hypertension'),
(4,'Glaucoma suspect'),
(5,'Keratoconus'),
(6,'Cataract grade II'),
(7,'Dry eye syndrome'),
(8,'Retinal tear'),
(9,'Optic neuritis'),
(10,'Uveitis'),
(11,'Diabetic retinopathy');

INSERT INTO followup_plan (appointment_id, due_date, priority, status) VALUES
(1,'2026-11-16','High','Pending'),
(2,'2026-11-02','Urgent','Pending'),
(3,'2027-02-08','Routine','Pending'),
(4,'2027-04-07','Routine','Pending'),
(5,'2026-12-02','Routine','Pending'),
(6,'2026-12-19','Routine','Pending'),
(7,'2026-11-22','Routine','Pending'),
(8,'2026-10-26','Urgent','Pending'),
(9,'2027-01-19','Routine','Pending'),
(10,'2027-03-03','Routine','Pending');

INSERT INTO prescription (appointment_id, prescribed_at) VALUES
(1,'2026-10-05 09:20:00'),
(2,'2026-10-05 10:00:00'),
(3,'2026-11-16 10:40:00'),
(4,'2026-10-06 11:20:00'),
(5,'2026-10-07 14:30:00'),
(6,'2026-10-10 10:20:00'),
(7,'2026-10-11 14:10:00'),
(8,'2026-10-12 15:20:00'),
(9,'2026-10-13 09:40:00'),
(10,'2026-10-14 17:00:00'),
(11,'2026-10-15 11:00:00'),
(12,'2026-10-16 12:30:00');

INSERT INTO prescription_item
    (prescription_id, medicine_id, dose, route, frequency, duration)
VALUES
(1,1,'1 drop','Ocular','Once daily','6 weeks'),
(1,2,'1 drop','Ocular','Twice daily','6 weeks'),
(2,3,'2 mg','Intravitreal','Monthly','3 months'),
(3,1,'1 drop','Ocular','Once daily','12 weeks'),
(4,4,'1 drop','Ocular','Four times daily','4 weeks'),
(5,4,'1 drop','Ocular','Four times daily','8 weeks'),
(6,5,'1 drop','Ocular','Twice daily','6 weeks'),
(7,6,'1 drop','Ocular','Three times daily','2 weeks'),
(8,7,'1 drop','Ocular','Twice daily','4 weeks'),
(9,8,'1 drop','Ocular','Twice daily','6 weeks'),
(10,9,'250 mg','Oral','Once daily','10 days'),
(10,10,'1 drop','Ocular','Four times daily','7 days'),
(11,7,'1 drop','Ocular','Twice daily','4 weeks'),
(12,8,'1 drop','Ocular','Twice daily','8 weeks'),
(2,7,'1 drop','Ocular','Twice daily','4 weeks'),
(3,8,'1 drop','Ocular','Twice daily','8 weeks'),
(4,9,'250 mg','Oral','Once daily','5 days'),
(5,10,'1 drop','Ocular','Four times daily','10 days'),
(6,2,'1 drop','Ocular','Twice daily','6 weeks'),
(8,1,'1 drop','Ocular','Once daily','12 weeks');

INSERT INTO user_account (username, password_hash, account_type) VALUES
('admin_demo', SHA2('AdminDemo2026!', 256), 'Administrator'),
('doctor_demo', SHA2('DoctorDemo2026!', 256), 'Doctor'),
('reception_demo', SHA2('ReceptionDemo2026!', 256), 'Receptionist'),
('patient_demo', SHA2('PatientDemo2026!', 256), 'Patient');
