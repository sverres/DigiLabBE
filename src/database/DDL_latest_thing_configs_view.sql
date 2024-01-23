CREATE OR REPLACE VIEW lts.latest_thing_configs_view
 AS
CREATE OR REPLACE VIEW lts.latest_thing_configs_view
 AS
 WITH latest_thing_config AS (
         SELECT thing_configs_1.thing_id,
            max(thing_configs_1.create_time) AS thing_configs_create_time
           FROM lts.thing_configs thing_configs_1
          GROUP BY thing_configs_1.thing_id
        )
 SELECT latest_thing_config.thing_id,
    latest_thing_config.thing_configs_create_time,
    thing_configs.thing_name,
    things.site_id
   FROM latest_thing_config
     JOIN lts.thing_configs ON thing_configs.thing_id::text = latest_thing_config.thing_id::text AND thing_configs.create_time::text = latest_thing_config.thing_configs_create_time::text
     JOIN lts.things ON latest_thing_config.thing_id::text = things.thing_id::text
  ORDER BY things.site_id, thing_configs.thing_name;

ALTER TABLE lts.latest_thing_configs_view
    OWNER TO digilab;

