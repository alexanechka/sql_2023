USE vk;

/* 1. Написать функцию, которая удаляет всю информацию об указанном пользователе из БД vk. Пользователь задается по id. 
Удалить нужно все сообщения, лайки, медиа записи, профиль и запись из таблицы users. Функция должна возвращать номер пользователя.*/

DROP FUNCTION IF EXISTS func_delete_user;

DELIMITER // 
CREATE FUNCTION func_delete_user(func_user_id BIGINT UNSIGNED)
RETURNS BIGINT UNSIGNED
READS SQL DATA
DETERMINISTIC
BEGIN
	-- сообщения
    DELETE FROM messages WHERE id IN (
		SELECT * FROM
			(SELECT id FROM messages 
			WHERE from_user_id = func_user_id OR to_user_id  = func_user_id
            ) AS msg
    );
    
    -- лайки
	DELETE FROM likes WHERE id IN (
		SELECT * FROM
			(SELECT id FROM likes 
			WHERE user_id = func_user_id
		) AS l
	);
   
    SET SQL_SAFE_UPDATES = 0;     -- Не смогла сделать запрос так, чтобы не ругался.
								  -- Понимаю, что не очень хорошее решение
    DELETE FROM likes WHERE id IN (
		SELECT * FROM
			(SELECT ml.id FROM likes as ml
            INNER JOIN media as mdl ON (ml.media_id = mdl.id AND mdl.user_id = func_user_id)
		) AS l_um
	);
    SET SQL_SAFE_UPDATES = 1;         
    
    -- профиль 
     DELETE FROM profiles WHERE user_id IN (
		SELECT * FROM
			(SELECT user_id FROM profiles 
			WHERE user_id = func_user_id
		) AS pf
    ); 
    
    -- медиа записи
    DELETE FROM media WHERE id IN (
		SELECT * FROM
			(SELECT id FROM media 
			WHERE user_id = func_user_id
		) AS m
    );
	
	
    -- users_communities
     DELETE FROM users_communities WHERE user_id IN (
		SELECT * FROM
			(SELECT user_id FROM users_communities 
			WHERE user_id = func_user_id
		) AS uc
    );
    
     -- friend_requests
     DELETE FROM friend_requests WHERE initiator_user_id IN (
		SELECT * FROM
			(SELECT initiator_user_id FROM friend_requests 
			WHERE initiator_user_id = func_user_id OR target_user_id = func_user_id
            ) AS fr
    );
    
     SELECT 
		id INTO @user_number 
        FROM users 
        WHERE id = func_user_id;
        
    -- запись из таблицы users    
    DELETE FROM users WHERE id IN (
		SELECT * FROM
			(SELECT id FROM users 
			WHERE id = func_user_id 
            ) AS u
    );
    
	RETURN
		CASE 
		WHEN @user_number IS NULL
			THEN 0
        ELSE 
			@user_number
		END;
  END // 
DELIMITER ;

SELECT func_delete_user(10);
            
/* 2. Предыдущую задачу решить с помощью процедуры и обернуть используемые команды в транзакцию внутри процедуры. */

DROP PROCEDURE IF EXISTS proc_delete_user;

DELIMITER // 
CREATE PROCEDURE proc_delete_user(func_user_id BIGINT UNSIGNED)
BEGIN
	START TRANSACTION;    
    -- сообщения
    DELETE FROM messages WHERE id IN (
		SELECT * FROM
			(SELECT id FROM messages 
			WHERE from_user_id = func_user_id OR to_user_id  = func_user_id
            ) AS msg
    );
    
    -- лайки
	DELETE FROM likes WHERE id IN (
		SELECT * FROM
			(SELECT id FROM likes 
			WHERE user_id = func_user_id
		) AS l
	);
    
    SET SQL_SAFE_UPDATES = 0;     -- Не смогла сделать запрос так, чтобы не ругался.
								  -- Понимаю, что не очень хорошее решение	
    
    DELETE FROM likes WHERE id IN (
		SELECT * FROM
			(SELECT ml.id FROM likes as ml
            INNER JOIN media as mdl ON (ml.media_id = mdl.id AND mdl.user_id = func_user_id)
		) AS l_um
	);
   SET SQL_SAFE_UPDATES = 1;  
   
    -- профиль 
     DELETE FROM profiles WHERE user_id IN (
		SELECT * FROM
			(SELECT user_id FROM profiles 
			WHERE user_id = func_user_id
		) AS pf
    ); 
    
    -- медиа записи
    DELETE FROM media WHERE id IN (
		SELECT * FROM
			(SELECT id FROM media 
			WHERE user_id = func_user_id
		) AS m
    );
	
	
    -- users_communities
     DELETE FROM users_communities WHERE user_id IN (
		SELECT * FROM
			(SELECT user_id FROM users_communities 
			WHERE user_id = func_user_id
		) AS uc
    );
    
     -- friend_requests
     DELETE FROM friend_requests WHERE initiator_user_id IN (
		SELECT * FROM
			(SELECT initiator_user_id FROM friend_requests 
			WHERE initiator_user_id = func_user_id OR target_user_id = func_user_id
            ) AS fr
    );
            
    -- запись из таблицы users    
    DELETE FROM users WHERE id IN (
		SELECT * FROM
			(SELECT id FROM users 
			WHERE id = func_user_id 
            ) AS u
    );
    
    COMMIT;
    
  END // 
DELIMITER ;

CALL proc_delete_user(3);

/* 3.* Написать триггер, который проверяет новое появляющееся сообщество. Длина названия сообщества (поле name) должна быть не менее 5 символов. 
Если требование не выполнено, то выбрасывать исключение с пояснением.*/
DROP TRIGGER IF EXISTS check_names;

DELIMITER //
CREATE TRIGGER check_names BEFORE INSERT ON vk.communities
FOR EACH ROW
	BEGIN
		IF NEW.name IS NULL OR length(NEW.name) < 5 THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insert Canceled. Name or Description must be more then 5 symbols!';
		END IF;
	END //

DELIMITER ;


INSERT INTO communities 
VALUES (22,'atqfdgu');
INSERT INTO communities 
VALUES (21,'atq');