
  
    

  create  table "air_boltic"."public"."dim_customers__dbt_tmp"
  
  
    as
  
  (
    -- models/marts/dimensions/dim_customers.sql

select
    customer_id,
    customer_group_id,
    phone_number,
    initcap(customer_name) as customer_name,
    lower(email) as email_cleaned
from "air_boltic"."public"."stg_customers"
  );
  