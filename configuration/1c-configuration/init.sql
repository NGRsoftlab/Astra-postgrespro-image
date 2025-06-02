-- Реализовать традиционную схему управления правами доступа в связке 1С
-- СУБД в которой каждая база данных принадлежит строго определённому пользователю, не имеющему доступа к другим БД
-- Разрешаем подключение к базе template0 для её модификации
UPDATE pg_database
SET datallowconn = true
WHERE datname = 'template0';

-- Переключаемся на базу template0 (это psql-команда, работает только в psql)
-- \c template0

-- Включаем доверие к языку 'c' (если он существует)
UPDATE pg_language
SET lanpltrusted = true
WHERE lanname = 'c';

-- Возвращаемся к базе postgres (psql-команда)
-- \c postgres

-- Запрещаем подключение к template0
UPDATE pg_database
SET datallowconn = false
WHERE datname = 'template0';

-- Создаём роль для 1С
CREATE ROLE ngr1c WITH LOGIN PASSWORD 'lovengrsoftlab'; -- pragma: allowlist-secret

-- Даём право на изменение параметра lc_messages
GRANT SET ON PARAMETER lc_messages TO ngr1c;

-- Даём право на выполнение серверных программ (для C-функций и пр.)
GRANT pg_execute_server_program TO ngr1c;

-- Временно даём право создавать базы данных
ALTER ROLE ngr1c CREATEDB;

-- === ВАЖНО: Создайте базу данных для 1С здесь, например:
-- CREATE DATABASE "имя_базы_1с" OWNER ngr1c ENCODING 'UTF8' TEMPLATE template0;

-- После создания базы убираем право на создание баз
ALTER ROLE ngr1c NOCREATEDB;

-- Рекомендуется также установить ограничения по подключениям и прочее при необходимости
-- Например:
-- ALTER ROLE ngr1c CONNECTION LIMIT 10;
