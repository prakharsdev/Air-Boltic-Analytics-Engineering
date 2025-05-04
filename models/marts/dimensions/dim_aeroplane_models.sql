-- models/marts/dimensions/dim_aeroplane_models.sql

select
    max_seats,
    max_weight,
    max_distance,
    engine_type,
    lower(manufacturer) as manufacturer,
    lower(model) as aircraft_model,
    round(max_weight::numeric / nullif(max_seats, 0), 2) as weight_per_seat
from {{ ref('stg_aeroplane_models') }}
