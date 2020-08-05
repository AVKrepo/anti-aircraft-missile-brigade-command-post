-- актуальная (самая свежая) информация о воздушных целях
DROP VIEW IF EXISTS recent_target_marks;
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
DROP VIEW IF EXISTS ready_divisions_positions;
CREATE VIEW ready_divisions_positions AS
SELECT
    division_id,
    division_name,
    latitude,
    longtitude
FROM divisions
WHERE readiness = TRUE;


-- СВН противника (и самая свежая информация об их расположении), по которым еще не были запущены ЗУР
DROP VIEW IF EXISTS not_fired_dangerous_targets;
CREATE VIEW not_fired_dangerous_targets AS
SELECT DISTINCT ON (t1.target_id)
    t1.target_id,
    t1.target_description,
    t1.country,
    t3.latitude,
    t3.longtitude,
    t3.height
FROM
    targets t1
    INNER JOIN target_to_marks t2
        ON t1.target_id = t2.target_id
    INNER JOIN target_marks t3
        ON t2.target_mark_id = t3.target_mark_id
WHERE TRUE
    AND t1.is_military = TRUE
    AND t1.country != 'Россия'
    AND t1.target_id NOT IN (
        SELECT target_id
        FROM missile_launches
    )
ORDER BY t1.target_id, t3.dttm DESC;


-- количество ЗУР, выпущенных по целям, для каждого зрдн (контроль за оставшимся боезапасом)
DROP VIEW IF EXISTS spent_ammunition;
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
DROP VIEW IF EXISTS current_distances;
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
