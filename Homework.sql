USE lesson_4;

/* Задача 1.
Подсчитать общее количество лайков, которые получили пользователи младше 12 лет.
*/
SELECT COUNT(id) AS 'Лайков суммарно от юзеров младше 12 лет'
FROM likes l INNER JOIN profiles p ON l.user_id = p.user_id
WHERE TIMESTAMPDIFF(YEAR, p.birthday, CURDATE()) < 12
;

/* Задача 2.
Определить кто больше поставил лайков (всего): мужчины или женщины.
*/
SELECT  
	CASE gender
		WHEN 'f' THEN 'Женщины'
		ELSE 'Мужчины'
    END AS 'Лайков больше поставили'
FROM likes l INNER JOIN profiles p ON l.user_id = p.user_id
GROUP BY gender
ORDER BY COUNT(id) DESC LIMIT 1
;

/* Задача 3.
Вывести всех пользователей, которые не отправляли сообщения.
*/
SELECT id, firstname, lastname
FROM users
WHERE id NOT IN
(SELECT from_user_id
FROM messages 
GROUP BY from_user_id)
;

/* Задача 4.
(по желанию)* Пусть задан некоторый пользователь. Из всех друзей этого пользователя
найдите человека, который больше всех написал ему сообщений.
*/
SELECT CONCAT(u.id, ' ', u.firstname, ' ', u.lastname) as 'Лучший друг!'
FROM users u RIGHT JOIN
(SELECT from_user_id
FROM messages m INNER JOIN
(SELECT initiator_user_id as 'friends_ids'
FROM friend_requests frq
WHERE target_user_id = 1 AND status = 'approved' -- заменить INT на подзапрос, возвращающий users.id нужного человека
UNION
SELECT target_user_id  as 'friends_ids'
FROM friend_requests frq
WHERE initiator_user_id = 1 AND status = 'approved') -- заменить INT на подзапрос, возвращающий users.id нужного человека
AS friends_ids ON m.from_user_id = friends_ids.friends_ids
WHERE to_user_id = 1 -- заменить INT на подзапрос, возвращающий users.id нужного человека
GROUP BY from_user_id
ORDER BY COUNT(id) DESC LIMIT 1)
AS best_friend_id ON u.id = best_friend_id.from_user_id
;