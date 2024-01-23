CREATE OR REPLACE VIEW lts.air_pressure_view
 AS
 SELECT latest_thing_configs_view.thing_name,
    air_pressure.measurement_time,
    air_pressure.value,
    latest_thing_property_configs_view.measurement_unit
   FROM lts.latest_thing_configs_view
     JOIN lts.latest_thing_property_configs_view ON latest_thing_property_configs_view.thing_id::text = latest_thing_configs_view.thing_id::text
     JOIN lts.air_pressure ON air_pressure.property_id::text = latest_thing_property_configs_view.property_id::text
  ORDER BY latest_thing_configs_view.thing_name, air_pressure.measurement_time;
  

REVOKE ALL ON TABLE lts.air_pressure_view FROM web_anon;
GRANT ALL ON TABLE lts.air_pressure_view TO digilab;
GRANT SELECT ON TABLE lts.air_pressure_view TO web_anon;

