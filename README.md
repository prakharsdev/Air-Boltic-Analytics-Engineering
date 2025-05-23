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
- **Full Project Demo video:** 
- [![Demo video](https://github.com/user-attachments/assets/5f885bd7-e9d1-48f2-9aec-76d920cfe9f6)](https://www.youtube.com/watch?v=i0dSKAp4tdE)
  
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

![ERD](https://github.com/prakharsdev/Air-Boltic-Analytics-Engineering/blob/master/assets/AirBoltic_ERD.png)

## Data Model Overview

The core of this solution follows a Kimball-style dimensional model for analytical scalability:

### Seeds

Three CSV files were provided and seeded into the database:

* customers.csv

* aeroplane_models.csv

* trips.csv

These are accessible via dbt’s ref() function and simulate data coming from a raw data lake or external S3 source.

### Synthetic Data Source: `trips.csv`

The `trips.csv` file included in the `seeds/` directory is manually generated synthetic data to simulate a realistic fact table of flight activity. Since no real transactional dataset was available, I curated this data based on plausible assumptions for:

* Customer-to-flight mappings
* Flight durations
* Departure dates across a historical window
* Ticket pricing logic
* Route distances and timestamps

**Purpose of `trips.csv`**:

* To enable meaningful transformation logic in `stg_trips` and `fct_trips`
* To demonstrate how incremental loading can work using the `updated_at` timestamp
* To build and test dbt snapshot capabilities on time-evolving data

In production, this data would originate from a real-time order or booking system and land in cloud storage (e.g., S3). But for this assignment, it serves as a strong foundation for simulating downstream modeling, testing, and freshness monitoring workflows.


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

## Local Setup & Environment

### Prerequisites

Ensure the following are installed on your machine:

* **Conda** (Miniconda or Anaconda)
* **PostgreSQL** (13 or above)
* **pgAdmin 4**
* **Git**
* **dbt CLI v1.9.4** (Python-based)

### Conda Environment Setup

```bash
conda create -n bolt-dbt-env python=3.10 -y
conda activate bolt-dbt-env
pip install -r requirements.txt
dbt deps
dbt --version
```

---

## dbt Configuration

Create or update your `profiles.yml` file in the `.dbt` directory (e.g. `C:\Users\<YourUsername>\.dbt\profiles.yml`):

```yaml
Bolt:
  target: dev
  outputs:
    dev:
      type: postgres
      host: localhost
      user: postgres
      password: your_password
      port: 5432
      dbname: air_boltic
      schema: public
      threads: 4
```

---

## PostgreSQL & pgAdmin Setup

1. **Install PostgreSQL and pgAdmin**
   Use the official installer from: [https://www.postgresql.org/download/](https://www.postgresql.org/download/)

2. **Create the `air_boltic` database**
   Open pgAdmin, right-click on "Databases" → Create → Database → Name it `air_boltic`.

3. **Enable user privileges**
   Ensure your PostgreSQL role (e.g. `postgres`) has `CREATE` and `ALL` privileges on the `air_boltic` database.

4. **Verify via pgAdmin**
   After running `dbt run`, inspect tables like `fct_trips`, `dim_customers`, etc., under the `public` schema.

---

## Running the Project

```bash
dbt seed
dbt run
dbt test
dbt snapshot
```

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
  I included a `.pre-commit-config.yaml` and SQLFluff configuration to catch formatting issues before they reach production. These hooks help enforce coding standards automatically, saving review cycles and reducing human error.

### Pre-Commit Hook Usage (Local Workflow)

This project uses [`pre-commit`](https://pre-commit.com/) hooks to enforce coding standards and prevent poor formatting from being committed into the repo.

**Setup once:**

```bash
pre-commit install
```

This will register the hooks specified in `.pre-commit-config.yaml` to run automatically before every commit.

**What happens on `git commit`:**

* `sqlfluff lint` will validate SQL files based on configured dialect and style rules (in `.sqlfluff`).
* If any linting or formatting issue is found, the commit will fail with a detailed message showing what needs fixing.
* Once fixed, simply `git add` and `git commit` again.

This ensures code consistency, prevents manual errors, and maintains high-quality SQL structure throughout the project lifecycle.

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

## 📄 Further Explanation

For a full breakdown of the design decisions and CI/CD strategy, see [AirBoltic_Assignment_Explanation.md](https://github.com/prakharsdev/Air-Boltic-Analytics-Engineering/blob/master/AirBoltic_Assignment_Explaination.md).
