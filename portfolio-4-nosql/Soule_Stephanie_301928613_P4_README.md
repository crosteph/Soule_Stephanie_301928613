# Portfolio 4 — NoSQL and Advanced Data Models

I used MongoDB collection loan_events for repayment_received and repayment_reversed events. These are fictional event examples based on repayments, loans, customers.

## Document model

| Field | Meaning |
| --- | --- |
| _id | Unique string event ID |
| eventType | One of the two selected case event labels |
| occurredAt | Native BSON Date; sample timestamps are in 2030 |
| source | Original entity, primary key and saved JSON snapshot |
| embedded | Linked record snapshots read with the event |
| references | Keys for linked sources kept outside the embedded snapshots |
| details | Event metadata whose fields vary |

Related loans details are stored as snapshots with the event. This makes an event readable in one document. It duplicates some information, and later SQL changes do not automatically update the snapshots. PostgreSQL continues to enforce the relational rules.

## Example document

```javascript
{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "repayment_received",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "repayments",
        "key": {
            "id": 7
        },
        "snapshot": {
            "id": 7,
            "receipt_no": "RCPT-001",
            "loan_id": 5,
            "amount": 200,
            "paid_on": "2025-04-01",
            "channel": "cash"
        }
    },
    "embedded": {
        "loans": [
            {
                "key": {
                    "id": 5
                },
                "snapshot": {
                    "id": 5,
                    "loan_no": "LOAN-001",
                    "customer_id": 1,
                    "principal": 1000,
                    "outstanding_balance": 800,
                    "opened_on": "2025-03-01",
                    "status": "active"
                },
                "via": [
                    "repayments.loan_id → loans"
                ]
            }
        ]
    },
    "references": {
        "customers": [
            {
                "key": {
                    "id": 1
                },
                "via": [
                    "repayments.loan_id → loans.customer_id → customers"
                ]
            }
        ]
    },
    "details": {
        "channel": "web"
    }
}
```

## Queries and results

| Query | Returned documents |
| --- | --- |
| Find the first sample event type (up to five documents). | 2 |
| Find events for the first source record using nested key fields (up to five). | 2 |
| Find events in the sample time range using a MongoDB Date filter (up to five). | 4 |
| Count documents for each event type. | 2 |

## 1. Find the first sample event type (up to five documents).

```javascript
db.getCollection("loan_events").find({"eventType":"repayment_received"}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "repayment_received",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "id": 7
    }
  },
  {
    "_id": "event_000003",
    "eventType": "repayment_received",
    "occurredAt": {
      "$date": "2030-01-01T10:02:00Z"
    },
    "source": {
      "id": 8
    }
  }
]
```

## 2. Find events for the first source record using nested key fields (up to five).

```javascript
db.getCollection("loan_events").find({"source.key.id":7}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "repayment_received",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "id": 7
    }
  },
  {
    "_id": "event_000002",
    "eventType": "repayment_reversed",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "id": 7
    }
  }
]
```

## 3. Find events in the sample time range using a MongoDB Date filter (up to five).

```javascript
db.getCollection("loan_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "repayment_received",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "id": 7
    }
  },
  {
    "_id": "event_000002",
    "eventType": "repayment_reversed",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "id": 7
    }
  },
  {
    "_id": "event_000003",
    "eventType": "repayment_received",
    "occurredAt": {
      "$date": "2030-01-01T10:02:00Z"
    },
    "source": {
      "id": 8
    }
  },
  {
    "_id": "event_000004",
    "eventType": "repayment_reversed",
    "occurredAt": {
      "$date": "2030-01-01T10:03:00Z"
    },
    "source": {
      "id": 8
    }
  }
]
```

## 4. Count documents for each event type.

```javascript
db.getCollection("loan_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray();
```

| _id | documentCount |
| --- | --- |
| repayment_received | 2 |
| repayment_reversed | 2 |

## Validation and suitability

MongoDB inserted 4 documents. An invalid date type was rejected with code 121 and a repeated event ID with 11000. The collection still contained 4 valid documents. The compound eventType/occurredAt index supports those access fields; this exercise does not measure its speed.

The details field can vary across event types, while the common fields have a validator. Events can be added as separate documents rather than growing one large history record.

## Run the script

Connect mongosh to a fresh exercise database and run Soule_Stephanie_301928613_P4_MongoDB.js. It selects portfolio_nosql, creates the collection, inserts the sample documents and displays the query results. [Implementation evidence](screenshots/Soule_Stephanie_301928613_P4_DocumentsAndQueries.png).

## References

- [MongoDB — data modelling](https://www.mongodb.com/docs/manual/data-modeling/)

