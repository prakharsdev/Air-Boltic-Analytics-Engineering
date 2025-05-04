-- models/marts/facts/fct_trips.sql

{{ config(
    materialized='incremental',
    unique_key='trip_id'
) }}

select
    stg.trip_id,
    stg.customer_id,
    stg.model,
    stg.departure_date,
    stg.ticket_price,
    stg.distance_km,
    stg.flight_duration_minutes,
    stg.created_at,
    stg.updated_at
from {{ ref('stg_trips') }} as stg

{% if is_incremental() %}
    where stg.updated_at > (
        select max(this.updated_at)
        from {{ this }} as this
    )
{% endif %}