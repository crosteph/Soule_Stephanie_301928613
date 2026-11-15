# Crown Microfinance Bank Savings and Loan Management System — ER diagram

```mermaid
erDiagram
    direction LR
    customers {
        bigint id PK
        text customer_no UK
        text full_name
        date joined_on
    }
    savings_accounts {
        bigint id PK
        text account_no UK
        bigint customer_id FK
        date opened_on
        numeric balance
        text status
    }
    loans {
        bigint id PK
        text loan_no UK
        bigint customer_id FK
        numeric principal
        numeric outstanding_balance
        date opened_on
        text status
    }
    repayments {
        bigint id PK
        text receipt_no UK
        bigint loan_id FK
        numeric amount
        date paid_on
        text channel
    }
    customers ||--o{ savings_accounts : "customer_id"
    customers ||--o{ loans : "customer_id"
    loans ||--o{ repayments : "loan_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/Soule_Stephanie_301928613_ERDiagram.png)
