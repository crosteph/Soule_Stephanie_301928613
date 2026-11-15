-- Crown Microfinance Bank Savings and Loan Management System: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."customers" (
  "id" bigint NOT NULL,
  "customer_no" text NOT NULL,
  "full_name" text NOT NULL,
  "joined_on" date NOT NULL,
  CONSTRAINT "pk_customers" PRIMARY KEY ("id"),
  CONSTRAINT "uq_customers_0" UNIQUE ("customer_no")
);
CREATE TABLE portfolio."savings_accounts" (
  "id" bigint NOT NULL,
  "account_no" text NOT NULL,
  "customer_id" bigint NOT NULL,
  "opened_on" date NOT NULL,
  "balance" numeric(18,2) NOT NULL,
  "status" text NOT NULL,
  CONSTRAINT "pk_savings_accounts" PRIMARY KEY ("id"),
  CONSTRAINT "uq_savings_accounts_0" UNIQUE ("account_no")
);
CREATE TABLE portfolio."loans" (
  "id" bigint NOT NULL,
  "loan_no" text NOT NULL,
  "customer_id" bigint NOT NULL,
  "principal" numeric(18,2) NOT NULL,
  "outstanding_balance" numeric(18,2) NOT NULL,
  "opened_on" date NOT NULL,
  "status" text NOT NULL,
  CONSTRAINT "pk_loans" PRIMARY KEY ("id"),
  CONSTRAINT "uq_loans_0" UNIQUE ("loan_no")
);
CREATE TABLE portfolio."repayments" (
  "id" bigint NOT NULL,
  "receipt_no" text NOT NULL,
  "loan_id" bigint NOT NULL,
  "amount" numeric(18,2) NOT NULL,
  "paid_on" date NOT NULL,
  "channel" text NOT NULL,
  CONSTRAINT "pk_repayments" PRIMARY KEY ("id"),
  CONSTRAINT "uq_repayments_0" UNIQUE ("receipt_no")
);
ALTER TABLE portfolio."savings_accounts" ADD CONSTRAINT "fk_savings_accounts_0" FOREIGN KEY ("customer_id") REFERENCES portfolio."customers" ("id");
ALTER TABLE portfolio."loans" ADD CONSTRAINT "fk_loans_0" FOREIGN KEY ("customer_id") REFERENCES portfolio."customers" ("id");
ALTER TABLE portfolio."repayments" ADD CONSTRAINT "fk_repayments_0" FOREIGN KEY ("loan_id") REFERENCES portfolio."loans" ("id");
ALTER TABLE portfolio."savings_accounts" ADD CONSTRAINT "account_balance_nonnegative" CHECK ("balance" >= 0);
ALTER TABLE portfolio."loans" ADD CONSTRAINT "loan_balance_nonnegative" CHECK ("outstanding_balance" >= 0);
ALTER TABLE portfolio."repayments" ADD CONSTRAINT "repayment_amount_positive" CHECK ("amount" > 0);
COMMIT;
