/* Задачи 1-6.
1. Отсортируйте данные по полю заработная плата (salary) в порядке: убывания; возрастания
2. Выведите 5 максимальных заработных плат (salary)
3. Посчитайте суммарную зарплату (salary) по каждой специальности (роst)
4. Найдите кол-во сотрудников с специальностью (post) «Рабочий» в возрасте от 24 до 49 лет включительно.
5. Найдите количество специальностей
6. Выведите специальности, у которых средний возраст сотрудников меньше 30 лет
*/
USE lesson_3;

-- Пункт 1.
SELECT firstname, lastname, age, post, salary, seniority
FROM staff
ORDER BY salary DESC
;

SELECT firstname, lastname, age, post, salary, seniority
FROM staff
ORDER BY salary --ASC by default
;

-- Пункт 2.
SELECT firstname, lastname, post, salary
FROM staff
ORDER BY salary DESC
LIMIT 5
;

-- Пункт 3.
SELECT post, SUM(salary)
FROM staff
GROUP BY post
;

-- Пункт 4.
SELECT COUNT(id) as 'Количество рабочих от 24 до 49 лет'
FROM staff
WHERE post = 'Рабочий' AND age BETWEEN 24 AND 49
;

-- Пункт 5.
SELECT COUNT(*) as 'Количество специальностей'
FROM
(SELECT post
FROM staff
GROUP BY post) as list
;

-- Пункт 6.
SELECT post--, AVG(age)
FROM staff
GROUP BY post
HAVING AVG(age) < 30 -- удалить эту строку и раскоментить, чтобы убедиться воочию
;