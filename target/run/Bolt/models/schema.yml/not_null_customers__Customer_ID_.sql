select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select "Customer ID"
from "air_boltic"."public_public"."customers"
where "Customer ID" is null



      
    ) dbt_internal_test