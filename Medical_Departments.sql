-- Execute the script twice and everything will be all right.

-- PATIENT_INFO table
CREATE TABLE PATIENT_INFO (
    patient_info_id INT PRIMARY KEY,
    patient_number VARCHAR2(20) UNIQUE NOT NULL,
    patient_name VARCHAR2(50) NOT NULL,
    national_identifier CHAR(10) UNIQUE NOT NULL CHECK (REGEXP_LIKE(national_identifier, '^[A-Z][12]\d{8}$')),
    birth_date DATE NOT NULL,
    blood_type VARCHAR2(5) CHECK (blood_type IN ('A', 'B', 'AB', 'O', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')),
    biological_sex CHAR(1) CHECK (biological_sex IN ('M', 'F')),
    address VARCHAR2(255),
    occupation VARCHAR2(50),
    phone_number VARCHAR2(20) NOT NULL CHECK (REGEXP_LIKE(phone_number, '^\d{10}$')),
    first_visit_date DATE NOT NULL,
    family_history VARCHAR2(255),
    patient_note VARCHAR2(4000),
    emergency_contact_name VARCHAR2(50) NOT NULL,
    emergency_contact_phone VARCHAR2(20) NOT NULL CHECK (REGEXP_LIKE(emergency_contact_phone, '^\d{10}$')),
    emergency_contact_relationship VARCHAR2(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the patient_info_seq sequence
CREATE SEQUENCE patient_info_seq START WITH 1 INCREMENT BY 1;

-- Set the default value for patient_info_id
ALTER TABLE PATIENT_INFO MODIFY patient_info_id DEFAULT patient_info_seq.NEXTVAL;

-- PATIENT_MEDICAL_HISTORY table
CREATE TABLE PATIENT_MEDICAL_HISTORY (
    medical_history_id INT PRIMARY KEY,
    patient_info_id INT REFERENCES PATIENT_INFO(patient_info_id),
    diagnosis_date DATE NOT NULL,
    disease_name VARCHAR2(255) NOT NULL,
    treatment CLOB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the patient_medical_history_seq sequence
CREATE SEQUENCE patient_medical_history_seq START WITH 1 INCREMENT BY 1;

-- Set the default value for medical_history_id
ALTER TABLE PATIENT_MEDICAL_HISTORY MODIFY medical_history_id DEFAULT patient_medical_history_seq.NEXTVAL;

-- PATIENT_ALLERGY_HISTORY table
CREATE TABLE PATIENT_ALLERGY_HISTORY (
    allergy_history_id INT PRIMARY KEY,
    patient_info_id INT REFERENCES PATIENT_INFO(patient_info_id),
    allergen VARCHAR2(255) NOT NULL,
    reaction VARCHAR2(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the patient_allergy_history_seq sequence
CREATE SEQUENCE patient_allergy_history_seq START WITH 1 INCREMENT BY 1;

-- Set the default value for allergy_history_id
ALTER TABLE PATIENT_ALLERGY_HISTORY MODIFY allergy_history_id DEFAULT patient_allergy_history_seq.NEXTVAL;

-- PATIENT_MEDICATION_HISTORY table
CREATE TABLE PATIENT_MEDICATION_HISTORY (
    medication_history_id INT PRIMARY KEY,
    patient_info_id INT REFERENCES PATIENT_INFO(patient_info_id),
    medication_name VARCHAR2(255) NOT NULL,
    usage_start_date DATE,
    usage_end_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the patient_medication_history_seq sequence
CREATE SEQUENCE patient_medication_history_seq START WITH 1 INCREMENT BY 1;

-- Set the default value for medication_history_id
ALTER TABLE PATIENT_MEDICATION_HISTORY MODIFY medication_history_id DEFAULT patient_medication_history_seq.NEXTVAL;

-- APPOINTMENTS table
CREATE TABLE APPOINTMENTS (
    appointment_id INT PRIMARY KEY,
    patient_info_id INT REFERENCES PATIENT_INFO(patient_info_id),
    appointment_phone VARCHAR2(20) NOT NULL CHECK (REGEXP_LIKE(appointment_phone, '^\d{10}$')),
    appointment_datetime TIMESTAMP NOT NULL,
    appointment_channel CHAR(3) CHECK (appointment_channel IN ('OR', 'Int', 'Tel', 'PRC')),
    appointment_status VARCHAR2(20) CHECK (appointment_status IN ('A', 'S', 'C')), 
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the appointments_seq sequence
CREATE SEQUENCE appointments_seq START WITH 1 INCREMENT BY 1;

-- Set the default value for appointment_id
ALTER TABLE APPOINTMENTS MODIFY appointment_id DEFAULT appointments_seq.NEXTVAL;

-- MEDICATION_MANAGEMENT table
CREATE TABLE MEDICATION_MANAGEMENT (
    medication_id INT PRIMARY KEY,
    medication_code VARCHAR2(20) UNIQUE NOT NULL,
    license_number VARCHAR2(50) UNIQUE NOT NULL,
    medication_name VARCHAR2(50) NOT NULL,
    scientific_name VARCHAR2(255) NOT NULL,
    medication_type VARCHAR2(50) NOT NULL,
    route VARCHAR2(20) NOT NULL,
    ingredients VARCHAR2(255) NOT NULL,
    indications VARCHAR2(255) NOT NULL,
    dosage VARCHAR2(20) NOT NULL,
    frequency VARCHAR2(20) NOT NULL,
    unit VARCHAR2(20) NOT NULL,
    contraindications VARCHAR2(255) NOT NULL,
    warnings VARCHAR2(255) NOT NULL,
    side_effects VARCHAR2(255) NOT NULL,
    packaging_storage VARCHAR2(255) NOT NULL,
    health_insurance CHAR(1) CHECK (health_insurance IN ('Y', 'N')),
    medication_price INT,
    medication_manufacturer VARCHAR2(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the medication_management_seq sequence
CREATE SEQUENCE medication_management_seq START WITH 1 INCREMENT BY 1;

-- Set the default value for medication_id
ALTER TABLE MEDICATION_MANAGEMENT MODIFY medication_id DEFAULT medication_management_seq.NEXTVAL;

-- PERSCRIPTION table 
-- Assuming patient_SEQ and treatment_record_id are also FKs, please verify
CREATE TABLE PERSCRIPTION (
    prescription_SEQ INT PRIMARY KEY,
    treatment_record_id INT REFERENCES TREATMENT_RECORD(treatment_record_id),
    prescription_date TIMESTAMP NOT NULL,
    patient_SEQ INT REFERENCES PATIENT_INFO(patient_info_id), -- Assuming this is also a FK
    medication_id INT REFERENCES MEDICATION_MANAGEMENT(medication_id),
    dosage VARCHAR2(50) NOT NULL,
    route VARCHAR2(50) NOT NULL,
    unit VARCHAR2(20) NOT NULL,
    total_amount INT,
    usage VARCHAR2(20),
    days_supply INT,
    description VARCHAR2(255),
    doctor_id VARCHAR2(8) REFERENCES Employees(employee_id),
    prescription_status CHAR(1) CHECK (prescription_status IN ('I', 'R', 'D')) 
);

-- Create the prescription_seq sequence
CREATE SEQUENCE prescription_seq START WITH 1 INCREMENT BY 1;

-- Set the default value for prescription_SEQ
ALTER TABLE PERSCRIPTION MODIFY prescription_SEQ DEFAULT prescription_seq.NEXTVAL;

-- TREATMENT_RECORD table
CREATE TABLE TREATMENT_RECORD (
    treatment_record_id INT PRIMARY KEY,
    patient_info_id INT REFERENCES PATIENT_INFO(patient_info_id),
    doctor_id VARCHAR2(8) REFERENCES Employees(employee_id),
    treatment_date TIMESTAMP NOT NULL,
    chief_complaint CLOB NOT NULL,
    medical_history_summary CLOB NOT NULL,
    physical_examination VARCHAR2(255) NOT NULL,
    examination_items VARCHAR2(255) NOT NULL,
    lab_test_results CLOB NOT NULL,
    diagnosis CLOB NOT NULL,
    treatment_plan CLOB NOT NULL,
    prescriber_signature BLOB NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the treatment_record_seq sequence
CREATE SEQUENCE treatment_record_seq START WITH 1 INCREMENT BY 1;

-- Set the default value for treatment_record_id
ALTER TABLE TREATMENT_RECORD MODIFY treatment_record_id DEFAULT treatment_record_seq.NEXTVAL;

-- NUTRIENT_SUPPLY_PERSCRIPTION table
CREATE TABLE NUTRIENT_SUPPLY_PERSCRIPTION (
    nutrient_prescription_id INT PRIMARY KEY,
    patient_info_id INT REFERENCES PATIENT_INFO(patient_info_id),
    supplements_id INT REFERENCES NUTRITIONAL_SUPPLIMENTS(supplements_id),
    content VARCHAR2(255),
    prescribed_amount INT CHECK (prescribed_amount >= 0),
    prescribed_unit CHAR(3) CHECK (prescribed_unit IN ('NW', 'Cap', 'Qty')),
    total_quantity INT CHECK (total_quantity >= 0),
    precautions VARCHAR2(255),
    nutrient_composition VARCHAR2(255),
    prescriber_signature BLOB,
    prescription_status CHAR(1) CHECK (prescription_status IN ('I', 'R', 'D')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the nutrient_supply_prescription_seq sequence
CREATE SEQUENCE nutrient_supply_prescription_seq START WITH 1 INCREMENT BY 1;

-- Set the default value for nutrient_prescription_id
ALTER TABLE NUTRIENT_SUPPLY_PERSCRIPTION MODIFY nutrient_prescription_id DEFAULT nutrient_supply_prescription_seq.NEXTVAL;

-- DOCTOR_QUALIFICATION table
CREATE TABLE DOCTOR_QUALIFICATION (
    doctor_qualification_id INT PRIMARY KEY,
    employee_id VARCHAR2(8) REFERENCES Employees(employee_id),
    certificate_type VARCHAR2(50) NOT NULL,
    certificate_id VARCHAR2(50) NOT NULL,
    practice_registration VARCHAR2(50) NOT NULL,
    practice_county VARCHAR2(50) NOT NULL,
    biological_sex CHAR(1) CHECK (biological_sex IN ('M', 'F')),
    qualification VARCHAR2(50) NOT NULL,
    practice_discipline VARCHAR2(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the doctor_qualification_seq sequence
CREATE SEQUENCE doctor_qualification_seq START WITH 1 INCREMENT BY 1;

-- Set the default value for doctor_qualification_id
ALTER TABLE DOCTOR_QUALIFICATION MODIFY doctor_qualification_id DEFAULT doctor_qualification_seq.NEXTVAL;

-- Medical_Assessment table
CREATE TABLE Medical_Assessment (
    assessment_id INT PRIMARY KEY,
    employee_id VARCHAR2(8) REFERENCES Employees(employee_id),
    department_id INT REFERENCES Departments(department_id),
    employee_position VARCHAR2(15),
    registration_time DATE,
    employee_hire_date DATE NOT NULL,
    hours_internal_training NUMBER(4,2),
    hours_external_training NUMBER(4,2),
    hours_volunteer NUMBER(4,2) CHECK (hours_volunteer >= 0),
    hours_emergency NUMBER(4,2) CHECK (hours_emergency >= 0),
    days_ward_duty INT CHECK (days_ward_duty >= 0),
    is_department_head CHAR(1) CHECK (is_department_head IN ('Y', 'N')),
    hours_community_service NUMBER(4,2),
    outer_performance VARCHAR2(200),
    counts_outpatient INT CHECK (counts_outpatient >= 0),
    counts_emergency INT CHECK (counts_emergency >= 0),
    counts_inpatient INT CHECK (counts_inpatient >= 0),
    counts_consultation INT CHECK (counts_consultation >= 0),
    counts_xray INT CHECK (counts_xray >= 0),
    counts_surgery INT CHECK (counts_surgery >= 0),
    counts_anesthesia INT CHECK (counts_anesthesia >= 0),
    counts_pathology INT CHECK (counts_pathology >= 0),
    counts_lithotripsy INT CHECK (counts_lithotripsy >= 0),
    counts_rehabilitation INT CHECK (counts_rehabilitation >= 0),
    counts_checkup INT CHECK (counts_checkup >= 0),
    counts_respiratory_therapy INT CHECK (counts_respiratory_therapy >= 0),
    counts_dental_treatment INT CHECK (counts_dental_treatment >= 0),
    counts_certificate INT CHECK (counts_certificate >= 0),
    counts_other_treatment INT CHECK (counts_other_treatment >= 0),
    total_score NUMBER(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the medical_assessment_seq sequence
CREATE SEQUENCE medical_assessment_seq START WITH 1 INCREMENT BY 1;

-- Set the default value for assessment_id
ALTER TABLE Medical_Assessment MODIFY assessment_id DEFAULT medical_assessment_seq.NEXTVAL;

-- MEDICAL_EQUIPMENT table
CREATE TABLE MEDICAL_EQUIPMENT (
    medical_equipment_id INT PRIMARY KEY,
    equipment_name VARCHAR2(50) NOT NULL,
    inventories_id VARCHAR2(10) REFERENCES Inventories(item_code), -- Assuming FK
    safety_stock INT CHECK (safety_stock >= 0),
    expiry_date DATE,
    purchase_date DATE,
    useful_life INT CHECK (useful_life >= 0),
    note VARCHAR2(4000),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the medical_equipment_seq sequence
CREATE SEQUENCE medical_equipment_seq START WITH 1 INCREMENT BY 1;

-- Set the default value for medical_equipment_id
ALTER TABLE MEDICAL_EQUIPMENT MODIFY medical_equipment_id DEFAULT medical_equipment_seq.NEXTVAL;

-- NUTRITIONAL_SUPPLIMENTS table
CREATE TABLE NUTRITIONAL_SUPPLIMENTS (
    supplements_id INT PRIMARY KEY,
    license_number VARCHAR2(50) UNIQUE NOT NULL,
    inventories_id VARCHAR2(10) REFERENCES Inventories(item_code), -- Assuming FK
    content VARCHAR2(255) NOT NULL,
    quantity INT CHECK (quantity >= 0),
    unit CHAR(3) CHECK (unit IN ('NW', 'Cap', 'Qty')),
    storage_method VARCHAR2(255),
    storage_condition VARCHAR2(255),
    supplier_uid INT REFERENCES SupplierInfo(supplier_uid),
    approved_effects VARCHAR2(255),
    recommended_intake VARCHAR2(255),
    precautions CLOB,
    batch_number VARCHAR2(50),
    manufacture_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the nutritional_supplements_seq sequence
CREATE SEQUENCE nutritional_supplements_seq START WITH 1 INCREMENT BY 1;

-- Set the default value for supplements_id
ALTER TABLE NUTRITIONAL_SUPPLIMENTS MODIFY supplements_id DEFAULT nutritional_supplements_seq.NEXTVAL;

-- DUTY_ROASTER table
CREATE TABLE DUTY_ROASTER (
    duty_roster_id INT PRIMARY KEY,
    employee_id VARCHAR2(8) REFERENCES Employees(employee_id),
    "YEAR" INT NOT NULL, -- "YEAR" needs to be in quotes as it's a reserved keyword
    "MONTH" INT NOT NULL, -- "MONTH" needs to be in quotes as it's a reserved keyword
    duty_date DATE NOT NULL,
    shift_type VARCHAR2(20) CHECK (shift_type IN ('Day', 'Night', 'Evening', 'On Call')),
    duty_status VARCHAR2(20) CHECK (duty_status IN ('D', 'N')),
    notes VARCHAR2(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the duty_roster_seq sequence
CREATE SEQUENCE duty_roster_seq START WITH 1 INCREMENT BY 1;

-- Set the default value for duty_roster_id
ALTER TABLE DUTY_ROASTER MODIFY duty_roster_id DEFAULT duty_roster_seq.NEXTVAL;

-- Create Triggers for 'updated_at' columns (excluding tables with PK as FK)

-- PATIENT_INFO
CREATE OR REPLACE TRIGGER update_patient_info_updated_at
BEFORE UPDATE ON PATIENT_INFO
FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/

-- PATIENT_MEDICAL_HISTORY
CREATE OR REPLACE TRIGGER update_patient_medical_history_updated_at
BEFORE UPDATE ON PATIENT_MEDICAL_HISTORY
FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/

-- PATIENT_ALLERGY_HISTORY
CREATE OR REPLACE TRIGGER update_patient_allergy_history_updated_at
BEFORE UPDATE ON PATIENT_ALLERGY_HISTORY
FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/

-- PATIENT_MEDICATION_HISTORY
CREATE OR REPLACE TRIGGER update_patient_medication_history_updated_at
BEFORE UPDATE ON PATIENT_MEDICATION_HISTORY
FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/

-- APPOINTMENTS
CREATE OR REPLACE TRIGGER update_appointments_updated_at
BEFORE UPDATE ON APPOINTMENTS
FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/

-- MEDICATION_MANAGEMENT
CREATE OR REPLACE TRIGGER update_medication_management_updated_at
BEFORE UPDATE ON MEDICATION_MANAGEMENT
FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/

-- TREATMENT_RECORD
CREATE OR REPLACE TRIGGER update_treatment_record_updated_at
BEFORE UPDATE ON TREATMENT_RECORD
FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/

-- NUTRIENT_SUPPLY_PERSCRIPTION
CREATE OR REPLACE TRIGGER update_nutrient_supply_prescription_updated_at
BEFORE UPDATE ON NUTRIENT_SUPPLY_PERSCRIPTION
FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/

-- DOCTOR_QUALIFICATION
CREATE OR REPLACE TRIGGER update_doctor_qualification_updated_at
BEFORE UPDATE ON DOCTOR_QUALIFICATION
FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/

-- Medical_Assessment
CREATE OR REPLACE TRIGGER update_medical_assessment_updated_at
BEFORE UPDATE ON Medical_Assessment
FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/

-- MEDICAL_EQUIPMENT
CREATE OR REPLACE TRIGGER update_medical_equipment_updated_at
BEFORE UPDATE ON MEDICAL_EQUIPMENT
FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/

-- NUTRITIONAL_SUPPLIMENTS
CREATE OR REPLACE TRIGGER update_nutritional_supplements_updated_at
BEFORE UPDATE ON NUTRITIONAL_SUPPLIMENTS
FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/

-- DUTY_ROASTER
CREATE OR REPLACE TRIGGER update_duty_roaster_updated_at
BEFORE UPDATE ON DUTY_ROASTER
FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/