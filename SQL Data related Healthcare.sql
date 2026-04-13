use healthcaredb;
Select* from patients;
Select* from appointments;
Select* from billing;
Select* from doctors;
Select* from prescriptions;
-- get all appoitments for a speicific petients
Select* from Appointments
Where patient_id = 1;
-- retrive all prescription for a specific appoutments
Select* from Prescriptions
WHERE appointment_id = 1;

-- get billig information
Select* FROM Billing
WHERE appointment_id = 2;

-- List All Appoitments with billing status
Select a.appointment_id, p.first_name AS patient_first_name, p.last_name AS patient_last_name,
d.first_name As doctor_first_name, d.last_name AS doctor_last_name,
b.amount, b.payment_date, b.status
FROM Appointments a 
JOIN Patients p ON a.patient_id = p.patient_id
JOIN Doctors d ON a.doctor_id = d.doctor_id
JOIN Billing b ON a.appointment_id = b.appointment_id;

-- Find all paid billing
Select* from billing
WHERE status = 'Paid';

-- calculate total amount buield and total apid amount
Select
(SELECT SUM(amount) FROM Billing) AS total_billed,
(Select SUM(amount) FROM Billing WHERE status = 'Paid') As total_paid;

-- get the number of apppointments by specialty
Select d.specialty, COUNT(a.appointment_id) AS number_of_appointments
FROM Appointments a
JOIN Doctors d On a.doctor_id = d.doctor_id
GROUP BY d.specialty;

-- find the most commmon reason for appointments
Select reason,
COUNT(*) AS count
FROM Appointments
GROUP BY reason 
ORDER BY count DESC;

-- last of patients with their latest appointments date
Select p.patient_id, p.first_name, p.last_name, MAX(a.appointment_date) AS latest_appointment
FROM patients p
JOIN Appointments a ON p.patient_id = a.patient_id
GROUP BY p.patient_id, p.first_name, p.last_name;

-- list all doctors and the number of appointments they had
Select d.doctor_id, d.first_name, d.last_name, COUNT(a.appointment_date) AS number_of_appointment
FROM Doctors d
 LEFT JOIN Appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id, d.first_name, d.last_name;

-- RETRIVE patients who had appointments in the last 90 days
Select DISTINCT p.*
FROM patients p
JOIN Appointments a On p.patient_id = a.patient_id
WHERE STR_TO_DATE(a.appointment_date, '%d-%m-%Y') >= CURDATE()-INTERVAL 90 DAY;

-- find discription associated with appointments that are pending status
Select pr.prescription_id, pr.medication, pr.dosage, pr.instructions
FROM Prescriptions pr
JOIN Appointments a ON pr.appointment_id = a.appointment_id
JOIN Billing b ON a.appointment_id = b.appointment_id
WHERE b.status = 'Pending';

-- analysis patients demographics
SELECt gender, COUNT(*) AS count
FROM patients
GROUP BY gender;

-- dentify tfrequency most frequency presciribed meditation and their total dosage 
Select medication, COUNT(*) AS frequency, SUM(CAST(SUBSTRING_INDEX(dosage, ' ', 1) AS UNSIGNED)) AS total_dosage
FROM Prescriptions
GROUP BY medication
ORDER BY frequency DESC;

-- Average billing amount by number of apoointments
Select p.patient_id, COUNT(a.appointment_id) AS appointment_count, AVG(b.amount) AS avg_billing_amount
FROM Patients p
LEFT JOIN Appointments a ON p.patient_id = a.patient_id
LEFT JOIN Billing b ON a.appointment_id = b.appointment_id
GROUP BY p.patient_id;

select appointment_date, count(*) as appointment_count
from appointments
group by appointment_date;

select p.patient_id, p.first_name, p.last_name
from patients p 
left join appointments a on p.patient_id = a.patient_id
where a.appointment_id is null;

select a.appointment_id,a.patient_id,a.doctor_id, a.appointment_date 
from appointments a
left join billing b on a.appointment_id = b.appointment_id
where b.billing_id is null;
select a.appointment_id, p.first_name as patient_first_name, p.last_name as
patient_last_name, a.appointment_date, a.reason
from appointments a
 join patients p  on a.patient_id = p.patient_id
where a.doctor_id = 1;

select p.medication, p.dosage, p.instructions, b.amount, b.payment_date, b.status
from prescriptions p
join appointments a on p.appointment_id = a.appointment_id
join billing b on a.appointment_id = b.appointment_id
where b.status = 'pending';
-- disable safe mode
set sql_safe_updates=0;

update appointments
set appointment_date=str_to_date(appointment_date,'%d-%m-%Y');

ALTER table appointments
modify column appointment_date date;

select distinct p.first_name, p.last_name, p.dob, p.gender, a.appointment_date
from patients p
join appointments a on p.patient_id = a.patient_id
where date_format(a.appointment_date, '%y-%m') = '2025-08';

select  d.first_name, d.last_name, a.appointment_date, p.first_name as
patient_first_name, p.last_name as patient_last_name
from doctors d
 join appointments a  on d.doctor_id = a.doctor_id
 join patients p on a.patient_id = p.patient_id
 where a.appointment_date between '2025-08-01' and '2025-08-10';
 
 select d.first_name, d.last_name, d.specialty, sum(b.amount) as total_billed
 from doctors d 
 join appointments a on d.doctor_id = a.doctor_id
 join billing b on a.appointment_id = b.appointment_id
 group by d.first_name, d.first_name, d.last_name, d.specialty
 order by total_billed desc;