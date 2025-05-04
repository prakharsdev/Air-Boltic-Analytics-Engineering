
select *
from "air_boltic"."public"."stg_customers"
where phone_number is not null
  and phone_number ~ '[^+0-9]'
