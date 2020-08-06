DROP TABLE IF EXISTS missile_launches CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS divisions CASCADE;
DROP TABLE IF EXISTS system_characteristics CASCADE;
DROP TABLE IF EXISTS target_to_marks CASCADE;
DROP TABLE IF EXISTS targets CASCADE;
DROP TABLE IF EXISTS target_marks CASCADE;


CREATE TABLE target_marks (
	target_mark_id serial PRIMARY KEY,
	dttm timestamp NOT NULL,
	latitude float NOT NULL CHECK (latitude BETWEEN -90.0 AND 90.0),
	longtitude float NOT NULL CHECK (longtitude BETWEEN -180.0 AND 180.0),
	height float NOT NULL CHECK (height >= 0.0),
	velocity float NOT NULL CHECK (velocity >= 0.0),
	direction float NOT NULL CHECK (direction BETWEEN 0.0 AND 360.0),
	source text NOT NULL
);
GRANT SELECT ON target_marks TO observer;
GRANT SELECT, INSERT ON target_marks TO radar_operator;
GRANT USAGE ON target_marks_target_mark_id_seq TO radar_operator;

CREATE TABLE targets (
	target_id serial PRIMARY KEY,
	target_description text,
	is_military boolean NOT NULL,
	country text NOT NULL
);
GRANT SELECT ON targets TO observer;
GRANT SELECT, INSERT ON targets TO radar_operator;
GRANT USAGE ON targets_target_id_seq TO radar_operator;

CREATE TABLE target_to_marks (
	target_id integer REFERENCES targets,
	target_mark_id integer PRIMARY KEY REFERENCES target_marks ON DELETE RESTRICT
	-- PRIMARY KEY (target_id, target_mark_id) -- было бы верно, если в одной отметке могло бы находится несколько целей
);
GRANT SELECT ON target_to_marks TO observer;
GRANT SELECT, INSERT ON target_to_marks TO radar_operator;

CREATE TABLE system_characteristics (
	system_id serial PRIMARY KEY,
	system_type text NOT NULL,
	max_range float NOT NULL CHECK (max_range > 0.0),
	min_range float NOT NULL CHECK (min_range >= 0.0),
	max_height float NOT NULL CHECK (max_height > 0.0),
	min_height float NOT NULL CHECK (min_height >= 0.0),
	max_velocity float NOT NULL CHECK (max_velocity >= 0.0),
	CHECK (max_range > min_range),
	CHECK (max_height > min_height)
);
GRANT SELECT ON system_characteristics TO observer;
GRANT INSERT ON system_characteristics TO division_commander;
GRANT USAGE ON system_characteristics_system_id_seq TO division_commander;

CREATE TABLE divisions (
	division_id serial PRIMARY KEY,
	division_name text NOT NULL,
	latitude float NOT NULL CHECK (latitude BETWEEN -90.0 AND 90.0),
	longtitude float NOT NULL CHECK (longtitude BETWEEN -180.0 AND 180.0),
	readiness boolean NOT NULL,
	system_id integer NOT NULL REFERENCES system_characteristics ON DELETE RESTRICT,
	quantity integer NOT NULL CHECK (quantity > 0)
);
GRANT SELECT ON divisions TO observer;
GRANT UPDATE ON divisions TO division_commander;

CREATE TABLE orders (
	target_id integer NOT NULL UNIQUE REFERENCES targets ON DELETE RESTRICT,
	division_id integer NOT NULL REFERENCES divisions ON DELETE RESTRICT,
	dttm timestamp NOT NULL,
	PRIMARY KEY (target_id, division_id)
);
GRANT SELECT ON orders TO observer;

CREATE TABLE missile_launches (
	missile_id serial PRIMARY KEY,
	division_id integer NOT NULL REFERENCES divisions ON DELETE RESTRICT,
	dttm timestamp NOT NULL,
	target_id integer NOT NULL REFERENCES targets ON DELETE RESTRICT,
	missile_type text NOT NULL
);
GRANT SELECT ON missile_launches TO observer;
GRANT INSERT ON missile_launches TO division_commander;
GRANT USAGE ON missile_launches_missile_id_seq TO division_commander;
