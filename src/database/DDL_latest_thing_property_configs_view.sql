CREATE OR REPLACE VIEW lts.latest_thing_property_configs_view
 AS
 WITH latest_thing_property_config AS (
         SELECT thing_property_configs_1.thing_id,
            thing_property_configs_1.property_id,
            max(thing_property_configs_1.create_time) AS thing_property_configs_create_time
           FROM lts.thing_property_configs thing_property_configs_1
          GROUP BY thing_property_configs_1.thing_id, thing_property_configs_1.property_id
        )
 SELECT latest_thing_property_config.thing_id,
    latest_thing_property_config.property_id,
    latest_thing_property_config.thing_property_configs_create_time,
    thing_property_configs.variable_name,
    thing_property_configs.measurement_unit
   FROM latest_thing_property_config
     JOIN lts.thing_property_configs ON latest_thing_property_config.thing_id::text = thing_property_configs.thing_id::text AND latest_thing_property_config.property_id::text = thing_property_configs.property_id::text AND latest_thing_property_config.thing_property_configs_create_time::text = thing_property_configs.create_time::text;

ALTER TABLE lts.latest_thing_property_configs_view
    OWNER TO digilab;