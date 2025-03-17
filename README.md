<p><img src="https://static.tildacdn.com/tild3733-3430-4331-a637-336233396534/logo.svg" alt="NGRSOFTLAB logo" title="NGR" align="right" height="60" /></p>

# PostgreSQL Pro

[![PostgreSQL Pro](https://img.shields.io/badge/postgresql-pro-blue.svg)]***REMOVED***

## Description

Среда для сборки контейнера с PostgresSQL Pro на базе Astra Linux. Образ соблюдает исключение ПО для проникновения в контейнер используя [divert](https://www.opennet.ru/man.shtml?topic=dpkg-divert&category=8&russian=2) для удаления большинства не нужных бинарных файлов

## Contents

- [PostgreSQL Pro](#postgresql-pro)
  - [Description](#description)
  - [Contents](#contents)
  - [What is it](#what-is-it)
  - [How to work with](#how-to-work-with)
  - [CI variables](#ci-variables)
  - [Environment variables](#environment-variables)

## [What is it](#contents)

Dockerfile для сборки PostgreSQL Pro

## [How to work with](#contents)

- Собрать образ `Astra Linux based`

```shell
## Export PostgreSQL version
export POSTGRES_VERSION='15'

## PostgreSQL image: 220MB
docker build \
    --progress=plain \
    --no-cache \
    -t postgres-pro:"${POSTGRES_VERSION}" \
    .
```

- Собрать `Astra Linux based` образ, на другой платформе, например для 1С

```shell
## Export PostgreSQL version
export POSTGRES_VERSION='15-1c'

## PostgreSQL image: 211MB
docker build \
    --progress=plain \
    --no-cache \
    --build-arg postgrespro_link=https://repo.postgrespro.ru/1c/1c-15/keys/pgpro-repo-add.sh \
    --build-arg postgrespro_package_suffix=1c-15 \
    -t postgres-pro:"${POSTGRES_VERSION}" \
    .
```

- Пример запуска контейнера

```shell
## Export PostgreSQL version
export POSTGRES_VERSION='15'

## Launch container
docker run -d \
  -e PG_PASSWORD=mypassword \
  -v /mnt/volume/for/pg_Database:/var/lib/postgresql/data \
  -p 5432:5432 \
  postgres-pro:"${POSTGRES_VERSION}"
```

## [CI variables](#contents)

|     Имя     | Значение по умолчанию | Тип | Описание |
|     :---    |         :----:        |  :----:  |   ---:   |
| `image_registry` | ***REMOVED*** | string | Адрес до реестра образа. |
| `image_name` | astra | string | Имя образа. |
| `image_version` | 1.8.1 | string | Версия образа. |
| `version` | 1.0.0 | float | Версия выпуска минимального контейнера. |
| `postgrespro_link` | `https://repo.postgrespro.ru/std/std-15/keys/pgpro-repo-add.sh` | string | Ссылка до скрипта из [инструкции по установке](https://postgrespro.ru/products/download/postgrespro/15.12.1). |
| `postgrespro_package_suffix` | std-15 | string | Версия выпуска пакета postgrespro. |

## [Environment variables](#contents)

|     Имя     | Значение по умолчанию | Тип | Описание |
|     :---    |         :----:        |  :----:  |   ---:   |
| `PG_PASSWORD` | NGRSoftlab | string | Пароль по умолчанию для доступа к базе данных, если не был установлен иной при помощи переменной. |
| `DEBUG` | '' | string | Включить режим отлибаки для входной точки. Установите переменную как `-e DEBUG=ON` чтобы включить режим отладки. |
