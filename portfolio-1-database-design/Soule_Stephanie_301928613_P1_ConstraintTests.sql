-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. customers pk. Expected: pk_customers, SQLSTATE 23505.
INSERT INTO portfolio."customers" ("id", "customer_no", "full_name", "joined_on")
VALUES (1, 'CUST-NEG-PK', 'Nina Reed', '2025-05-01');

-- 2. customers unique. Expected: uq_customers_0, SQLSTATE 23505.
INSERT INTO portfolio."customers" ("id", "customer_no", "full_name", "joined_on")
VALUES (9001, 'CUST-001', 'Nina Reed', '2025-05-01');

-- 3. customers not null. Expected: full_name, SQLSTATE 23502.
INSERT INTO portfolio."customers" ("id", "customer_no", "full_name", "joined_on")
VALUES (9002, 'CUST-NEG-NN', NULL, '2025-05-01');

-- 4. accounts pk. Expected: pk_savings_accounts, SQLSTATE 23505.
INSERT INTO portfolio."savings_accounts" ("id", "account_no", "customer_id", "opened_on", "balance", "status")
VALUES (3, 'SAV-NEG-PK', 1, '2025-05-01', 10, 'active');

-- 5. accounts unique. Expected: uq_savings_accounts_0, SQLSTATE 23505.
INSERT INTO portfolio."savings_accounts" ("id", "account_no", "customer_id", "opened_on", "balance", "status")
VALUES (9003, 'SAV-001', 1, '2025-05-01', 10, 'active');

-- 6. accounts fk. Expected: fk_savings_accounts_0, SQLSTATE 23503.
INSERT INTO portfolio."savings_accounts" ("id", "account_no", "customer_id", "opened_on", "balance", "status")
VALUES (9004, 'SAV-NEG-FK', 99999, '2025-05-01', 10, 'active');

-- 7. accounts check. Expected: account_balance_nonnegative, SQLSTATE 23514.
INSERT INTO portfolio."savings_accounts" ("id", "account_no", "customer_id", "opened_on", "balance", "status")
VALUES (9005, 'SAV-NEG-CHECK', 1, '2025-05-01', -1, 'active');

-- 8. loans pk. Expected: pk_loans, SQLSTATE 23505.
INSERT INTO portfolio."loans" ("id", "loan_no", "customer_id", "principal", "outstanding_balance", "opened_on", "status")
VALUES (5, 'LOAN-NEG-PK', 1, 100, 50, '2025-05-01', 'active');

-- 9. loans unique. Expected: uq_loans_0, SQLSTATE 23505.
INSERT INTO portfolio."loans" ("id", "loan_no", "customer_id", "principal", "outstanding_balance", "opened_on", "status")
VALUES (9006, 'LOAN-001', 1, 100, 50, '2025-05-01', 'active');

-- 10. loans fk. Expected: fk_loans_0, SQLSTATE 23503.
INSERT INTO portfolio."loans" ("id", "loan_no", "customer_id", "principal", "outstanding_balance", "opened_on", "status")
VALUES (9007, 'LOAN-NEG-FK', 99998, 100, 50, '2025-05-01', 'active');

-- 11. loans check. Expected: loan_balance_nonnegative, SQLSTATE 23514.
INSERT INTO portfolio."loans" ("id", "loan_no", "customer_id", "principal", "outstanding_balance", "opened_on", "status")
VALUES (9008, 'LOAN-NEG-CHECK', 1, 100, -1, '2025-05-01', 'active');

-- 12. repayments pk. Expected: pk_repayments, SQLSTATE 23505.
INSERT INTO portfolio."repayments" ("id", "receipt_no", "loan_id", "amount", "paid_on", "channel")
VALUES (7, 'RCPT-NEG-PK', 5, 10, '2025-05-01', 'cash');

-- 13. repayments unique. Expected: uq_repayments_0, SQLSTATE 23505.
INSERT INTO portfolio."repayments" ("id", "receipt_no", "loan_id", "amount", "paid_on", "channel")
VALUES (9009, 'RCPT-001', 5, 10, '2025-05-01', 'cash');

-- 14. repayments fk. Expected: fk_repayments_0, SQLSTATE 23503.
INSERT INTO portfolio."repayments" ("id", "receipt_no", "loan_id", "amount", "paid_on", "channel")
VALUES (9010, 'RCPT-NEG-FK', 99997, 10, '2025-05-01', 'cash');

-- 15. repayments check. Expected: repayment_amount_positive, SQLSTATE 23514.
INSERT INTO portfolio."repayments" ("id", "receipt_no", "loan_id", "amount", "paid_on", "channel")
VALUES (9011, 'RCPT-NEG-CHECK', 5, 0, '2025-05-01', 'cash');
