CREATE OR REPLACE VIEW lts.pir_motion_view
 AS
 SELECT latest_thing_configs_view.thing_name,
    pir_motion.measurement_time,
    pir_motion.value,
    latest_thing_property_configs_view.measurement_unit
   FROM lts.latest_thing_configs_view
     JOIN lts.latest_thing_property_configs_view ON latest_thing_property_configs_view.thing_id::text = latest_thing_configs_view.thing_id::text
     JOIN lts.pir_motion ON pir_motion.property_id::text = latest_thing_property_configs_view.property_id::text
  ORDER BY latest_thing_configs_view.thing_name, pir_motion.measurement_time;
  

REVOKE ALL ON TABLE lts.pir_motion_view FROM web_anon;
GRANT ALL ON TABLE lts.pir_motion_view TO digilab;
GRANT SELECT ON TABLE lts.pir_motion_view TO web_anon;

