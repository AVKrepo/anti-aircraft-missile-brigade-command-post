psql -f setup/create_roles.sql
psql -f setup/create_tables.sql
psql -f setup/insert_values.sql
psql -f setup/create_functions.sql
psql -f setup/create_views.sql
psql -f setup/create_trigger.sql

# psql -f insert_new_radar_data.sql
# проверить работу тригера: должен появиться приказ в orders

# psql -f update_divisions.sql
# посмотреть на изменения в divisions; опасные цели not_fired_dangerous_targets; запущенные ЗУР missile_launches

