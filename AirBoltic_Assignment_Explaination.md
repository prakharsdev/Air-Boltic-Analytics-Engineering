**Air Boltic Analytics Engineer Test Assignment: Detailed Answers and Thought Process**

---

## Part 1: Designing a Scalable Data Model for Air Boltic

### Objective

The goal of Part 1 was to design a data model that enables robust monitoring and self-service analytics for the Air Boltic marketplace, with scalability in mind for potential global expansion. The dataset provided was a simplified representation, but I approached the task as if I were building a production-grade, dimensional model compatible with modern analytics stacks.

### Thought Process and Design Rationale

#### 1. **Understand the Business Model First**

Before touching the data, I focused on understanding the core of Air Boltic’s business: it is a two-sided marketplace facilitating private or group air travel. So, like Bolt’s existing businesses, we have suppliers (aeroplane operators), consumers (customers), and a transactional layer (orders and trips). Recognizing these roles helped shape the conceptual model around Fact and Dimension tables.

#### 2. **Choosing a Dimensional Modeling Approach**

Given the focus on reporting and self-service analytics (via Looker), I used a **Kimball-style dimensional model**. This method provides clarity, separation of concerns, and intuitive reporting layers. I designed clear **fact tables** (e.g., `fct_trips`) and **dimension tables** (e.g., `dim_customers`, `dim_aeroplane_models`) that support analytical queries across customer behavior and flight operations.

While `fct_orders` and `dim_routes` are not implemented in this assignment, they were considered during the design phase as logical next extensions to support order-level revenue analysis and geographic aggregations, respectively.

---

#### 3. **Key Decisions in the Model**

* **Normalization where necessary:** Dimensions are de-duplicated and centralized to reduce maintenance and support flexible joins.
* **Snapshotting for slow-changing dimensions:** For airplane models and customer data, I considered slowly changing attributes and demonstrated how `dbt snapshots` could track changes over time (see `snapshots/`).
* **Fact granularity:**

  * `fct_trips`: One row per trip — supports duration, pricing, and distance-based analysis.
  * `fct_orders`: Not implemented here, but envisioned as a future table representing seat-level booking activity.
* **Route dimension (not implemented):** Recognizing origin/destination as key metrics, a `dim_routes` table could be introduced in the future to simplify route-based metrics.
* **Metrics layer flexibility:** Key KPIs like `trip fill rate`, `revenue by region`, or `trip frequency per user` can be derived from the core tables and exposed through Looker explores or a metrics layer.


#### 4. **Tooling Choices**

Because the stack includes **S3 + Databricks + dbt + Looker**, I built the project as a dbt project (`air_boltic/`) with proper modularity:

* `staging/` layer for raw ingestion
* `intermediate/` for cleansing and enrichment
* `marts/` for business-ready dimensional models
* Custom tests (e.g., `check_valid_email.sql`, `check_positive_ticket_price.sql` and `check_standard_phone_format.sql`) to ensure data quality

This structure is explained in the [`README.md`](https://github.com/prakharsdev/Air-Boltic-Analytics-Engineering/blob/master/README.md) where I documented how each layer is aligned with best practices.

#### 5. **Schema File + ERD**

I included both a logical ERD (to show relationships) and a set of `schema.yml` and `CREATE TABLE`-style definitions in dbt to describe the physical implementation.

#### 6. **Limitations and Next Steps (If I Had More Time)**

* Add performance benchmarking for large-scale joins
* Use `dbt-expectations` for more expressive tests
* Incorporate a metrics layer using `dbt-metricflow`
* Automate data freshness alerts with dbt Cloud or Airflow

---

## Part 2: CI/CD Strategy for Scalable and Maintainable Analytics

### Ideal World: Unlimited Resources

#### 1. **Environment Setup**

I would implement a 3-tier environment setup:

* `dev`: For individual feature branches
* `staging`: For QA testing and stakeholder previews
* `prod`: Live reporting layer

Each environment would be isolated in Databricks (separate schemas/workspaces) and connected to separate Looker models.

#### 2. **Version Control & CI Pipelines**

Using GitHub Actions or dbt Cloud CI, every PR would:

* Run `dbt build` with full test suite
* Lint models and enforce naming conventions
* Run custom schema validations and freshness checks
* Generate updated documentation with `dbt docs`
* Preview Looker model diffs (if integrated)

#### 3. **Monitoring and Alerts**

* Use dbt artifacts + Monte Carlo/Elementary for anomaly detection
* Data freshness dashboards in Looker
* Slack/Email alerts for test failures or data delays

#### 4. **Deployment Flow**

* PR reviewed and approved
* CI passes on staging
* Merge to `main` triggers deploy to production
* dbt Cloud schedules or Airflow DAGs update downstream models

---

### Real-World: With Constraints

#### Low-Effort / Short-Term Improvements:

* Add dbt tests for nulls, uniqueness, and relationships
* Use `pre-commit` hooks for linting and SQL formatting
* Schedule nightly full builds on Databricks + alerts via Slack webhook

#### High-Effort / Long-Term Investments:

* Introduce a semantic layer (LookML or MetricFlow)
* Build a metadata layer to trace field usage and downstream impact
* Automate end-to-end lineage using tools like OpenMetadata or Marquez

---

### My Experience Applied

At Bondora, I built and maintained dbt models in a multi-environment setup where data consistency and stakeholder trust were essential. I applied similar practices like snapshots, version-controlled deployments, and rigorous testing. These lessons directly informed how I approached the Air Boltic assignment.

I've also worked with imperfect tools in earlier-stage companies, where I had to implement lightweight alerting with `dbt run` + Slack notifications, and I leveraged tools like `great_expectations` and `Elementary` for cost-effective data monitoring.

---

### Summary

This assignment was a chance to demonstrate my experience designing clean, scalable, and trustworthy analytics infrastructure. All of my choices—from schema layout to CI/CD design—were driven by my experience building real-world systems that balance structure and agility. My [`README.md`](https://github.com/prakharsdev/Air-Boltic-Analytics-Engineering/blob/master/README.md) provides full documentation of the data model, assumptions, structure, and next steps for scaling this project into production.
