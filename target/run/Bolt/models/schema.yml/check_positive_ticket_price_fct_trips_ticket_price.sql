select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
select *
from "air_boltic"."public"."fct_trips"
where ticket_price <= 0

      
    ) dbt_internal_test