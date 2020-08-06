SELECT * FROM ready_divisions_positions;

SELECT
    target_id,
    target_description,
    is_military,
    country,
    dttm,
    latitude,
    longtitude,
    height
FROM recent_target_marks;

SELECT * FROM orders;

SELECT * FROM missile_launches;