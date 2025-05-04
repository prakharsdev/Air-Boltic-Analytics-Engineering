
      
        
        
        delete from "air_boltic"."public"."fct_trips" as DBT_INTERNAL_DEST
        where (trip_id) in (
            select distinct trip_id
            from "fct_trips__dbt_tmp041706019067" as DBT_INTERNAL_SOURCE
        );

    

    insert into "air_boltic"."public"."fct_trips" ("trip_id", "customer_id", "model", "departure_date", "ticket_price", "distance_km", "flight_duration_minutes", "created_at", "updated_at")
    (
        select "trip_id", "customer_id", "model", "departure_date", "ticket_price", "distance_km", "flight_duration_minutes", "created_at", "updated_at"
        from "fct_trips__dbt_tmp041706019067"
    )
  