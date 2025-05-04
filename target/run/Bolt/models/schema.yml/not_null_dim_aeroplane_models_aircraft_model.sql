select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select aircraft_model
from "air_boltic"."public"."dim_aeroplane_models"
where aircraft_model is null



      
    ) dbt_internal_test