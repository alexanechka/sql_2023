USE vk;
/* 1. Создайте представление с произвольным SELECT-запросом из прошлых уроков [CREATE VIEW]*/
CREATE OR REPLACE VIEW users_communities_count AS 
	SELECT
	us.lastname,
    us.firstname,
    COUNT(us_cm.community_id) AS communities
    FROM users_communities AS us_cm
	LEFT JOIN users AS us ON us_cm.user_id = us.id
    GROUP BY us.id;
    
/* 2. Выведите данные, используя написанное представление [SELECT] */
 SELECT * FROM users_communities_count;
 
/* 3. Удалите представление [DROP VIEW] */
DROP VIEW users_communities_count;

/* 4. * Сколько новостей (записей в таблице media) у каждого пользователя? 
Вывести поля: news_count (количество новостей), user_id (номер пользователя), 
user_email (email пользователя). Попробовать решить с помощью CTE или с помощью обычного JOIN. */
WITH cte AS (
	SELECT 
		count(*) AS news_count,
		user_id
	FROM media 
    GROUP BY user_id
	HAVING news_count > 1
)
SELECT 
	cte.news_count,
    cte.user_id,
    u.email AS user_email
FROM cte 
LEFT JOIN users AS u ON u.id = cte.user_id
WHERE id = 1;