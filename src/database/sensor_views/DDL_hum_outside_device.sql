CREATE OR REPLACE VIEW lts.hum_outside_device_view
 AS
 SELECT latest_thing_configs_view.thing_name,
    hum_outside_device.measurement_time,
    hum_outside_device.value,
    latest_thing_property_configs_view.measurement_unit
   FROM lts.latest_thing_configs_view
     JOIN lts.latest_thing_property_configs_view ON latest_thing_property_configs_view.thing_id::text = latest_thing_configs_view.thing_id::text
     JOIN lts.hum_outside_device ON hum_outside_device.property_id::text = latest_thing_property_configs_view.property_id::text
  ORDER BY latest_thing_configs_view.thing_name, hum_outside_device.measurement_time;


REVOKE ALL ON TABLE lts.hum_outside_device_view FROM web_anon;
GRANT ALL ON TABLE lts.hum_outside_device_view TO digilab;
GRANT SELECT ON TABLE lts.hum_outside_device_view TO web_anon;

