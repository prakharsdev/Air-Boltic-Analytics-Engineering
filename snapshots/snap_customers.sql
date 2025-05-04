-- snapshots/snap_customers.sql
{% snapshot snap_customers %}
{{
  config(
    target_schema='snapshots',
    unique_key='customer_id',
    strategy='check',
    check_cols=['customer_group_id', 'email', 'phone_number']
  )
}}

select * from {{ ref('stg_customers') }}

{% endsnapshot %}
