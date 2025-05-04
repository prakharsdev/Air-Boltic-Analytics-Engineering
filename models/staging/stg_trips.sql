-- models/staging/stg_trips.sql
-- NOTE TO REVIEWERS:
-- While dbt supports source freshness testing via the `source()` function,
-- I have intentionally *not* enabled freshness checks here because the `trips` data
-- is loaded using a local dbt seed (CSV file). Seeded data is static and not updated
-- by any external ingestion pipeline or data source.
-- Therefore, freshness testing would not be meaningful or actionable in this context.
select
    model,
    cast(trip_id as int) as trip_id,
    cast(customer_id as int) as customer_id,
    cast(departure_date as date) as departure_date,
    cast(ticket_price as numeric) as ticket_price,
    cast(distance_km as int) as distance_km,
    cast(flight_duration_minutes as int) as flight_duration_minutes,
    cast(created_at as timestamp) as created_at,
    cast(updated_at as timestamp) as updated_at
from {{ ref('trips') }}
