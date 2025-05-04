select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    

select
    model as unique_field,
    count(*) as n_records

from "air_boltic"."public_public"."aeroplane_models"
where model is not null
group by model
having count(*) > 1



      
    ) dbt_internal_test