
  
    

  create  table "air_boltic"."public"."dim_aeroplane_models__dbt_tmp"
  
  
    as
  
  (
    -- models/marts/dimensions/dim_aeroplane_models.sql

select
    max_seats,
    max_weight,
    max_distance,
    engine_type,
    lower(manufacturer) as manufacturer,
    lower(model) as aircraft_model,
    round(max_weight::numeric / nullif(max_seats, 0), 2) as weight_per_seat
from "air_boltic"."public"."stg_aeroplane_models"
  );
  