﻿-- create table for many-to-many mapping of geounits to geolevels
CREATE TABLE redistricting_geounit_geolevel
(
  id serial NOT NULL,
  geounit_id integer NOT NULL,
  geolevel_id integer NOT NULL,
  CONSTRAINT redistricting_geounit_geolevel_pkey PRIMARY KEY (id),
  CONSTRAINT redistricting_geounit_geolevel_geolevel_id_fkey FOREIGN KEY (geolevel_id)
      REFERENCES redistricting_geolevel (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT redistricting_geounit_geolevel_geounit_id_fkey FOREIGN KEY (geounit_id)
      REFERENCES redistricting_geounit (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT redistricting_geounit_geolevel_geounit_id_key UNIQUE (geounit_id, geolevel_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE redistricting_geounit_geolevel OWNER TO publicmapping;

-- populate relationship table
INSERT INTO redistricting_geounit_geolevel(geounit_id, geolevel_id)
  SELECT id AS geounit_id, geolevel_id FROM redistricting_geounit

-- remove geolevel column from geounit table
-- this also removes all related views (which need to be regenerated)
ALTER TABLE redistricting_geounit DROP COLUMN geolevel_id CASCADE;
