-- передислоцировать 2 зрдн в Клушино
UPDATE divisions SET (latitude, longtitude, division_name) = (55.668728, 35.048431, '2 зрдн Клушино')
    WHERE division_name = '2 зрдн Гагарин';

-- изменить готовность 3 зрдн
UPDATE divisions SET readiness = TRUE
    WHERE division_name = '3 зрдн Тёмкино';

-- запустить ракету по приказу
INSERT INTO missile_launches (division_id, dttm, target_id, missile_type)
    SELECT
        division_id,
        now(),
        target_id,
        '48Н6E2'
    FROM orders
    WHERE (division_id, target_id) NOT IN (
        SELECT division_id, target_id
        FROM missile_launches
    );