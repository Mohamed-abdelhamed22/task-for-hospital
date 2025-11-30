-- 1. SELECT: Retrieve all columns from the Doctor table
SELECT * FROM Doctor;

-- 2. ORDER BY: List patients in ascending order of their ages
SELECT * FROM Patient
ORDER BY Age ASC;

-- 3. OFFSET FETCH: First 10 patients starting from 5th record
SELECT *
FROM Patient
ORDER BY UR_Number
OFFSET 4 ROWS FETCH NEXT 10 ROWS ONLY;

-- 4. SELECT TOP: Top 5 doctors
SELECT TOP 5 * FROM Doctor;

-- 5. SELECT DISTINCT: Unique addresses
SELECT DISTINCT Address
FROM Patient;

-- 6. WHERE: Patients aged 25
SELECT *
FROM Patient
WHERE Age = 25;

-- 7. NULL: Patients with no email
SELECT *
FROM Patient
WHERE Email IS NULL;

-- 8. AND: Doctors with >5 years experience AND Cardiology
SELECT *
FROM Doctor
WHERE Years_of_Experience > 5
  AND Specialty = 'Cardiology';

-- 9. IN: Doctors with selected specialties
SELECT *
FROM Doctor
WHERE Specialty IN ('Dermatology', 'Oncology');

-- 10. BETWEEN: Patients aged 18 to 30
SELECT *
FROM Patient
WHERE Age BETWEEN 18 AND 30;

-- 11. LIKE: Doctors whose names start with 'Dr.'
SELECT *
FROM Doctor
WHERE Name LIKE 'Dr.%';

-- 12. Aliases: Doctor name and email
SELECT Name AS DoctorName,
       Email AS DoctorEmail
FROM Doctor;

-- 13. JOIN: Prescriptions with patient names
SELECT p.Prescription_ID,
       pa.Name AS PatientName,
       p.Prescription_Date
FROM Prescription p
JOIN Patient pa ON p.Patient_UR = pa.UR_Number;

-- 14. GROUP BY: Count of patients by city
SELECT Address AS City,
       COUNT(*) AS PatientCount
FROM Patient
GROUP BY Address;

-- 15. HAVING: Cities with more than 3 patients
SELECT Address AS City,
       COUNT(*) AS PatientCount
FROM Patient
GROUP BY Address
HAVING COUNT(*) > 3;

-- 16. GROUPING SETS: Count by city and by age
SELECT Address, Age, COUNT(*) AS PatientCount
FROM Patient
GROUP BY GROUPING SETS ((Address), (Age));

-- 17. CUBE: All combinations of city and age
SELECT Address, Age, COUNT(*) AS PatientCount
FROM Patient
GROUP BY CUBE (Address, Age);

-- 18. ROLLUP: Rolled up counts by city
SELECT Address, COUNT(*) AS PatientCount
FROM Patient
GROUP BY ROLLUP (Address);

-- 19. EXISTS: Patients with at least one prescription
SELECT *
FROM Patient pa
WHERE EXISTS (
    SELECT 1 FROM Prescription pr
    WHERE pr.Patient_UR = pa.UR_Number
);

-- 20. UNION: Combined list of doctors and patients (names only)
SELECT Name FROM Doctor
UNION
SELECT Name FROM Patient;

-- 21. CTE: Patients with their doctors
WITH PatientDoctor AS (
    SELECT pa.Name AS PatientName,
           d.Name AS DoctorName
    FROM Patient pa
    JOIN Doctor d ON pa.Primary_Doctor_ID = d.Doctor_ID
)
SELECT * FROM PatientDoctor;

-- 22. INSERT: Insert a new doctor
INSERT INTO Doctor (Name, Email, Phone, Specialty, Years_of_Experience)
VALUES ('Dr. John Smith', 'john@hospital.com', '01012345678', 'Cardiology', 10);

-- 23. INSERT Multiple Rows: Insert multiple patients
INSERT INTO Patient (UR_Number, Name, Address, Age, Email, Phone, Medicare_Number, Primary_Doctor_ID)
VALUES
(1001, 'Ali Ahmed', 'Cairo', 28, 'ali@mail.com', '0100001111', 'MC101', 1),
(1002, 'Sara Mostafa', 'Alex', 22, NULL, '0100002222', 'MC102', 1),
(1003, 'Youssef Hamdy', 'Giza', 30, 'youssef@mail.com', '0100003333', NULL, 2);

-- 24. UPDATE: Update doctor's phone
UPDATE Doctor
SET Phone = '01110097726'
WHERE Doctor_ID = 1;

-- 25. UPDATE JOIN: Update city for patients treated by a specific doctor
UPDATE pa
SET pa.Address = 'Updated City'
FROM Patient pa
JOIN Prescription pr ON pa.UR_Number = pr.Patient_UR
WHERE pr.Doctor_ID = 1;

-- 26. DELETE: Delete a patient
DELETE FROM Patient
WHERE UR_Number = 1001;

-- 27. TRANSACTION: Insert doctor + patient together
BEGIN TRANSACTION;
BEGIN TRY
    INSERT INTO Doctor (Name, Email, Phone, Specialty, Years_of_Experience)
    VALUES ('Dr. Mona Fathy', 'mona@hospital.com', '0108888888', 'Dermatology', 8);

    INSERT INTO Patient (UR_Number, Name, Address, Age, Email, Phone, Primary_Doctor_ID)
    VALUES (2001, 'Mahmoud Ali', 'Cairo', 29, 'mahmoud@mail.com', '0107777777', SCOPE_IDENTITY());

    COMMIT;
END TRY
BEGIN CATCH
    ROLLBACK;
END CATCH;

-- 28. VIEW: Patient + Doctor combined
CREATE VIEW vw_PatientDoctor AS
SELECT pa.Name AS PatientName,
       pa.Address,
       d.Name AS DoctorName,
       d.Specialty
FROM Patient pa
JOIN Doctor d ON pa.Primary_Doctor_ID = d.Doctor_ID;

-- 29. INDEX: Create index on Patient phone
CREATE INDEX idx_patient_phone
ON Patient (Phone);

-- 30. BACKUP: Full database backup
BACKUP DATABASE PrescriptionSystem
TO DISK = 'C:/Backups/PrescriptionSystem.bak';
