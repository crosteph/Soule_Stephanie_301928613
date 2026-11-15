// Run once in mongosh against a fresh exercise database.
// These records are fictional events for the case study.
(async function () {
  db = db.getSiblingDB('portfolio_nosql');
  if ((await db.getCollectionNames()).includes("loan_events")) {
    throw new Error('The exercise collection already exists. Use a fresh database.');
  }

  // The validator checks the stable event fields while details can vary.
  await db.createCollection("loan_events", {
    validator: {
    "$jsonSchema": {
        "bsonType": "object",
        "required": [
            "_id",
            "schemaVersion",
            "simulation",
            "eventType",
            "occurredAt",
            "source",
            "embedded",
            "references",
            "details"
        ],
        "properties": {
            "_id": {
                "bsonType": "string",
                "minLength": 1
            },
            "schemaVersion": {
                "enum": [
                    1
                ]
            },
            "simulation": {
                "enum": [
                    true
                ]
            },
            "eventType": {
                "bsonType": "string",
                "enum": [
                    "repayment_received",
                    "repayment_reversed"
                ]
            },
            "occurredAt": {
                "bsonType": "date"
            },
            "source": {
                "bsonType": "object",
                "required": [
                    "entity",
                    "key",
                    "snapshot"
                ],
                "properties": {
                    "entity": {
                        "enum": [
                            "repayments"
                        ]
                    },
                    "key": {
                        "bsonType": "object",
                        "required": [
                            "id"
                        ]
                    },
                    "snapshot": {
                        "bsonType": "object"
                    }
                }
            },
            "embedded": {
                "bsonType": "object"
            },
            "references": {
                "bsonType": "object"
            },
            "details": {
                "bsonType": "object"
            }
        }
    }
},
    validationLevel: 'strict', validationAction: 'error'
  });

  // Insert the four example events and show their IDs.
  printjson(await db.getCollection("loan_events").insertMany([
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
    },
    {
        "_id": "event_000002",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "repayment_reversed",
        "occurredAt": ISODate("2030-01-01T10:01:00Z"),
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
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "attributes": [
                {
                    "entity": "repayments",
                    "key": {
                        "id": 7
                    },
                    "field": "channel",
                    "value": "cash"
                }
            ],
            "examples": {
                "reference_note": "illustrative reference_note"
            }
        }
    },
    {
        "_id": "event_000003",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "repayment_received",
        "occurredAt": ISODate("2030-01-01T10:02:00Z"),
        "source": {
            "entity": "repayments",
            "key": {
                "id": 8
            },
            "snapshot": {
                "id": 8,
                "receipt_no": "RCPT-002",
                "loan_id": 6,
                "amount": 100,
                "paid_on": "2025-04-05",
                "channel": "transfer"
            }
        },
        "embedded": {
            "loans": [
                {
                    "key": {
                        "id": 6
                    },
                    "snapshot": {
                        "id": 6,
                        "loan_no": "LOAN-002",
                        "customer_id": 2,
                        "principal": 500,
                        "outstanding_balance": 400,
                        "opened_on": "2025-03-10",
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
                        "id": 2
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
    },
    {
        "_id": "event_000004",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "repayment_reversed",
        "occurredAt": ISODate("2030-01-01T10:03:00Z"),
        "source": {
            "entity": "repayments",
            "key": {
                "id": 8
            },
            "snapshot": {
                "id": 8,
                "receipt_no": "RCPT-002",
                "loan_id": 6,
                "amount": 100,
                "paid_on": "2025-04-05",
                "channel": "transfer"
            }
        },
        "embedded": {
            "loans": [
                {
                    "key": {
                        "id": 6
                    },
                    "snapshot": {
                        "id": 6,
                        "loan_no": "LOAN-002",
                        "customer_id": 2,
                        "principal": 500,
                        "outstanding_balance": 400,
                        "opened_on": "2025-03-10",
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
                        "id": 2
                    },
                    "via": [
                        "repayments.loan_id → loans.customer_id → customers"
                    ]
                }
            ]
        },
        "details": {
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "attributes": [
                {
                    "entity": "repayments",
                    "key": {
                        "id": 8
                    },
                    "field": "channel",
                    "value": "transfer"
                }
            ],
            "examples": {
                "reference_note": "illustrative reference_note"
            }
        }
    }
]));
  await db.getCollection("loan_events").createIndex({eventType: 1, occurredAt: -1}, {name: 'event_type_time'});

  // 1. Find the first sample event type (up to five documents).
  printjson(await db.getCollection("loan_events").find({"eventType":"repayment_received"}).sort({_id:1}).limit(5).toArray());

  // 2. Find events for the first source record using nested key fields (up to five).
  printjson(await db.getCollection("loan_events").find({"source.key.id":7}).sort({_id:1}).limit(5).toArray());

  // 3. Find events in the sample time range using a MongoDB Date filter (up to five).
  printjson(await db.getCollection("loan_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray());

  // 4. Count documents for each event type.
  printjson(await db.getCollection("loan_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray());

  // A date stored as text should be rejected by the validator.
  try {
    await db.getCollection("loan_events").insertOne({...{
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
}, _id: 'invalid_date_example', occurredAt: 'not-a-date'});
  } catch (error) { print('Invalid date error: ' + error.code); }

  // Reusing an event ID should be rejected by the unique _id index.
  try { await db.getCollection("loan_events").insertOne({
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
}); }
  catch (error) { print('Duplicate ID error: ' + error.code); }

  print('Document count: ' + await db.getCollection("loan_events").countDocuments());
})().catch(error => { print(error.stack || String(error)); quit(1); });
