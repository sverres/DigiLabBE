CREATE OR REPLACE VIEW lts.noise_view
 AS
 SELECT latest_thing_configs_view.thing_name,
    noise.measurement_time,
    noise.value,
    latest_thing_property_configs_view.measurement_unit
   FROM lts.latest_thing_configs_view
     JOIN lts.latest_thing_property_configs_view ON latest_thing_property_configs_view.thing_id::text = latest_thing_configs_view.thing_id::text
     JOIN lts.noise ON noise.property_id::text = latest_thing_property_configs_view.property_id::text
  ORDER BY latest_thing_configs_view.thing_name, noise.measurement_time;


REVOKE ALL ON TABLE lts.noise_view FROM web_anon;
GRANT ALL ON TABLE lts.noise_view TO digilab;
GRANT SELECT ON TABLE lts.noise_view TO web_anon;

