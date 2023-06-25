/* Задача 1.
Используя операторы языка SQL, создайте табличку “sales”. Заполните ее данными.
*/

-- создаем и заполняем таблицу
DROP DATABASE IF EXISTS homework2;
CREATE DATABASE homework2;
USE homework2;

DROP TABLE IF EXISTS sales;
CREATE TABLE sales (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
    order_date DATE NOT NULL,
    count_product INT NOT NULL,
    PRIMARY KEY (id),
    UNIQUE INDEX id_UNIQUE (id ASC) VISIBLE);

INSERT INTO sales (order_date, count_product) VALUES ('2022-01-01', '156');
INSERT INTO sales (order_date, count_product) VALUES ('2022-01-02', '180');
INSERT INTO sales (order_date, count_product) VALUES ('2022-01-03', '21');
INSERT INTO sales (order_date, count_product) VALUES ('2022-01-04', '124');
INSERT INTO sales (order_date, count_product) VALUES ('2022-01-05', '341');

/* Задача 2.
Для данных таблицы “sales” укажите тип заказа в зависимости от кол-ва:
меньше 100 - Маленький заказ;
от 100 до 300 - Средний заказ;
больше 300 - Большой заказ.
*/

-- Запрос:
USE homework2;

SELECT
    id as 'ID заказа',
    CASE
        WHEN count_product < 100 THEN 'Маленький заказ'
        WHEN count_product BETWEEN 100 AND 300 THEN 'Средний заказ'
        WHEN count_product > 300 THEN 'Большой заказ'
    END AS 'Тип заказа'
FROM sales;

/* Задача 3.
Создайте таблицу “orders”, заполните ее значениями. Выберите все заказы.
В зависимости от поля order_status выведите столбец full_order_status:
OPEN – «Order is in open state»;
CLOSED - «Order is closed»;
CANCELLED - «Order is cancelled».
*/

-- создаем и заполняем таблицу
USE homework2;

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
    employee_id VARCHAR(40) NOT NULL,
    amount DECIMAL(6,2) NOT NULL,
    order_status TINYINT UNSIGNED NOT NULL,
    PRIMARY KEY (id),
    UNIQUE INDEX id_UNIQUE (id ASC) VISIBLE);

INSERT INTO orders (employee_id, amount, order_status) VALUES ('e03', '15', '1');
INSERT INTO orders (employee_id, amount, order_status) VALUES ('e01', '25.5', '1');
INSERT INTO orders (employee_id, amount, order_status) VALUES ('e05', '100.7', '2');
INSERT INTO orders (employee_id, amount, order_status) VALUES ('e02', '22.18', '1');
INSERT INTO orders (employee_id, amount, order_status) VALUES ('e04', '9.5', '3');

-- Запрос:
USE homework2;

SELECT
    id, employee_id, amount,
    CASE order_status
        WHEN 1 THEN 'OPEN'
        WHEN 2 THEN 'CLOSED'
        WHEN 3 THEN 'CANCELLED'
    END AS 'order_status'
FROM orders;

/* Задача 4.
Чем NULL отличается от 0?
*/

-- 0 это целочисленное значение значение, хранящее в ячейке с типом INT, BIGINT и иже с ними.
-- NULL же это отсутствие значения в ячейке, т.е. либо оно не было присвоено, либо оно было сброшено.
-- Интересно было бы узнать ваше мнение по поводу того, что среди гуру СУБД бытует мнение,
-- будто бы ячейки с NULL это признак дурного дизайна модели.
-- Есть ли ситуации, когда от NULL невозможно избавиться полностью?