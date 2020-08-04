DROP TABLE IF EXISTS coordinates CASCADE;
CREATE TABLE "coordinates" (
	"target_mark_id" serial PRIMARY KEY,
	"latitude" float NOT NULL CHECK (latitude BETWEEN -90.0 AND 90.0),
	"longtitude" float NOT NULL CHECK (longtitude BETWEEN -180.0 AND 180.0),
	"height" float NOT NULL CHECK (height > 0.0)
);


DROP TABLE IF EXISTS target_marks CASCADE;
CREATE TABLE "target_marks" (
	"target_mark_id" serial PRIMARY KEY REFERENCES coordinates, -- TODO nested inserts
	"dttm" timestamp NOT NULL,
	"velocity" float NOT NULL CHECK (velocity >= 0.0),
	"direction" float NOT NULL CHECK (direction BETWEEN 0.0 AND 360.0),
	"target_type" text,
	"is_military" boolean,
	"country" text,
	"source" text NOT NULL
);


DROP TABLE IF EXISTS targets CASCADE;
CREATE TABLE "targets" (
	"target_id" serial PRIMARY KEY,
	"target_mark_id" serial NOT NULL REFERENCES target_marks
);


DROP TABLE IF EXISTS system_characteristics CASCADE;
CREATE TABLE "system_characteristics" (
	"system_id" serial PRIMARY KEY,
	"system_type" text NOT NULL,
	"max_range" float NOT NULL CHECK (max_range > 0.0),
	"min_range" float NOT NULL CHECK (min_range >= 0.0),
	"max_height" float NOT NULL CHECK (max_height > 0.0),
	"min_height" float NOT NULL CHECK (min_height >= 0.0),
	"max_velocity" float NOT NULL CHECK (max_velocity >= 0.0),
	CHECK (max_range > min_range),
	CHECK (max_height > min_height)
);


DROP TABLE IF EXISTS divisions CASCADE;
CREATE TABLE "divisions" (
	"division_id" serial PRIMARY KEY,
	"name" text NOT NULL,
	"latitude" float NOT NULL CHECK (latitude BETWEEN -90.0 AND 90.0),
	"longtitude" float NOT NULL CHECK (longtitude BETWEEN -180.0 AND 180.0),
	"readiness" boolean NOT NULL,
	"system_id" integer NOT NULL REFERENCES system_characteristics,
	"quantity" integer NOT NULL CHECK (quantity > 0)
);


DROP TABLE IF EXISTS orders CASCADE;
CREATE TABLE "orders" (
	"target_id" serial NOT NULL REFERENCES targets,
	"division_id" serial NOT NULL REFERENCES divisions,
	"dttm" timestamp NOT NULL,
	PRIMARY KEY ("target_id", "division_id")
);


CREATE TABLE "missile_launches" (
	"missile_id" serial PRIMARY KEY,
	"division_id" serial NOT NULL REFERENCES divisions,
	"dttm" timestamp NOT NULL,
	"target_id" integer NOT NULL REFERENCES targets,
	"missile_type" text NOT NULL
);
