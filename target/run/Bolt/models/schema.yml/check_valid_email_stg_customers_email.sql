select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
select *
from"air_boltic"."public"."stg_customers"
where email is not null
  and email not like '%@%.%'

      
    ) dbt_internal_test