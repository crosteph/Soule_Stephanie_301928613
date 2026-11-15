-- Show related repayments, loans, customers records (up to 20).
SELECT t0."id" AS "repayments_id",
       t0."receipt_no" AS "repayments_receipt_no",
       t1."id" AS "loans_id",
       t1."loan_no" AS "loans_loan_no",
       t2."id" AS "customers_id",
       t2."customer_no" AS "customers_customer_no"
FROM portfolio."repayments" t0
JOIN portfolio."loans" t1 ON t0."loan_id" = t1."id"
JOIN portfolio."customers" t2 ON t1."customer_id" = t2."id"
ORDER BY t0."id", t1."id", t2."id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT t0."id" AS "repayments_id",
       t0."receipt_no" AS "repayments_receipt_no",
       t1."id" AS "loans_id",
       t1."loan_no" AS "loans_loan_no",
       t2."id" AS "customers_id",
       t2."customer_no" AS "customers_customer_no"
FROM portfolio."repayments" t0
JOIN portfolio."loans" t1 ON t0."loan_id" = t1."id"
JOIN portfolio."customers" t2 ON t1."customer_id" = t2."id"
ORDER BY t0."id", t1."id", t2."id"
LIMIT 20;

-- Find savings_accounts records where account_no matches "SAV-001" (up to 20).
SELECT * FROM portfolio."savings_accounts"
WHERE "account_no" IS NOT DISTINCT FROM 'SAV-001'
ORDER BY "id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."savings_accounts"
WHERE "account_no" IS NOT DISTINCT FROM 'SAV-001'
ORDER BY "id"
LIMIT 20;

-- Count repayments records for each loan_id (up to 20 groups).
SELECT "loan_id", count(*) AS record_count
FROM portfolio."repayments"
GROUP BY "loan_id"
ORDER BY record_count DESC, "loan_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "loan_id", count(*) AS record_count
FROM portfolio."repayments"
GROUP BY "loan_id"
ORDER BY record_count DESC, "loan_id" NULLS LAST
LIMIT 20;
