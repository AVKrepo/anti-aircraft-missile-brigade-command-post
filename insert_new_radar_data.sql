WITH inserted_target_marks AS (
    INSERT INTO target_marks (dttm, latitude, longtitude, height, velocity, direction, source)
    VALUES
        -- первая отметка (самолет из Лондона), до которой дотягивается 1 зрдн
        (to_timestamp(1596466230), 54.980335, 28.138817, 11.277600000000001, 970.4480000000001, 84,'1 рлр')
    RETURNING *
)
INSERT INTO target_to_marks (target_id, target_mark_id)
    SELECT 3, target_mark_id
    FROM  inserted_target_marks;