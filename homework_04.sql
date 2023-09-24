/*1. Подсчитать количество групп (сообществ), в которые вступил каждый пользователь.*/
SELECT
	us.lastname,
    us.firstname,
    COUNT(us_cm.community_id) AS communities
    FROM users_communities AS us_cm
	LEFT JOIN users AS us ON us_cm.user_id = us.id
    GROUP BY us.id;

/*2. Подсчитать количество пользователей в каждом сообществе.*/
SELECT
	cm.name,
    COUNT(us_cm.user_id) AS users
    FROM users_communities AS us_cm
	LEFT JOIN communities AS cm ON us_cm.community_id = cm.id
    GROUP BY cm.id;

/*3. Пусть задан некоторый пользователь. Из всех пользователей соц. сети найдите человека, который больше всех общался с выбранным пользователем (написал ему сообщений).*/
SELECT 
	us.lastname,
    us.firstname,
    COUNT(*) AS msgs
FROM messages AS msg
LEFT JOIN users AS us ON (us.id = msg.from_user_id)
WHERE msg.to_user_id = 1 -- указание пользователя
GROUP BY us.id ORDER BY msgs DESC LIMIT 1;

/*4. * Подсчитать общее количество лайков, которые получили пользователи младше 18 лет..*/
SELECT
COUNT(*)
FROM users as us
INNER JOIN likes as lk on (us.id = lk.user_id)
INNER JOIN profiles AS pf on (us.id = pf.user_id AND pf.birthday>DATE_ADD(now(), INTERVAL -18 Year));

/*5. * Определить кто больше поставил лайков (всего): мужчины или женщины.*/
SELECT
pf.gender,
COUNT(*) AS likes
FROM users as us
INNER JOIN likes as lk on (us.id = lk.user_id)
INNER JOIN profiles AS pf on (us.id = pf.user_id)
GROUP BY pf.gender ORDER BY likes DESC