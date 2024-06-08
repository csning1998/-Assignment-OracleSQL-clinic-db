-- Create the Departments table
CREATE TABLE Departments (
    DEPT_SEQ INT,
    department_id INT PRIMARY KEY,
    department_name VARCHAR2(50) NOT NULL,
    department_established DATE,
    department_location VARCHAR2(30),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the DEPT_SEQ sequence
CREATE SEQUENCE DEPT_SEQ START WITH 1 INCREMENT BY 1;

-- Set the default value for DEPT_SEQ
ALTER TABLE Departments MODIFY DEPT_SEQ DEFAULT DEPT_SEQ.NEXTVAL;

-- Create the Employees table
CREATE TABLE Employees (
    EMP_SEQ INT PRIMARY KEY,
    employee_id VARCHAR2(8) UNIQUE NOT NULL,
    employee_name VARCHAR2(10) NOT NULL,
    employee_name_en VARCHAR2(50),
    employee_position VARCHAR2(50) NOT NULL,
    department_id INT REFERENCES Departments(department_id),
    status CHAR(2) CHECK (status IN ('E', 'R', 'UL')),
    employee_hire_date DATE,
    employee_supervisor_id VARCHAR2(8) REFERENCES Employees(employee_id),
    gender CHAR(1) CHECK (gender IN ('M', 'F')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE Departments
ADD department_manager_id VARCHAR2(8) REFERENCES Employees(employee_id);

-- Create the EMP_SEQ sequence
CREATE SEQUENCE EMP_SEQ START WITH 1 INCREMENT BY 1;

-- Create the EmployeeContacts table
CREATE TABLE EmployeeContacts (
    contact_id INT PRIMARY KEY,
    employee_id VARCHAR2(8) REFERENCES Employees(employee_id),
    contact_type VARCHAR2(20),
    contact_name VARCHAR2(50),
    contact_phone VARCHAR2(20) NOT NULL CHECK (REGEXP_LIKE(contact_phone, '^\d{10}$')),
    contact_relationship VARCHAR2(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the employee_contacts_seq sequence
CREATE SEQUENCE employee_contacts_seq START WITH 1 INCREMENT BY 1;

-- Create the EmployeePersonalInfo table
CREATE TABLE EmployeePersonalInfo (
    employee_id VARCHAR2(8) PRIMARY KEY REFERENCES Employees(employee_id),
    employee_identity CHAR(1) CHECK (employee_identity IN ('A', 'B')),
    employee_photo BLOB,
    employee_nationality VARCHAR2(100),
    national_identifier CHAR(10) UNIQUE NOT NULL CHECK (REGEXP_LIKE(national_identifier, '^[A-Z][12]\d{8}$')),
    birthday DATE,
    place_of_birth VARCHAR2(4000),
    height NUMBER(3,2),
    weight NUMBER(3,2),
    marital_status VARCHAR2(20) CHECK (marital_status IN ('Single', 'Married', 'Divorced', 'Widowed')),
    veteran_status CHAR(1) CHECK (veteran_status IN ('Y', 'N')),
    transportation VARCHAR2(10),
    blood_type VARCHAR2(5) CHECK (blood_type IN ('A', 'B', 'AB', 'O', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')),
    residence_address VARCHAR2(4000),
    current_address VARCHAR2(4000),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the EmployeeWorkHistory table
CREATE TABLE EmployeeWorkHistory (
    work_history_id INT PRIMARY KEY,
    employee_id VARCHAR2(8) REFERENCES Employees(employee_id),
    employee_academic_a VARCHAR2(255),
    employee_academic_b VARCHAR2(255),
    employee_work_experience VARCHAR2(255),
    employee_talent VARCHAR2(255),
    employee_languages VARCHAR2(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- Create the employee_work_history_seq sequence
CREATE SEQUENCE employee_work_history_seq START WITH 1 INCREMENT BY 1;

-- Create the Salary table
CREATE TABLE Salary (
    salary_id INT PRIMARY KEY,
    employee_id VARCHAR2(8) REFERENCES Employees(employee_id),
    department_id INT REFERENCES Departments(department_id),
    registration_time DATE NOT NULL,
    salary_basic INT,
    salary_other INT,
    salary_performance INT,
    salary_festival INT,
    salary_others INT,
    insurance_labor INT,
    insurance_health INT,
    insurance_group INT,
    pension INT,
    salary_tax INT,
    employee_absence INT,
    salary_actual INT,
    employee_account VARCHAR2(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the salary_seq sequence
CREATE SEQUENCE salary_seq START WITH 1 INCREMENT BY 1;

-- Create the Attendance table
CREATE TABLE Attendance (
    attendance_id INT PRIMARY KEY,
    employee_id VARCHAR2(8) REFERENCES Employees(employee_id),
    absence_date DATE NOT NULL,
    absence_type CHAR(5) CHECK (absence_type IN ('S', 'P', 'O', 'B', 'M', 'Other')),
    absence_hours NUMBER(4,2) CHECK (absence_hours >= 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the attendance_seq sequence
CREATE SEQUENCE attendance_seq START WITH 1 INCREMENT BY 1;

-- Create the Employees_Training table
CREATE TABLE Employees_Training (
    training_record_id INT PRIMARY KEY,
    registration_time DATE NOT NULL,
    employee_id VARCHAR2(8) REFERENCES Employees(employee_id),
    training_categories VARCHAR2(50),
    training_course VARCHAR2(20),
    training_contents VARCHAR2(255),
    training_hours NUMBER(4,2) CHECK (training_hours >= 0),
    training_instructor VARCHAR2(10),
    employee_supervisor_id VARCHAR2(8) REFERENCES Employees(employee_id),
    assessment VARCHAR2(4000),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the employees_training_seq sequence
CREATE SEQUENCE employees_training_seq START WITH 1 INCREMENT BY 1;

-- Create the Employees_Assessment table
CREATE TABLE Employees_Assessment (
    assessment_id INT PRIMARY KEY,
    employee_id VARCHAR2(8) REFERENCES Employees(employee_id),
    registration_time DATE,
    employee_hire_date DATE,
    employee_id_assessor VARCHAR2(8) REFERENCES Employees(employee_id),
    employee_assessor_position VARCHAR2(50),
    hours_internal_training NUMBER(4,2) CHECK (hours_internal_training >= 0),
    hours_external_training NUMBER(4,2) CHECK (hours_external_training >= 0),
    moral_conduct INT CHECK (moral_conduct BETWEEN 1 AND 5),
    leadership INT CHECK (leadership BETWEEN 1 AND 5),
    planning_skills INT CHECK (planning_skills BETWEEN 1 AND 5),
    work_efficiency INT CHECK (work_efficiency BETWEEN 1 AND 5),
    responsibility INT CHECK (responsibility BETWEEN 1 AND 5),
    communication INT CHECK (communication BETWEEN 1 AND 5),
    cost_awareness INT CHECK (cost_awareness BETWEEN 1 AND 5),
    weighted_avg NUMBER(3,2),
    comments VARCHAR2(4000),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the employees_assessment_seq sequence
CREATE SEQUENCE employees_assessment_seq START WITH 1 INCREMENT BY 1;

-- Create the EmployeeTransfers table
CREATE TABLE EmployeeTransfers (
    transfer_id INT PRIMARY KEY,
    employee_id VARCHAR2(8) REFERENCES Employees(employee_id),
    transfer_date DATE NOT NULL,
    original_department_id INT REFERENCES Departments(department_id),
    new_department_id INT REFERENCES Departments(department_id),
    reason VARCHAR2(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the employee_transfers_seq sequence
CREATE SEQUENCE employee_transfers_seq START WITH 1 INCREMENT BY 1;

-- Create the InsuranceRecords table
CREATE TABLE InsuranceRecords (
    insurance_record_id INT PRIMARY KEY,
    employee_id VARCHAR2(8) REFERENCES Employees(employee_id),
    insurance_type VARCHAR2(20) CHECK (insurance_type IN ('GI', 'NP')),
    payment_period VARCHAR2(50),
    payment_amount NUMBER(10,2) NOT NULL,
    payment_date DATE,
    note VARCHAR2(4000),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the insurance_records_seq sequence
CREATE SEQUENCE insurance_records_seq START WITH 1 INCREMENT BY 1;

-- CREATE TABLE EmployeeCommissions (
    commission_id INT PRIMARY KEY,
    employee_id VARCHAR2(8) REFERENCES Employees(employee_id),
    business_item VARCHAR2(50) NOT NULL,
    commission_rate NUMBER(5,2) NOT NULL,
    commission_amount NUMBER(10,2) NOT NULL,
    payout_date DATE,
    note VARCHAR2(4000),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the employee_commissions_seq sequence
CREATE SEQUENCE employee_commissions_seq START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER update_departments_updated_at
BEFORE UPDATE ON Departments
FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/

CREATE OR REPLACE TRIGGER update_employees_updated_at
BEFORE UPDATE ON Employees
FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/

CREATE OR REPLACE TRIGGER update_employee_contacts_updated_at
BEFORE UPDATE ON EmployeeContacts
FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/

CREATE OR REPLACE TRIGGER update_employee_work_history_updated_at
BEFORE UPDATE ON EmployeeWorkHistory
FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/

CREATE OR REPLACE TRIGGER update_salary_updated_at
BEFORE UPDATE ON Salary
FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/

CREATE OR REPLACE TRIGGER update_attendance_updated_at
BEFORE UPDATE ON Attendance
FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/

CREATE OR REPLACE TRIGGER update_employees_training_updated_at
BEFORE UPDATE ON Employees_Training
FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/

CREATE OR REPLACE TRIGGER update_employees_assessment_updated_at
BEFORE UPDATE ON Employees_Assessment
FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/

CREATE OR REPLACE TRIGGER update_employee_transfers_updated_at
BEFORE UPDATE ON EmployeeTransfers
FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/

CREATE OR REPLACE TRIGGER update_insurance_records_updated_at
BEFORE UPDATE ON InsuranceRecords
FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/

CREATE OR REPLACE TRIGGER update_employee_commissions_updated_at
BEFORE UPDATE ON EmployeeCommissions
FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/