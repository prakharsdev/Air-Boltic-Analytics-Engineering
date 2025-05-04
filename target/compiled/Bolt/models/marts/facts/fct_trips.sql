-- models/marts/facts/fct_trips.sql



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
from "air_boltic"."public"."stg_trips" as stg


    where stg.updated_at > (
        select max(this.updated_at)
        from "air_boltic"."public"."fct_trips" as this
    )
