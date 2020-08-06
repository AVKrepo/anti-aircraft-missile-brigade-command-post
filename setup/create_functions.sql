DROP FUNCTION IF EXISTS great_circle_distance(float, float, float, float);
CREATE FUNCTION great_circle_distance(latitude1 float, longtitude1 float, latitude2 float, longtitude2 float)
RETURNS float AS '
    DECLARE
        dist float = 0;
        radlatitude1 float;
        radlatitude2 float;
        theta float;
        radtheta float;
    BEGIN
        IF latitude1 = latitude2 AND longtitude1 = longtitude2
            THEN RETURN dist;
        ELSE
            radlatitude1 = pi() * latitude1 / 180;
            radlatitude2 = pi() * latitude2 / 180;
            theta = longtitude1 - longtitude2;
            radtheta = pi() * theta / 180;
            dist = sin(radlatitude1) * sin(radlatitude2) + cos(radlatitude1) * cos(radlatitude2) * cos(radtheta);

            IF dist > 1 THEN dist = 1; END IF;

            dist = acos(dist);
            dist = dist * 6371;
            
			RETURN dist;
        END IF;
    END;
'
LANGUAGE plpgsql;