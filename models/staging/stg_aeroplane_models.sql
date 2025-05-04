-- models/staging/stg_aeroplane_models.sql

select
    manufacturer,
    model,
    engine_type,
    cast(max_seats as int) as max_seats,
    cast(max_weight as int) as max_weight,
    cast(max_distance as int) as max_distance
from {{ ref('aeroplane_models') }}
