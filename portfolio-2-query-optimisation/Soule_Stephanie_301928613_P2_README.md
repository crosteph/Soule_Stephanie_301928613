# Crown Microfinance Bank Savings and Loan Management System — SQL queries

## 1. Show related repayments, loans, customers records (up to 20).

```sql
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
```

| repayments_id | repayments_receipt_no | loans_id | loans_loan_no | customers_id | customers_customer_no |
| --- | --- | --- | --- | --- | --- |
| 7 | RCPT-001 | 5 | LOAN-001 | 1 | CUST-001 |
| 8 | RCPT-002 | 6 | LOAN-002 | 2 | CUST-002 |

## 2. Find savings_accounts records where account_no matches "SAV-001" (up to 20).

```sql
SELECT * FROM portfolio."savings_accounts"
WHERE "account_no" IS NOT DISTINCT FROM 'SAV-001'
ORDER BY "id"
LIMIT 20;
```

| id | account_no | customer_id | opened_on | balance | status |
| --- | --- | --- | --- | --- | --- |
| 3 | SAV-001 | 1 | 2025-01-20 | 1250.5 | active |

## 3. Count repayments records for each loan_id (up to 20 groups).

```sql
SELECT "loan_id", count(*) AS record_count
FROM portfolio."repayments"
GROUP BY "loan_id"
ORDER BY record_count DESC, "loan_id" NULLS LAST
LIMIT 20;
```

| loan_id | record_count |
| --- | --- |
| 5 | 1 |
| 6 | 1 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 1.51 | 1.51, 3.374, 1.442 | Sort → Seq Scan | 112 |
| After index | 0.177 | 0.173, 0.177, 0.232 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 25 |

The median execution time changed from 1.51 ms to 0.177 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=1.438..1.44 rows=20 loops=1)
  Seq Scan on repayments (actual time=0.019..1.39 rows=20 loops=1)
Planning Time: 0.499 ms
Execution Time: 1.51 ms
```

### Before index, run 2

```text
Sort (actual time=3.332..3.335 rows=20 loops=1)
  Seq Scan on repayments (actual time=0.021..3.282 rows=20 loops=1)
Planning Time: 0.439 ms
Execution Time: 3.374 ms
```

### Before index, run 3

```text
Sort (actual time=1.4..1.403 rows=20 loops=1)
  Seq Scan on repayments (actual time=0.022..1.353 rows=20 loops=1)
Planning Time: 0.481 ms
Execution Time: 1.442 ms
```

### After index, run 1

```text
Sort (actual time=0.118..0.12 rows=20 loops=1)
  Bitmap Heap Scan on repayments (actual time=0.027..0.084 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.013..0.014 rows=20 loops=1)
Planning Time: 0.519 ms
Execution Time: 0.173 ms
```

### After index, run 2

```text
Sort (actual time=0.123..0.124 rows=20 loops=1)
  Bitmap Heap Scan on repayments (actual time=0.027..0.086 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.014..0.014 rows=20 loops=1)
Planning Time: 0.533 ms
Execution Time: 0.177 ms
```

### After index, run 3

```text
Sort (actual time=0.168..0.169 rows=20 loops=1)
  Bitmap Heap Scan on repayments (actual time=0.038..0.118 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.019..0.019 rows=20 loops=1)
Planning Time: 0.89 ms
Execution Time: 0.232 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Soule_Stephanie_301928613_P2_Queries.sql, then Soule_Stephanie_301928613_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Soule_Stephanie_301928613_P2_QueryResults.png) · [Index comparison](screenshots/Soule_Stephanie_301928613_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

