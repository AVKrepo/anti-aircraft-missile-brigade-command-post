-- создание ролей
DROP ROLE IF EXISTS radar_operator;
CREATE ROLE radar_operator;

DROP ROLE IF EXISTS observer;
CREATE ROLE observer;

DROP ROLE IF EXISTS division_commander;
CREATE ROLE division_commander IN ROLE observer;


-- создание пользователей
DROP USER IF EXISTS operator_petrov;
CREATE USER operator_petrov PASSWORD 'petrov' IN ROLE radar_operator;

DROP USER IF EXISTS observer_ivanov;
CREATE USER observer_ivanov PASSWORD 'ivanov' IN ROLE observer;

DROP USER IF EXISTS colonel_sidorov;
CREATE USER colonel_sidorov PASSWORD 'sidorov' IN ROLE division_commander;