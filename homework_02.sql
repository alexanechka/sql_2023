USE vk;

/*1.	Написать скрипт, добавляющий в созданную БД vk 2-3 новые таблицы 
(с перечнем полей, указанием индексов и внешних ключей) (CREATE TABLE)
*/ 

-- таблицы посты и комментарии к постам
DROP TABLE IF EXISTS `post_comments`;
DROP TABLE IF EXISTS `posts`;
CREATE TABLE `posts` (
  `id` BIGINT unsigned NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT unsigned NOT NULL,
  `txt` text NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ;

CREATE TABLE `post_comments` (
  `id` BIGINT unsigned NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT unsigned NOT NULL,
  `post_id` BIGINT unsigned NOT NULL,
  `txt` text NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`)
) ;

-- фотографии пользователей
DROP TABLE IF EXISTS `user_photos`;
CREATE TABLE `user_photos` (
  `id` BIGINT unsigned NOT NULL AUTO_INCREMENT,
  `photo` BLOB,
  PRIMARY KEY (`id`)
  );
  
-- добавление поля-ссылки на пользователя, загрузившего фото
ALTER TABLE user_photos ADD COLUMN `user_id` BIGINT unsigned NOT NULL;

ALTER TABLE `user_photos` ADD CONSTRAINT user_photos_id
    FOREIGN KEY (user_id) REFERENCES users(id);

/* 2. Заполнить 2 таблицы БД vk данными (по 10 записей в каждой таблице) (INSERT)*/

INSERT INTO `users` (`firstname`, `lastname`, `email`, `phone`) VALUES ('Иван', 'Иванов', 'ivanov@gmail.com', '456489');
INSERT INTO `users` (`firstname`, `lastname`, `email`, `phone`) VALUES ('Петр', 'Петров', 'petrov.12345@mail.ru', '4597851566');
INSERT INTO `users` (`firstname`, `lastname`, `email`, `phone`) VALUES ('Алексей', 'Сидоров', 'triotutoyu@ya.ru', '54648768');
INSERT INTO `users` (`firstname`, `lastname`, `email`, `phone`) VALUES ('Олег', 'Александров', 'treity@ya.ru', '123243545');
INSERT INTO `users` (`firstname`, `lastname`, `email`, `phone`) VALUES ('Ольга', 'Анциферова', 'v4367856485@ya.ru', '2343435');
INSERT INTO `users` (`firstname`, `lastname`, `email`, `phone`) VALUES ('Виктория', 'Кузнецова', 'yuoyrio@ya.ru', '76545343453');
INSERT INTO `users` (`firstname`, `lastname`, `email`, `phone`) VALUES ('Андрей', 'Суздальцев', 'ioi@ya.ru', '54644543768');
INSERT INTO `users` (`firstname`, `lastname`, `email`, `phone`) VALUES ('Никита', 'Александров', 'qwrqye@ya.ru', '12312243545');
INSERT INTO `users` (`firstname`, `lastname`, `email`, `phone`) VALUES ('Ирина', 'Викторова', 'reyuierghtur@ya.ru', '2334435');
INSERT INTO `users` (`firstname`, `lastname`, `email`, `phone`) VALUES ('Наталья', 'Лыско', 'yuroyrio@ya.ru', '76545312453');


