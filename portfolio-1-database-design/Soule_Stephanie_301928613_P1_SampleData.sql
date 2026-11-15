-- Fictional sample records for Crown Microfinance Bank Savings and Loan Management System.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."customers" ("id", "customer_no", "full_name", "joined_on") VALUES (1, 'CUST-001', 'Maya Chen', '2025-01-15');
INSERT INTO portfolio."customers" ("id", "customer_no", "full_name", "joined_on") VALUES (2, 'CUST-002', 'Omar Patel', '2025-02-20');
INSERT INTO portfolio."savings_accounts" ("id", "account_no", "customer_id", "opened_on", "balance", "status") VALUES (3, 'SAV-001', 1, '2025-01-20', 1250.5, 'active');
INSERT INTO portfolio."savings_accounts" ("id", "account_no", "customer_id", "opened_on", "balance", "status") VALUES (4, 'SAV-002', 2, '2025-02-25', 800, 'active');
INSERT INTO portfolio."loans" ("id", "loan_no", "customer_id", "principal", "outstanding_balance", "opened_on", "status") VALUES (5, 'LOAN-001', 1, 1000, 800, '2025-03-01', 'active');
INSERT INTO portfolio."loans" ("id", "loan_no", "customer_id", "principal", "outstanding_balance", "opened_on", "status") VALUES (6, 'LOAN-002', 2, 500, 400, '2025-03-10', 'active');
INSERT INTO portfolio."repayments" ("id", "receipt_no", "loan_id", "amount", "paid_on", "channel") VALUES (7, 'RCPT-001', 5, 200, '2025-04-01', 'cash');
INSERT INTO portfolio."repayments" ("id", "receipt_no", "loan_id", "amount", "paid_on", "channel") VALUES (8, 'RCPT-002', 6, 100, '2025-04-05', 'transfer');
COMMIT;
