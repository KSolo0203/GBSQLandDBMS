/* Задача 1.
Создайте таблицу с мобильными телефонами (mobile_phones),
используя графический интерфейс. Заполните БД данными.
*/

-- создаем таблицу
CREATE TABLE 'goods_schema'.'mobile_phones' (
    'id' INT NOT NULL AUTO_INCREMENT,
    'testcol' VARCHAR(255) NOT NULL,
    PRIMARY KEY ('id'),
    UNIQUE INDEX 'id_UNIQUE' ('id' ASC) VISIBLE);

-- меняем таблицу
ALTER TABLE 'goods_schema'.'mobile_phones' (
    DROP COLUMN 'testcol',
    ADD COLUMN 'product_name' VARCHAR(255) NOT NULL AFTER 'id',
    ADD COLUMN 'manufacturer' VARCHAR(255) NOT NULL AFTER 'product_name',
    ADD COLUMN 'product_count' INT NOT NULL AFTER 'manufacturer',
    ADD COLUMN 'price' INT NOT NULL AFTER 'product_count');

-- заполняем таблицу
INSERT INTO 'goods_schema'.'mobile_phones' ('product_name', 'manufacturer', 'product_count', 'price') VALUES ('iPhone X', 'Apple', '3', '76000')
INSERT INTO 'goods_schema'.'mobile_phones' ('product_name', 'manufacturer', 'product_count', 'price') VALUES ('iPhone', '8', 'Apple', '2', '51000')
INSERT INTO 'goods_schema'.'mobile_phones' ('product_name', 'manufacturer', 'product_count', 'price') VALUES ('Galaxy', 'S9', 'Samsung', '2', '56000')
INSERT INTO 'goods_schema'.'mobile_phones' ('product_name', 'manufacturer', 'product_count', 'price') VALUES ('Galaxy', 'S8', 'Samsung', '1', '41000')
INSERT INTO 'goods_schema'.'mobile_phones' ('product_name', 'manufacturer', 'product_count', 'price') VALUES ('P20 Pro', 'Huawei', '5', '36000');

/* Задача 2.
Выведите название, производителя и цену для товаров, количество которых превышает 2.
*/

-- Запрос:
SELECT product_name, manufacturer, price
FROM goods_schema.mobile_phones
WHERE product_count > 2

/* Задача 3.
Выведите весь ассортимент товаров марки “Samsung”.
*/

-- Запрос:
SELECT *
FROM goods_schema.mobile_phones
WHERE manufacturer = 'Samsung'

/* Задача 4.
С помощью регулярных выражений найти:
	4.1. Товары, в которых есть упоминание "Iphone".
	4.2. Товары, в которых есть упоминание "Samsung".
	4.3.  Товары, в которых есть ЦИФРЫ.
	4.4.  Товары, в которых есть ЦИФРА "8".
*/

-- Запросы:
SELECT *
FROM goods_schema.mobile_phones
WHERE UPPER(product_name) LIKE UPPER('%iphone%')

SELECT *
FROM goods_schema.mobile_phones
WHERE LOWER(manufacturer) LIKE LOWER('%samsung%')

SELECT *
FROM goods_schema.mobile_phones
WHERE product_name NOT LIKE '%[^0-9]%'

SELECT *
FROM goods_schema.mobile_phones
WHERE product_name LIKE '%8%'

