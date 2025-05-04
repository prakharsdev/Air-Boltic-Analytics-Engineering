
select *
from"air_boltic"."public"."stg_customers"
where email is not null
  and email not like '%@%.%'
