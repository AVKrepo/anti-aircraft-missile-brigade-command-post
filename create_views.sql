-- актуальная (самая свежая) информация о воздушных целях
DROP VIEW IF EXISTS recent_target_marks CASCADE;
CREATE VIEW recent_target_marks AS
SELECT DISTINCT ON (t1.target_id)
    t1.*,
    t3.dttm,
    t3.latitude,
    t3.longtitude,
    t3.height,
    t3.velocity,
    t3.direction
FROM
    targets t1
    INNER JOIN target_to_marks t2
        ON t1.target_id = t2.target_id
    INNER JOIN target_marks t3
        ON t2.target_mark_id = t3.target_mark_id
ORDER BY t1.target_id, t3.dttm DESC;


-- расположение зрдн, готовых к бою
DROP VIEW IF EXISTS ready_divisions_positions CASCADE;
CREATE VIEW ready_divisions_positions AS
SELECT
    division_id,
    division_name,
    latitude,
    longtitude
FROM divisions
WHERE readiness = TRUE;


-- СВН противника (и самая свежая информация об их расположении), по которым еще не были запущены ЗУР
DROP VIEW IF EXISTS not_fired_dangerous_targets CASCADE;
CREATE VIEW not_fired_dangerous_targets AS
SELECT
    target_id,
    target_description,
    country,
    latitude,
    longtitude,
    height
FROM recent_target_marks t1
WHERE TRUE
    AND is_military = TRUE
    AND country != 'Россия'
    AND target_id NOT IN (
        SELECT target_id
        FROM missile_launches
    );


-- количество ЗУР, выпущенных по целям, для каждого зрдн (контроль за оставшимся боезапасом)
DROP VIEW IF EXISTS spent_ammunition CASCADE;
CREATE VIEW spent_ammunition AS
SELECT
    t1.division_id,
    t1.division_name,
    COUNT(t2.missile_id) as n_launches
FROM
    divisions t1
    LEFT JOIN missile_launches t2
        ON t1.division_id = t2.division_id
GROUP BY t1.division_id, t1.division_name
ORDER BY t1.division_id;


-- расстояния от текущего расположения еще не обстрелянного СВН противника до каждого из зрдн, готовых к бою
DROP VIEW IF EXISTS current_distances CASCADE;
CREATE VIEW current_distances AS
SELECT
    t1.target_id,
    t1.target_description,
    t2.division_id,
    t2.division_name,
    great_circle_distance(t1.latitude, t1.longtitude, t2.latitude, t2.longtitude) as distance
FROM
    not_fired_dangerous_targets t1, ready_divisions_positions t2
ORDER BY t1.target_id, t2.division_id;


-- варианты выбора зрдн для тех СВН противника, для которых еще не было приказа (в порядке дальности)
DROP VIEW IF EXISTS target_assignment_variants CASCADE;
CREATE VIEW target_assignment_variants AS
SELECT
    t1.target_id,
    t1.target_description,
    t1.country,
    t1.latitude,
    t1.longtitude,
    t1.height,
    t2.division_id,
    t2.division_name,
    t2.distance
FROM 
    recent_target_marks t1
    INNER JOIN current_distances t2
        ON t1.target_id = t2.target_id
    INNER JOIN divisions t3
        ON t2.division_id = t3.division_id
    INNER JOIN system_characteristics t4
        ON t3.system_id = t4.system_id
        AND t1.height BETWEEN t4.min_height and t4.max_height
        AND t1.velocity <= t4.max_velocity
        AND t2.distance BETWEEN t4.min_range and t4.max_range
WHERE TRUE
    AND t1.is_military = TRUE
    AND t1.country != 'Россия'
    AND t1.target_id NOT IN (
        SELECT target_id
        FROM orders
    )
ORDER BY t1.target_id, t2.distance;
