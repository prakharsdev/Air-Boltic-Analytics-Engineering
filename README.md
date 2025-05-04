# Air Boltic Analytics Engineering Project

## Introduction

This repository documents the work I've done as part of developing a scalable and production-grade data modeling framework for the Air Boltic initiative at Bolt. While this originated as a test assignment, I've approached it as a genuine analytics engineering project aligned with real-world needs and Bolt's modern data stack.

The intention was not to simply submit a solution but to design a solid foundation for ongoing analytics that could scale with Bolt's vision. Every modeling choice, transformation, and test here is grounded in best practices from my experience working with production-grade data environments.

---

## Goals & Vision

Air Boltic, being a marketplace of aeroplane rides, needs deep analytical visibility into supply (airplanes, operators), demand (customers and their behavior), and operations (trips, orders). Therefore, my goal was to:

* Build an intuitive and scalable data model supporting dimensional analysis.
* Enable self-service BI through clean marts for Looker users.
* Set up foundations for CI/CD, monitoring, testing, and documentation.
* Simulate how this could plug into the broader data ecosystem at Bolt using S3, Databricks, dbt, and Looker.

---

## Folder Structure & Components

```
Bolt/
├── models/
│   ├── staging/
│   │   ├── stg_customers.sql
│   │   ├── stg_aeroplane_models.sql
│   │   ├── stg_trips.sql
│   ├── marts/
│   │   ├── dim_customers.sql
│   │   ├── dim_aeroplane_models.sql
│   ├── facts/
│   │   ├── fct_trips.sql
│   ├── sources/
│   │   └── trips_source.yml
│   └── schema.yml
│
├── seeds/
│   ├── customers.csv
│   ├── aeroplane_models.csv  # Flattened from JSON
│   └── trips.csv             # Synthetic fact data
│
├── macros/
│   ├── check_valid_email.sql
│   ├── check_standard_phone_format.sql
│   └── check_positive_ticket_price.sql
│
├── snapshots/
│   └── trips_snapshot.sql
│
├── dbt_project.yml
├── packages.yml (optional)
├── README.md
├── .pre-commit-config.yaml
├── .sqlfluff
└── requirements.txt
```

---

## ERD Design Rationale
To provide a visual understanding of the data flow, I have included a complete Entity Relationship Diagram (ERD) that reflects the modeling strategy applied. The ERD captures the lineage from raw seed inputs (CSV) through staging, transformations, dimensions, facts, and snapshots. Relationships are explicitly defined, including foreign key constraints where applicable (e.g., fct_trips.customer_id → dim_customers.customer_id). This structure reinforces a Kimball-style star schema optimized for analytical performance and scalability. It also illustrates data normalization, surrogate keys (e.g., aircraft_model), and snapshot tracking via Slowly Changing Dimensions (SCD2). The ERD supports stakeholder alignment and is critical for downstream tool integration like Looker explores or lineage visualizations in dbt Cloud.

Bolt/assets/AirBoltic_ERD.png

## Data Model Overview

The core of this solution follows a Kimball-style dimensional model for analytical scalability:

### Seeds

Three CSV files were provided and seeded into the database:

* customers.csv

* aeroplane_models.csv

* trips.csv

These are accessible via dbt’s ref() function and simulate data coming from a raw data lake or external S3 source.


### Staging Layer

* Cleans raw seed data.
* Handles type casting, missing/null values, and formatting.
* Normalizes columns such as email and phone numbers.

### Dimensional Marts

* `dim_customers`: Includes clean, enriched customer data.
* `dim_aeroplane_models`: Captures aircraft specs with derived fields like weight per seat.

### Fact Tables

* `fct_trips`: Tracks individual flight activities with metrics like ticket price, distance, and duration.
* Implemented as incremental model using `updated_at` field to ensure performance over time.

---

## Testing & Validation

Custom and built-in dbt tests ensure data quality:

* Not null and uniqueness checks on primary keys.
* Custom macros:

  * `check_valid_email`:  Validates that email addresses follow correct syntax.
  * `check_standard_phone_format`: Ensures phone numbers only include digits and the '+' sign.
  * `check_positive_ticket_price`: Enforces positive pricing logic.

These are applied through schema.yml as reusable tests.

---

## Freshness Monitoring

A source file source.yml was created to simulate real-time ingestion with a loaded_at_field. Freshness monitoring was added using warn_after and error_after thresholds.

Since the trips table is seeded via CSV and not connected to a real streaming ingestion system, freshness monitoring is included as an illustrative setup. If connected to S3 or a cloud warehouse ingestion path, this configuration would actively monitor latency.
```yaml
freshness:
  warn_after: {count: 1, period: day}
  error_after: {count: 2, period: day}
```

---

## Snapshots

A snapshot was created on the `trips` table to simulate tracking of historical changes. While this is synthetic here, it reflects how dbt snapshots could be used in production to capture late-arriving changes or slow-changing dimensions(SCD2).

---

## DevOps & Engineering Best Practices
This project is structured to align with modern data engineering standards and is ready for CI/CD integration using tools like GitHub Actions and dbt.

* **Modular Codebase**
I organized the project into logical components — seeds, staging, marts, facts, macros, and snapshots — to make the code easy to navigate and extend. This separation of concerns ensures that each layer has a clear purpose and is testable independently.

* **Built-in Testing and Documentation**
I've used schema.yml to define model-level documentation and integrated both standard and custom tests. The custom macros validate domain-specific rules like email formatting, phone number structure, and positive pricing logic. These are reusable across models and ensure consistency across the pipeline.

* **CI/CD Ready**
The structure is designed for integration with GitHub Actions and dbt Cloud, supporting automated workflows such as pull request checks, scheduled jobs, and deployment processes. Everything is version-controlled to facilitate team collaboration.

* **Linting & Pre-Commit Hooks**
I included a .pre-commit-config.yaml and SQLFluff configuration to catch formatting issues before they reach production. These hooks help enforce coding standards automatically, saving review cycles and reducing human error.

* **Environment Reproducibility**
A requirements.txt file is provided to reproduce the environment across machines or CI agents. This ensures smooth onboarding and consistent execution, regardless of where the code runs.

---

## Aligning with Bolt's Stack

This project is intentionally modeled to align with the tools Bolt uses:

* **S3**: In production, the `trips`, `customers`, and `airplanes` datasets would be ingested as Parquet or JSON files into S3. That would replace our static seeds.
* **Databricks**: The dbt models can be configured to run on a Spark adapter within Databricks, which would scale transformations.
* **dbt**: All transformations are written using dbt best practices, including incremental logic and tests.
* **Looker**: The final `dim_*` and `fct_*` tables are Looker-ready. Clean naming, null-guarded fields, and clear dimensional relationships support robust explores.
* **GitHub**: This entire repo is structured to support version control, PR reviews, and deployment pipelines.

---

## Why No Intermediate Models?

In this setup, staging models were straightforward enough and didn’t require a middle layer. However, in a scaled-out system with heavier joins and aggregations, intermediate models (e.g., `int_trip_enrichments`) would be introduced to segment logic. That would also improve maintainability and testing coverage.

---

## What’s Next (If Time Permitted)

* Add `fct_orders` to analyze booking and revenue flows.
* Create `dim_airplanes` joining aircrafts with their model.
* Ingest data from cloud storage or simulated Kafka stream.
* Define and run CI/CD workflows in GitHub Actions.
* Add column-level lineage with dbt Semantic Layer or Catalog.
* Build LookML views based on marts for self-serve BI.
* Apply row-level security and role-based access.

---


