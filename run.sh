echo
echo '    Смотрим на начальные положения зрдн (готорых к бою), актуальные данные'
echo '     по воздушным объектам, отданные приказы, запущенные ракеты'
echo
psql -U observer_ivanov -d command_post -f actions/observe.sql

echo
echo '    Добавляем новую отметку цели. Она оказывается достаточно близко к одному из зрдн.'
echo '    Смотрим, что обновилась актуальная информация об одной из целей.'
echo '    Убеждаемся, что сработал триггер и был сформирован приказ.'
echo
psql -U operator_petrov -d command_post -f actions/insert_new_radar_data.sql
echo
psql -U observer_ivanov -d command_post -f actions/observe.sql

echo
echo '    Изменение состояния зрдн, пуск ракеты (под руководством командира зрдн).'
echo
psql -U colonel_sidorov -d command_post -f actions/update_divisions.sql
echo
psql -U colonel_sidorov -d command_post -f actions/observe.sql
