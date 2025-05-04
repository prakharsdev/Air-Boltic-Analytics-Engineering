-- Custom test: Valid email format
{% test check_valid_email(model, column_name) %}
select *
from{{ model }}
where {{ column_name }} is not null
  and {{ column_name }} not like '%@%.%'
{% endtest %}