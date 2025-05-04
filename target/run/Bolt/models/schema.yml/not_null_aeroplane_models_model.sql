select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select model
from "air_boltic"."public_public"."aeroplane_models"
where model is null



      
    ) dbt_internal_test