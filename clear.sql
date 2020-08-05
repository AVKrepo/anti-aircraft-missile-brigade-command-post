DROP TRIGGER IF EXISTS assign_new_target_trigger CASCADE;
DROP FUNCTION IF EXISTS assign_new_target();

DROP VIEW IF EXISTS target_assignment_variants CASCADE;
DROP VIEW IF EXISTS current_distances CASCADE;
DROP VIEW IF EXISTS spent_ammunition CASCADE;
DROP VIEW IF EXISTS not_fired_dangerous_targets CASCADE;
DROP VIEW IF EXISTS ready_divisions_positions CASCADE;
DROP VIEW IF EXISTS recent_target_marks CASCADE;

DROP TABLE IF EXISTS missile_launches CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS divisions CASCADE;
DROP TABLE IF EXISTS system_characteristics CASCADE;
DROP TABLE IF EXISTS target_to_marks CASCADE;
DROP TABLE IF EXISTS targets CASCADE;
DROP TABLE IF EXISTS target_marks CASCADE;

DROP FUNCTION IF EXISTS great_circle_distance(float, float, float, float);

