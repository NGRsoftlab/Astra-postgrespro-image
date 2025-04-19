CREATE TABLE public.license (
    id SERIAL PRIMARY KEY,
    key TEXT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Выдача прав владельцу 'abuba'
ALTER TABLE public.license OWNER TO abuba;

-- Вставка текста в key
INSERT INTO license (key) VALUES ('License by NGRSoftlab with love');
