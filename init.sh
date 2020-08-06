createdb command_post
psql -d command_post -f setup/create_roles.sql
psql -d command_post -f setup/create_tables.sql
psql -d command_post -f setup/insert_values.sql
psql -d command_post -f setup/create_functions.sql
psql -d command_post -f setup/create_views.sql
psql -d command_post -f setup/create_trigger.sql
