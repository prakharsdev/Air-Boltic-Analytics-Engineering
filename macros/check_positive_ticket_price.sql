-- Custom test: Ensure ticket_price > 0
{% test check_positive_ticket_price(model, column_name) %}
select *
from {{ model }}
where {{ column_name }} <= 0
{% endtest %}
