
CREATE TABLE Pharmaceutical_Company (
    Company_ID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Address VARCHAR(255),
    Phone VARCHAR(20)
);


CREATE TABLE Drug (
    Drug_ID INT IDENTITY(1,1) PRIMARY KEY,
    Trade_Name VARCHAR(100) NOT NULL,
    Strength VARCHAR(50) NOT NULL,
    Company_ID INT NOT NULL,
    
    FOREIGN KEY (Company_ID) 
        REFERENCES Pharmaceutical_Company(Company_ID)
        ON DELETE CASCADE   -- If company removed ? all drugs removed
);

CREATE TABLE Doctor (
    Doctor_ID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100),
    Phone VARCHAR(20),
    Specialty VARCHAR(100),
    Years_of_Experience INT CHECK (Years_of_Experience >= 0)
);


CREATE TABLE Patient (
    UR_Number INT PRIMARY KEY,  -- Unique patient identifier
    Name VARCHAR(100) NOT NULL,
    Address VARCHAR(255),
    Age INT CHECK (Age >= 0),
    Email VARCHAR(100),
    Phone VARCHAR(20),
    Medicare_Number VARCHAR(50) NULL,
    Primary_Doctor_ID INT NOT NULL,
    
    FOREIGN KEY (Primary_Doctor_ID)
        REFERENCES Doctor(Doctor_ID)
        ON DELETE NO ACTION -- doctor cannot be deleted if assigned to patient
);


CREATE TABLE Prescription (
    Prescription_ID INT IDENTITY(1,1) PRIMARY KEY,
    Patient_UR INT NOT NULL,
    Doctor_ID INT NOT NULL,
    Prescription_Date DATE NOT NULL,

    FOREIGN KEY (Patient_UR)
        REFERENCES Patient(UR_Number)
        ON DELETE CASCADE,

    FOREIGN KEY (Doctor_ID)
        REFERENCES Doctor(Doctor_ID)
        ON DELETE NO ACTION
);

CREATE TABLE Prescription_Drug (
    Prescription_ID INT NOT NULL,
    Drug_ID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),

    PRIMARY KEY (Prescription_ID, Drug_ID),

    FOREIGN KEY (Prescription_ID)
        REFERENCES Prescription(Prescription_ID)
        ON DELETE CASCADE,

    FOREIGN KEY (Drug_ID)
        REFERENCES Drug(Drug_ID)
        ON DELETE CASCADE
);
