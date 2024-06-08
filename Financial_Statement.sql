-- CASHFLOW_STATEMENT table (no sequences or foreign keys)
CREATE TABLE CASHFLOW_STATEMENT (
    ID INT PRIMARY KEY, 
    registration_date DATE,
    cash_and_equivalents NUMBER(10,2),
    net_notes_receivable NUMBER(10,2),
    net_accounts_receivable NUMBER(10,2),
    net_accounts_receivable_related NUMBER(10,2),
    merchandise_inventory NUMBER(10,2),
    prepaid_expenses NUMBER(10,2),
    other_current_assets NUMBER(10,2),
    property_plant_equipment NUMBER(10,2),
    depreciation_amortization NUMBER(10,2),
    amortization_other_expenses NUMBER(10,2),
    changes_notes_receivable NUMBER(10,2),
    decrease_accounts_receivable NUMBER(10,2),
    decrease_inventory NUMBER(10,2),
    changes_other_current_assets NUMBER(10,2),
    decrease_notes_payable NUMBER(10,2),
    changes_accounts_payable NUMBER(10,2),
    decrease_other_payables NUMBER(10,2),
    changes_other_current_liabilities NUMBER(10,2),
    interest_paid NUMBER(10,2),
    income_taxes_paid NUMBER(10,2)
);

-- STATEMENTS_EXPENSE table (no sequences or foreign keys)
CREATE TABLE STATEMENTS_EXPENSE (
    ID INT PRIMARY KEY,
    registration_date DATE,
    operating_revenue NUMBER(10,2),
    operating_costs NUMBER(10,2),
    gross_profit NUMBER(10,2),
    operating_expenses NUMBER(10,2),
    selling_expenses NUMBER(10,2),
    administrative_expenses NUMBER(10,2),
    research_development_expenses NUMBER(10,2),
    operating_loss NUMBER(10,2),
    non_operating_income_expenses NUMBER(10,2),
    other_income NUMBER(10,2),
    other_gains_losses NUMBER(10,2),
    finance_costs NUMBER(10,2),
    share_of_profit_loss_associates NUMBER(10,2),
    profit_before_tax NUMBER(10,2),
    income_tax_expense NUMBER(10,2),
    net_loss NUMBER(10,2),
    total_comprehensive_income NUMBER(10,2),
    net_profit_loss_attributable_parent NUMBER(10,2),
    net_profit_loss_attributable_nci NUMBER(10,2),
    total_comprehensive_income_attributable_parent NUMBER(10,2),
    total_comprehensive_income_attributable_nci NUMBER(10,2) 
);

-- Income_Expense_Category table 
CREATE TABLE Income_Expense_Category (
    category_id INT PRIMARY KEY,
    category_name VARCHAR2(50) NOT NULL,
    category_type VARCHAR2(10) CHECK (category_type IN ('Inc', 'Exp')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the income_expense_category_seq sequence
CREATE SEQUENCE income_expense_category_seq START WITH 1 INCREMENT BY 1;

-- Set the default value for category_id
ALTER TABLE Income_Expense_Category MODIFY category_id DEFAULT income_expense_category_seq.NEXTVAL;

-- DepartmentMonthlyIncomeExpense table
CREATE TABLE DepartmentMonthlyIncomeExpense (
    detail_id INT PRIMARY KEY,
    department_id INT REFERENCES Departments(department_id), 
    transaction_year INT NOT NULL,
    transaction_month INT NOT NULL,
    category_id INT REFERENCES Income_Expense_Category(category_id),
    amount NUMBER(10,2) NOT NULL,
    description VARCHAR2(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the dept_monthly_income_expense_seq sequence
CREATE SEQUENCE dept_monthly_income_expense_seq START WITH 1 INCREMENT BY 1;

-- Set the default value for detail_id
ALTER TABLE DepartmentMonthlyIncomeExpense MODIFY detail_id DEFAULT dept_monthly_income_expense_seq.NEXTVAL;


-- ACCOUNT table (no sequences or foreign keys)
CREATE TABLE ACCOUNT (
    account_id VARCHAR2(10) PRIMARY KEY NOT NULL,
    account_name VARCHAR2(50) NOT NULL,
    category VARCHAR2(20) NOT NULL,
    subcategory VARCHAR2(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- AccountingPeriod table
CREATE TABLE AccountingPeriod (
    period_id INT PRIMARY KEY,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    description VARCHAR2(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the accounting_period_seq sequence
CREATE SEQUENCE accounting_period_seq START WITH 1 INCREMENT BY 1;

-- Set the default value for period_id
ALTER TABLE AccountingPeriod MODIFY period_id DEFAULT accounting_period_seq.NEXTVAL;


-- TaxRecords table
CREATE TABLE TaxRecords (
    tax_record_id INT PRIMARY KEY,
    tax_year INT NOT NULL,
    tax_item VARCHAR2(50) NOT NULL,
    tax_amount NUMBER(10,2) NOT NULL,
    payment_date DATE,
    note VARCHAR2(4000),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
);

-- Create the tax_records_seq sequence
CREATE SEQUENCE tax_records_seq START WITH 1 INCREMENT BY 1;

-- Set the default value for tax_record_id
ALTER TABLE TaxRecords MODIFY tax_record_id DEFAULT tax_records_seq.NEXTVAL;


-- Create Triggers for 'updated_at' columns (excluding tables with PK as FK)
-- Income_Expense_Category
CREATE OR REPLACE TRIGGER update_income_expense_category_updated_at
BEFORE UPDATE ON Income_Expense_Category
FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/

-- DepartmentMonthlyIncomeExpense
CREATE OR REPLACE TRIGGER update_department_monthly_income_expense_updated_at
BEFORE UPDATE ON DepartmentMonthlyIncomeExpense
FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/

-- ACCOUNT
CREATE OR REPLACE TRIGGER update_account_updated_at
BEFORE UPDATE ON ACCOUNT
FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/

-- AccountingPeriod
CREATE OR REPLACE TRIGGER update_accounting_period_updated_at
BEFORE UPDATE ON AccountingPeriod
FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/

-- TaxRecords
CREATE OR REPLACE TRIGGER update_tax_records_updated_at
BEFORE UPDATE ON TaxRecords
FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/