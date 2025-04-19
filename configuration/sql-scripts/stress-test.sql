-- Создание таблицы
CREATE TABLE public.test_data (
    id SERIAL PRIMARY KEY,
    random_number INT,
    random_string TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Выдача прав владельцу 'abuba'
ALTER TABLE public.test_data OWNER TO abuba;

-- Функция для генерации случайных строк
CREATE OR REPLACE FUNCTION RANDOM_STRING(length INTEGER) RETURNS TEXT AS
$$
DECLARE
    chars   TEXT := 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    result  TEXT := '';
    i       INTEGER := 0;
BEGIN
    FOR i IN 1..length LOOP
        result := result || substr(chars, floor(random() * length(chars) + 1)::INTEGER, 1);
    END LOOP;
    RETURN result;
END;
$$ LANGUAGE plpgsql;

-- Вставка 1'000'000 записей
INSERT INTO public.test_data (random_number, random_string)
SELECT
    FLOOR(RANDOM() * 1000000)::INTEGER AS random_number,
    RANDOM_STRING(20) AS random_string
FROM GENERATE_SERIES(1, 1000000);
