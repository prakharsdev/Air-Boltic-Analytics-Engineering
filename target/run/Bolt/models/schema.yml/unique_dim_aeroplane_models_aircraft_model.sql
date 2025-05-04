select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    

select
    aircraft_model as unique_field,
    count(*) as n_records

from "air_boltic"."public"."dim_aeroplane_models"
where aircraft_model is not null
group by aircraft_model
having count(*) > 1



      
    ) dbt_internal_test