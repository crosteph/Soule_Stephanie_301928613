# Crown Microfinance Bank Savings and Loan Management System — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| loan_id | repayments records (list) |
| --- | --- |
| 5 | [7] |
| 6 | [8] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| repayments.id | repayments.receipt_no | repayments.loan_id | loans.id | loans.loan_no | loans.customer_id | customers.id | customers.customer_no |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 7 | RCPT-001 | 5 | 5 | LOAN-001 | 1 | 1 | CUST-001 |
| 8 | RCPT-002 | 6 | 6 | LOAN-002 | 2 | 2 | CUST-002 |

Key: id.

## 2NF: depend on the whole key

The declared candidate keys do not introduce a partial dependency here, so the 1NF rows stay unchanged at this step.

## repayments_example

| repayments.id | repayments.receipt_no | repayments.loan_id | loans.id | loans.loan_no | loans.customer_id | customers.id | customers.customer_no |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 7 | RCPT-001 | 5 | 5 | LOAN-001 | 1 | 1 | CUST-001 |
| 8 | RCPT-002 | 6 | 6 | LOAN-002 | 2 | 2 | CUST-002 |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## customers

| id | customer_no | full_name | joined_on |
| --- | --- | --- | --- |
| 1 | CUST-001 | Maya Chen | 2025-01-15 |
| 2 | CUST-002 | Omar Patel | 2025-02-20 |

## savings_accounts

| id | account_no | customer_id | opened_on | balance | status |
| --- | --- | --- | --- | --- | --- |
| 3 | SAV-001 | 1 | 2025-01-20 | 1250.5 | active |
| 4 | SAV-002 | 2 | 2025-02-25 | 800 | active |

## loans

| id | loan_no | customer_id | principal | outstanding_balance | opened_on | status |
| --- | --- | --- | --- | --- | --- | --- |
| 5 | LOAN-001 | 1 | 1000 | 800 | 2025-03-01 | active |
| 6 | LOAN-002 | 2 | 500 | 400 | 2025-03-10 | active |

## repayments

| id | receipt_no | loan_id | amount | paid_on | channel |
| --- | --- | --- | --- | --- | --- |
| 7 | RCPT-001 | 5 | 200 | 2025-04-01 | cash |
| 8 | RCPT-002 | 6 | 100 | 2025-04-05 | transfer |

## Dependencies

- customers: (id) → customer_no, full_name, joined_on
- savings_accounts: (id) → account_no, customer_id, opened_on, balance, status
- loans: (id) → loan_no, customer_id, principal, outstanding_balance, opened_on, status
- repayments: (id) → receipt_no, loan_id, amount, paid_on, channel

Joining the decomposed sample tables reproduces the original 2 example rows. The design assumes the declared keys describe the relevant business dependencies.
