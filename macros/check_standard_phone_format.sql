-- Custom test: Phone number only contains digits and '+'
{% test check_standard_phone_format(model, column_name) %}
select *
from {{ model }}
where {{ column_name }} is not null
  and {{ column_name }} ~ '[^+0-9]'
{% endtest %}
