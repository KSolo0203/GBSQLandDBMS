-- Для решения задач используйте базу данных lesson_4.
USE lesson_4;

/* Задача 1.
Создайте представление, в которое попадет информация о пользователях (имя, фамилия, город и пол),
которые не старше 20 лет.
*/
CREATE or REPLACE VIEW users_younger as
SELECT
	u.firstname,
	u.lastname,
    p.hometown,
    p.gender
from users u inner join profiles p on u.id = p.user_id
WHERE TIMESTAMPDIFF(YEAR, p.birthday, CURDATE()) < 20
;

/* Задача 2.
Найдите кол-во отправленных каждым пользователем сообщений и выведите ранжированный список пользователей,
указав имя и фамилию пользователя, количество отправленных сообщений и место в рейтинге
(первое место у пользователя с максимальным количеством сообщений). Используйте DENSE_RANK.
*/
WITH cte AS (SELECT
	u.id,
    u.firstname,
    u.lastname,
    count(m.id) AS count_m
FROM users u INNER JOIN messages m ON u.id = m.from_user_id
GROUP BY u.id)
SELECT
	id,
    CONCAT(firstname, ' ' , lastname) as 'User name',
    count_m,
    DENSE_RANK() OVER (ORDER BY count_m DESC) AS 'rank'
FROM cte
;

/* Задача 3.
Выберите все сообщения, отсортируйте сообщения в хронологическом порядке
и найдите разницу дат отправления между соседними сообщениями, получившегося списка.
Используйте LEAD или LAG.
*/
SELECT
	id,
    from_user_id,
    to_user_id,
    created_at,
    -- body,
    TIMESTAMPDIFF(MINUTE, lag(created_at) over (ORDER BY created_at), created_at) AS 'Time after last message',
    TIMESTAMPDIFF(MINUTE, created_at, lead(created_at) over (ORDER BY created_at)) AS 'Time before next message'
FROM messages
;