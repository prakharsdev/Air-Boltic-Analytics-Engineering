
    
    

select
    trip_id as unique_field,
    count(*) as n_records

from "air_boltic"."public"."fct_trips"
where trip_id is not null
group by trip_id
having count(*) > 1


