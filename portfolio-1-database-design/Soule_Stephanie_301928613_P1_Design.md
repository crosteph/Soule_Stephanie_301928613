# Crown Microfinance Bank Savings and Loan Management System — database design

My case study records customers, savings_accounts, loans, repayments.

## Users

- Synthetic branch teller recording savings accounts and repayments
- Synthetic loan officer reviewing loan balances and status
- Synthetic auditor reviewing customer and collection summaries

## Main operations

- Register synthetic customers and associate savings accounts and loans with them.
- Record a repayment against an existing loan and update its outstanding balance atomically.
- Review active savings accounts and trace repayments through loans to customers.
- Separate benchmark plan: generate 20000 synthetic repayment rows with varied paid dates; compare a date-filter scan without an index against the same filter using a B-tree index on paid_on, verify identical matching rows, and compare logical work.

## Entities

| Entity | Information stored |
| --- | --- |
| customers | Synthetic customer records shared by savings accounts and loans. |
| savings_accounts | Customer-owned savings accounts with a current synthetic balance and status. |
| loans | Customer loans with principal, opening date, status, and outstanding balance. |
| repayments | Synthetic receipts recording dated payments against loans. |

## customers

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| id | BIGINT | PK | Yes |
| customer_no | TEXT | Unique | Yes |
| full_name | TEXT |  | Yes |
| joined_on | DATE |  | Yes |
- Unique key: (customer_no).

## savings_accounts

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| id | BIGINT | PK | Yes |
| account_no | TEXT | Unique | Yes |
| customer_id | BIGINT | FK | Yes |
| opened_on | DATE |  | Yes |
| balance | NUMERIC(18,2) |  | Yes |
| status | TEXT |  | Yes |
- customer_id → customers.id
- Unique key: (account_no).

## loans

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| id | BIGINT | PK | Yes |
| loan_no | TEXT | Unique | Yes |
| customer_id | BIGINT | FK | Yes |
| principal | NUMERIC(18,2) |  | Yes |
| outstanding_balance | NUMERIC(18,2) |  | Yes |
| opened_on | DATE |  | Yes |
| status | TEXT |  | Yes |
- customer_id → customers.id
- Unique key: (loan_no).

## repayments

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| id | BIGINT | PK | Yes |
| receipt_no | TEXT | Unique | Yes |
| loan_id | BIGINT | FK | Yes |
| amount | NUMERIC(18,2) |  | Yes |
| paid_on | DATE |  | Yes |
| channel | TEXT |  | Yes |
- loan_id → loans.id
- Unique key: (receipt_no).

## Relationships and business rules

- Each customer number identifies at most one customer.
- Each savings account number identifies at most one account.
- Every savings account references an existing customer.
- A savings account balance must be zero or greater.
- Every loan references an existing customer.
- A loan's outstanding balance must be zero or greater, including after a repayment is applied.
- Every repayment references an existing loan.
- A recorded repayment amount must be greater than zero.
- A repayment receipt number identifies at most one repayment.

## Assumptions

- All records and identifiers are synthetic; primary-key values come from one shared identifier namespace so every single-column primary key is globally unique.
- Each savings account and each loan belongs to exactly one customer; each repayment applies to exactly one loan.
- Repayment recording reduces the loan's outstanding balance by the repayment amount; amounts are positive and the resulting balance cannot be negative.
- The normalization example follows repayments to loans to customers, with no repeated ancestor role and no customer name stored in repayments.
- The proposed MongoDB collection stores repayment-related events anchored by repayments and embeds a compact loan snapshot; it is a discussion model, not a second source of truth.

