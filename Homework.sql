-- Для решения задач используйте базу данных lesson_4.
USE lesson_4;

/* Задача 1.
Создайте таблицу users_old, аналогичную таблице users. Создайте процедуру, с помощью которой
можно переместить любого (одного) пользователя из таблицы users в таблицу users_old.
Использование транзакции с выбором commit или rollback обязательно.
*/
-- создание и редактирование таблицы
DROP TABLE IF EXISTS users_old;
CREATE TABLE users_old LIKE users;
ALTER TABLE users_old
	DROP COLUMN id,
	ADD COLUMN id BIGINT UNSIGNED NOT NULL UNIQUE FIRST
;

-- создание процедуры
DROP PROCEDURE IF EXISTS sp_move_user;
DELIMITER //
CREATE PROCEDURE sp_move_user(
	req_user_id BIGINT, OUT  tran_result varchar(100))
BEGIN

	DECLARE `_rollback` BIT DEFAULT b'0';
	DECLARE code varchar(100);
	DECLARE error_string varchar(100);
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	BEGIN
 		SET `_rollback` = b'1';
 		GET stacked DIAGNOSTICS CONDITION 1
			code = RETURNED_SQLSTATE, error_string = MESSAGE_TEXT;
	END;

	START TRANSACTION;
		SELECT id, firstname, lastname, email INTO
			@id, @firstname, @lastname, @email
		FROM users WHERE id = req_user_id;
    
    INSERT INTO users_old (id, firstname, lastname, email)
    VALUES (@id, @firstname, @lastname, @email);
    
    IF `_rollback` THEN
		SET tran_result = CONCAT('УПС. Ошибка: ', code, ' Текст ошибки: ', error_string);
		ROLLBACK;
	ELSE
		SET tran_result = 'Да, копипаста, ну и чтоже! Не сдать мне иначе ДЗ! Спасибо, Юрий!';
		COMMIT;
	END IF;
END//
DELIMITER ;

/* Задача 2.
Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего
времени суток. С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00
функция должна возвращать фразу "Добрый день", с 18:00 до 00:00 — "Добрый вечер",
с 00:00 до 6:00 — "Доброй ночи".
*/
DROP FUNCTION IF EXISTS hello;
DELIMITER $$
CREATE FUNCTION hello()
RETURNS VARCHAR(50) READS SQL DATA -- функция детермининстична (если я правильно понимаю), но это неточно, поэтому явно определим её как не вносящую изменения в данные
BEGIN
    DECLARE greeting VARCHAR(50);    
    SELECT
		CASE
			WHEN  HOUR(CURTIME()) BETWEEN 6 AND 12 THEN 'Доброе утро!'
			WHEN  HOUR(CURTIME()) BETWEEN 12 AND 18 THEN 'Добрый день!'
			WHEN  HOUR(CURTIME()) BETWEEN 18 AND 24 THEN 'Добрый вечер!'
			WHEN  HOUR(CURTIME()) BETWEEN 0 AND 6 THEN 'Доброй ночи!'
			ELSE 'Проверьте системные настройки даты и времени.'
	END INTO greeting;
	RETURN greeting;
END$$
DELIMITER ;

-- вызов функцции
SELECT hello();

/* Задача 3.
Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users,
communities и messages в таблицу logs с помощью триггера помещается время и дата создания записи, название
таблицы, идентификатор первичного ключа.
*/
DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
  time_stamp TIMESTAMP NOT NULL,
  name_table VARCHAR(20) NOT NULL,
  record_id BIGINT NOT NULL)
ENGINE = ARCHIVE;

-- триггер в users
DROP TRIGGER IF EXISTS log_new_record;
DELIMITER %%
CREATE TRIGGER log_new_record AFTER INSERT ON users
FOR EACH ROW
BEGIN
    INSERT INTO logs (time_stamp, name_table, record_id)
    VALUES (NOW(), 'users', NEW.id);
END %%
DELIMITER ;

-- триггер в communities
DROP TRIGGER IF EXISTS log_new_record;
DELIMITER %%
CREATE TRIGGER log_new_record AFTER INSERT ON communities
FOR EACH ROW
BEGIN
    INSERT INTO logs (time_stamp, name_table, record_id)
    VALUES (NOW(), 'communities', NEW.id);
END %%
DELIMITER ;

-- триггер в messages
DROP TRIGGER IF EXISTS log_new_record;
DELIMITER %%
CREATE TRIGGER log_new_record AFTER INSERT ON messages
FOR EACH ROW
BEGIN
    INSERT INTO logs (time_stamp, name_table, record_id)
    VALUES (NOW(), 'messages', NEW.id);
END %%
DELIMITER ;

-- проверено через INSERT INTO <table> (field_list) VALUES (values_list)