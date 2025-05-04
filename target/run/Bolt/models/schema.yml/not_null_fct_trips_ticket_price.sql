select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select ticket_price
from "air_boltic"."public"."fct_trips"
where ticket_price is null



      
    ) dbt_internal_test