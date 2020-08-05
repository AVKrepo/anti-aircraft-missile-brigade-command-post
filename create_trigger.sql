CREATE OR REPLACE FUNCTION assign_new_target() RETURNS TRIGGER AS $$
    BEGIN
        IF (NEW.target_id IN (SELECT DISTINCT target_id FROM target_assignment_variants)) THEN
            -- если новая цель = СВН противника и еще не было приказа на поражение, а возможность есть
            INSERT INTO orders (target_id, division_id, dttm)
                SELECT target_id, division_id, now()
                FROM target_assignment_variants
                WHERE target_id = NEW.target_id
                ORDER BY distance
                LIMIT 1; -- отдать приказ ровно одному зрдн
        END IF;
        RETURN NULL; -- возвращаемое значение для триггера AFTER игнорируется
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER assign_new_target_trigger
AFTER INSERT ON target_to_marks
    FOR EACH ROW EXECUTE PROCEDURE assign_new_target();