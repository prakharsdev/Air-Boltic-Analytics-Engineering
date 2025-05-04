
    
    

select
    model as unique_field,
    count(*) as n_records

from "air_boltic"."public_public"."aeroplane_models"
where model is not null
group by model
having count(*) > 1


