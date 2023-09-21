use vk;

/* 1. Написать скрипт, возвращающий список имен (только firstname) пользователей без повторений в алфавитном порядке. [ORDER BY] */
SELECT firstname 
FROM users 
ORDER BY firstname;

/* 2. Выведите количество мужчин старше 35 лет [COUNT].*/
SELECT COUNT(user_id) 
FROM profiles
WHERE gender='m'
AND birthday < DATE_ADD(now(), INTERVAL -35 Year);

/* 3. Сколько заявок в друзья в каждом статусе? (таблица friend_requests) [GROUP BY]*/ 
SELECT status,
count(*) AS amount
FROM friend_requests
GROUP BY status;

/* 4.* Выведите номер пользователя, который отправил больше всех заявок в друзья (таблица friend_requests) [LIMIT].*/
SELECT initiator_user_id,
count(*) AS amount
FROM friend_requests
GROUP BY initiator_user_id
ORDER BY amount DESC
LIMIT 1;

/* 5.* Выведите названия и номера групп, имена которых состоят из 5 символов [LIKE]. */
SELECT * 
FROM communities
WHERE name LIKE '_____';