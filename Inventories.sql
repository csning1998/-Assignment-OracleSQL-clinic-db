-- Create the SupplierInfo table first as it's referenced by other tables
CREATE TABLE SupplierInfo (
    SUPPLIER_SEQ INT PRIMARY KEY,
    supplier_uid INT UNIQUE NOT NULL,
    supplier_name VARCHAR2(50) NOT NULL,
    supplier_service VARCHAR2(255),
    supplier_address VARCHAR2(4000),
    supplier_capital NUMBER(15,2),
    supplier_contact VARCHAR2(50),
    supplier_pid VARCHAR2(50),
    supplier_phone VARCHAR2(20),
    supplier_fax VARCHAR2(20),
    employee_id VARCHAR2(8) REFERENCES Employees(employee_id),
    supplier_bank VARCHAR2(20),
    supplier_bank_branch VARCHAR2(10),
    supplier_bank_code VARCHAR2(10),
    supplier_account VARCHAR2(20),
    payment_method VARCHAR2(4) CHECK (payment_method IN ('Cash', 'BT', 'CHK', 'MO')),
    payment_terms VARCHAR2(50),
    note VARCHAR2(4000),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the SUPPLIER_SEQ sequence
CREATE SEQUENCE SUPPLIER_SEQ START WITH 1 INCREMENT BY 1;

-- Create the Inventories table as it's referenced by other tables
CREATE TABLE Inventories (
    inventory_id INT PRIMARY KEY,
    item_code VARCHAR2(10) UNIQUE NOT NULL,
    item_name VARCHAR2(50) NOT NULL,
    category VARCHAR2(20) CHECK (category IN ('????', '??????', '????', '??')),
    purpose VARCHAR2(10),
    last_purchase_time TIMESTAMP,
    supplier_uid INT REFERENCES SupplierInfo(supplier_uid),
    model VARCHAR2(50),
    is_controlled_drug CHAR(1) CHECK (is_controlled_drug IN ('Y', 'N')),
    unit VARCHAR2(50),
    unit_amount NUMBER(10,2),
    unit_price NUMBER(10,2),
    inventory_limit INT NOT NULL,
    inventory_save INT NOT NULL,
    expiry_date DATE,
    note VARCHAR2(4000),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the inventories_seq sequence
CREATE SEQUENCE inventories_seq START WITH 1 INCREMENT BY 1;

-- Now create the dependent tables 

CREATE TABLE INVENTORIES_TRANSACTION (
    transaction_id INT PRIMARY KEY,
    registration_time TIMESTAMP NOT NULL,
    inventories_id VARCHAR2(10) REFERENCES Inventories(item_code),
    registration_amount INT NOT NULL CHECK (registration_amount > 0),
    inventory_type VARCHAR2(10) NOT NULL CHECK (inventory_type IN ('??', '??')),
    employee_id_host VARCHAR2(8) REFERENCES Employees(employee_id),
    employee_id_pickup VARCHAR2(8) REFERENCES Employees(employee_id),
    description VARCHAR2(4000),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the inventory_transactions_seq sequence
CREATE SEQUENCE inventory_transactions_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE INVENTORIES_RECORD (
    record_id INT PRIMARY KEY,
    registration_time TIMESTAMP NOT NULL,
    inventories_id VARCHAR2(10) REFERENCES Inventories(item_code),
    inventories_name VARCHAR2(50),
    inventories_location VARCHAR2(50),
    inventories_actual INT NOT NULL,
    inventories_status CHAR(1) NOT NULL CHECK (inventories_status IN ('C', 'O', 'D')), 
    note VARCHAR2(4000),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the inventory_records_seq sequence
CREATE SEQUENCE inventory_records_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE ControlledDrugTransactions (
    transaction_id INT PRIMARY KEY,
    registration_time TIMESTAMP NOT NULL,
    inventories_id VARCHAR2(10) REFERENCES Inventories(item_code),
    registration_amount INT NOT NULL CHECK (registration_amount > 0),
    transaction_type VARCHAR2(10) NOT NULL CHECK (transaction_type IN ('??', '??', '??')),
    employee_id VARCHAR2(8) REFERENCES Employees(employee_id),
    document_number VARCHAR2(50),
    description VARCHAR2(4000),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the controlled_drug_transactions_seq sequence
CREATE SEQUENCE controlled_drug_transactions_seq START WITH 1 INCREMENT BY 1;

-- Equipments table
CREATE TABLE EQUIPMENTS (
    equipment_id INT PRIMARY KEY,
    equipment_code VARCHAR2(10) UNIQUE NOT NULL,
    equipment_name VARCHAR2(50) NOT NULL,
    equipment_model VARCHAR2(50),
    equipment_status CHAR(1) CHECK (equipment_status IN ('O', 'D', 'N', 'A', 'R')),
    equipment_price INT,
    supplier_uid INT REFERENCES SupplierInfo(supplier_uid),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the equipments_seq sequence
CREATE SEQUENCE equipments_seq START WITH 1 INCREMENT BY 1;

-- Maintenance_Record table
CREATE TABLE MAINTENANCE_RECORD (
    record_id INT PRIMARY KEY,
    equipment_id INT REFERENCES Equipments(equipment_id),
    registration_time TIMESTAMP NOT NULL,
    maintenance_technician VARCHAR2(10),
    maintenance_item VARCHAR2(4000),
    maintenance_detail VARCHAR2(4000),
    repair_item VARCHAR2(4000),
    repair_cause VARCHAR2(4000),
    total_cost NUMBER(10,2),
    repair_sop VARCHAR2(4000),
    repair_result VARCHAR2(4000),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the maintenance_records_seq sequence
CREATE SEQUENCE maintenance_records_seq START WITH 1 INCREMENT BY 1;


-- Create Triggers for 'updated_at' columns (excluding tables with PK as FK)
-- SupplierInfo
CREATE OR REPLACE TRIGGER update_supplier_info_updated_at
BEFORE UPDATE ON SupplierInfo
FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/
-- Inventories
CREATE OR REPLACE TRIGGER update_inventories_updated_at
BEFORE UPDATE ON Inventories
FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/
-- INVENTORIES_TRANSACTION
CREATE OR REPLACE TRIGGER update_inventories_transaction_updated_at
BEFORE UPDATE ON INVENTORIES_TRANSACTION
FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/
-- INVENTORIES_RECORD
CREATE OR REPLACE TRIGGER update_inventories_record_updated_at
BEFORE UPDATE ON INVENTORIES_RECORD
FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/
-- ControlledDrugTransactions
CREATE OR REPLACE TRIGGER update_controlled_drug_transactions_updated_at
BEFORE UPDATE ON ControlledDrugTransactions
FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/
-- EQUIPMENTS
CREATE OR REPLACE TRIGGER update_equipments_updated_at
BEFORE UPDATE ON EQUIPMENTS
FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/
-- MAINTENANCE_RECORD
CREATE OR REPLACE TRIGGER update_maintenance_record_updated_at
BEFORE UPDATE ON MAINTENANCE_RECORD
FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/