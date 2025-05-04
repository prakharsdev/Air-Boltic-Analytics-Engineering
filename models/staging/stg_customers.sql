-- models/staging/stg_customers.sql

select
    "Name" as customer_name,
    "Email" as email,
    cast("Customer ID" as int) as customer_id,
    cast("Customer Group ID" as int) as customer_group_id,
    regexp_replace("Phone Number", '[^+0-9]', '', 'g') as phone_number
from {{ ref('customers') }}

