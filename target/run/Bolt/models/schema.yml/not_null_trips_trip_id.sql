select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select trip_id
from "air_boltic"."public_public"."trips"
where trip_id is null



      
    ) dbt_internal_test