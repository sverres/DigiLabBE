CREATE OR REPLACE VIEW lts.latest_measurements_view
 AS
 SELECT s1.thing_name,
    s1.sensor,
    s1.latest_measurement
   FROM ( SELECT temp_outside_device_view.thing_name,
            'temp_outside_device'::text AS sensor,
            max(temp_outside_device_view.measurement_time) AS latest_measurement
           FROM lts.temp_outside_device_view
          GROUP BY temp_outside_device_view.thing_name
        UNION
         SELECT temp_inside_device_view.thing_name,
            'temp_inside_device'::text AS sensor,
            max(temp_inside_device_view.measurement_time) AS latest_measurement
           FROM lts.temp_inside_device_view
          GROUP BY temp_inside_device_view.thing_name
        UNION
         SELECT hum_inside_device_view.thing_name,
            'hum_inside_device'::text AS sensor,
            max(hum_inside_device_view.measurement_time) AS latest_measurement
           FROM lts.hum_inside_device_view
          GROUP BY hum_inside_device_view.thing_name
        UNION
         SELECT hum_outside_device_view.thing_name,
            'hum_outside_device'::text AS sensor,
            max(hum_outside_device_view.measurement_time) AS latest_measurement
           FROM lts.hum_outside_device_view
          GROUP BY hum_outside_device_view.thing_name
        UNION
         SELECT air_pressure_view.thing_name,
            'air_pressure'::text AS sensor,
            max(air_pressure_view.measurement_time) AS latest_measurement
           FROM lts.air_pressure_view
          GROUP BY air_pressure_view.thing_name
        UNION
         SELECT pir_motion_view.thing_name,
            'pir_motion'::text AS sensor,
            max(pir_motion_view.measurement_time) AS latest_measurement
           FROM lts.pir_motion_view
          GROUP BY pir_motion_view.thing_name
        UNION
         SELECT illuminance_view.thing_name,
            'illuminance'::text AS sensor,
            max(illuminance_view.measurement_time) AS latest_measurement
           FROM lts.illuminance_view
          GROUP BY illuminance_view.thing_name) s1
  ORDER BY s1.latest_measurement DESC;

ALTER TABLE lts.latest_measurements_view
    OWNER TO digilab;

REVOKE ALL ON TABLE lts.latest_measurements_view FROM web_anon;
GRANT ALL ON TABLE lts.latest_measurements_view TO digilab;
GRANT SELECT ON TABLE lts.latest_measurements_view TO web_anon;