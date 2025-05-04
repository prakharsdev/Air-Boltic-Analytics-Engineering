select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
select *
from "air_boltic"."public"."stg_customers"
where phone_number is not null
  and phone_number ~ '[^+0-9]'

      
    ) dbt_internal_test