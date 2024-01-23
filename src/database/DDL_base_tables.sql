CREATE TABLE  lts.sites
(
    site_id character varying(36) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT sites_pkey PRIMARY KEY (site_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS lts.sites
    OWNER to digilab;


CREATE TABLE lts.things
(
    thing_id character varying(36) COLLATE pg_catalog."default" NOT NULL,
    site_id character varying(36) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT things_pkey PRIMARY KEY (thing_id),
    CONSTRAINT things_fk FOREIGN KEY (site_id)
        REFERENCES lts.sites (site_id) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS lts.things
    OWNER to digilab;


CREATE TABLE  lts.thing_configs
(
    thing_id character varying(36) COLLATE pg_catalog."default" NOT NULL,
    create_time timestamp with time zone NOT NULL,
    thing_name character varying(36) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT thing_configs_pkey PRIMARY KEY (thing_id, create_time),
    CONSTRAINT thing_configs_fk FOREIGN KEY (thing_id)
        REFERENCES lts.things (thing_id) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS lts.thing_configs
    OWNER to digilab;


CREATE TABLE  lts.thing_properties
(
    property_id character varying(36) COLLATE pg_catalog."default" NOT NULL,
    thing_id character varying(36) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT thing_properties_pkey PRIMARY KEY (property_id),
    CONSTRAINT thing_properties_fk FOREIGN KEY (thing_id)
        REFERENCES lts.things (thing_id) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE NO ACTION
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS lts.thing_properties
    OWNER to digilab;


CREATE TABLE  lts.thing_property_configs
(
    property_id character varying(36) COLLATE pg_catalog."default" NOT NULL,
    thing_id character varying(36) COLLATE pg_catalog."default" NOT NULL,
    create_time timestamp with time zone NOT NULL,
    variable_name character varying(36) COLLATE pg_catalog."default" NOT NULL,
    measurement_unit character varying(36) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT thing_property_configs_pkey PRIMARY KEY (property_id, create_time),
    CONSTRAINT thing_property_configs_fk FOREIGN KEY (property_id)
        REFERENCES lts.thing_properties (property_id) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS lts.thing_property_configs
    OWNER to digilab;


REVOKE ALL ON TABLE lts.sites FROM web_anon;
GRANT ALL ON TABLE lts.sites TO digilab;
GRANT SELECT ON TABLE lts.sites TO web_anon;

REVOKE ALL ON TABLE lts.things FROM web_anon;
GRANT ALL ON TABLE lts.things TO digilab;
GRANT SELECT ON TABLE lts.things TO web_anon;

REVOKE ALL ON TABLE lts.thing_configs FROM web_anon;
GRANT ALL ON TABLE lts.thing_configs TO digilab;
GRANT SELECT ON TABLE lts.thing_configs TO web_anon;

REVOKE ALL ON TABLE lts.thing_properties FROM web_anon;
GRANT ALL ON TABLE lts.thing_properties TO digilab;
GRANT SELECT ON TABLE lts.thing_properties TO web_anon;

REVOKE ALL ON TABLE lts.thing_property_configs FROM web_anon;
GRANT ALL ON TABLE lts.thing_property_configs TO digilab;
GRANT SELECT ON TABLE lts.thing_property_configs TO web_anon;























