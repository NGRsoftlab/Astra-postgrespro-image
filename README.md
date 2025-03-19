<p><img src="https://static.tildacdn.com/tild3733-3430-4331-a637-336233396534/logo.svg" alt="NGRSOFTLAB logo" title="NGR" align="right" height="60" /></p>

# PostgreSQL Pro

![PostgreSQL Pro](https://img.shields.io/badge/postgresql-pro-blue.svg)

![Dive efficiency](https://img.shields.io/badge/dive--efficiency-95.1921%25-green.svg)

## Description

Среда для сборки контейнера с PostgresSQL Pro на базе Astra Linux. Образ соблюдает исключение ПО для проникновения в контейнер используя [divert](https://www.opennet.ru/man.shtml?topic=dpkg-divert&category=8&russian=2) для удаления большинства не нужных бинарных файлов

Сборка основана на [официальном сборщике docker-library](https://github.com/docker-library/postgres/tree/master), сопровождении [настройки PostgresPro для 1С](https://github.com/JacobBermudes/PostgresPro-1c/tree/main), сопровождении [init файла](https://git.org.ru/Djam/postgrespro-1c/src/branch/import/postgrespro.init.in) и [официальной документации PostgresPro](https://postgrespro.ru/products/download/postgrespro/15.12.1)

## Contents

- [PostgreSQL Pro](#postgresql-pro)
  - [Description](#description)
  - [Contents](#contents)
  - [What is it](#what-is-it)
  - [How to work with](#how-to-work-with)
    - [CI variables](#ci-variables)
  - [How to run this](#how-to-run-this)
    - [Initialization scripts](#initialization-scripts)
    - [Database Configuration](#database-configuration)
    - [Security configuration](#security-configuration)
  - [Environment variables](#environment-variables)
  - [Available extensions](#available-extensions)

## [What is it](#contents)

Dockerfile для сборки PostgreSQL Pro

## [How to work with](#contents)

- Собрать образ `Astra Linux based`

```shell
## Export PostgreSQL version
export POSTGRES_VERSION='15'

## PostgreSQL image: 214MB
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

## PostgreSQL image: 205MB
docker build \
    --progress=plain \
    --no-cache \
    --build-arg postgrespro_link=https://repo.postgrespro.ru/1c/1c-15/keys/pgpro-repo-add.sh \
    --build-arg postgrespro_package_suffix=1c-15 \
    --build-arg postgrespro_version=15 \
    -t postgres-pro:"${POSTGRES_VERSION}" \
    .
```

### [CI variables](#contents)

|     Имя     | Значение по умолчанию | Тип | Описание |
|     :---    |         :----:        |  :----:  |   ---:   |
| `image_registry` | '' | string | Адрес до реестра образа. Например: `--build-arg image_registry=my-container-registry:1111/` |
| `image_name` | astra | string | Имя образа. |
| `image_version` | 1.8.1 | string | Версия образа. |
| `version` | 1.0.0 | float | Версия выпуска минимального контейнера. |
| `postgrespro_link` | `https://repo.postgrespro.ru/std/std-15/keys/pgpro-repo-add.sh` | string | Ссылка до скрипта из [инструкции по установке](https://postgrespro.ru/products/download/postgrespro/15.12.1). |
| `postgrespro_package_suffix` | std-15 | string | Версия выпуска пакета postgrespro. |
| `postgrespro_version` | 15 | integer | Мажорная версия выпуска postgrespro. |

## [How to run this](#contents)

- Базовый пример запуска контейнера

```shell
## Export PostgreSQL version
export POSTGRES_VERSION='15'

## Launch single container in interactive mode
docker run --rm \
  --name postgres-pro \
  -e POSTGRES_PASSWORD=mypassword \
  -e TZ="Europe/Moscow" \
  -p 5432:5432 \
  postgres-pro:"${POSTGRES_VERSION}"

## Launch container in detach mode plus mapping volume
docker run --rm -d \
  --name postgres-pro \
  -e POSTGRES_PASSWORD=mypassword \
  -e TZ="Europe/Moscow" \
  -v /mnt/volume/for/pg_Database:/var/lib/pgpro/std-15/data \
  -p 5432:5432 \
  postgres-pro:"${POSTGRES_VERSION}"
```

- Пример запуска контейнера со сгенерированными сертификатами

```shell
## Export PostgreSQL version
export POSTGRES_VERSION='15'
export POSTGRES_HOME='/var/lib/pgpro/std-15'

## Generate certificate
if [[ ! -s certs/server-privkey.pem && ! -s certs/server.key && ! -s certs/server.req && ! -s certs/server.crt ]]; then
  mkdir -p certs
  openssl req -new -text -passout pass:abcd -subj /CN=localhost -out certs/server.req -keyout certs/server-privkey.pem
  openssl rsa -in certs/server-privkey.pem -passin pass:abcd -out certs/server.key
  openssl req -x509 -in certs/server.req -text -key certs/server.key -out certs/server.crt
  chmod 600 certs/server.key
  sudo chown 999 certs/server.key
fi

## Launch container
docker run --rm -d \
  --name postgres-pro \
  -e POSTGRES_HOST_AUTH_METHOD=trust \
  -e TZ="Europe/Moscow" \
  -v "$(pwd)/certs/server.crt:${POSTGRES_HOME}/server.crt:ro" \
  -v "$(pwd)/certs/server.key:${POSTGRES_HOME}/server.key:ro" \
  -p 5432:5432 \
  postgres-pro:"${POSTGRES_VERSION}" \
  -c ssl=on \
  -c ssl_cert_file="${POSTGRES_HOME}/server.crt" \
  -c ssl_key_file="${POSTGRES_HOME}/server.key"
```

### [Initialization scripts](#contents)

Если вы хотите выполнить дополнительную инициализацию в образе, добавьте один или несколько скриптов в директорию `/docker-entrypoint-initdb.d` в формате: `*.sql`, `*.sql.gz` `*.sh`. После того, как `docker-entrypoint.sh` вызывает создание пользователя и базы данных, следом выполнит все исполняемые `*.sh` скрипты, все `*.sql` файлы и экспортирует в качестве источника все неисполняемые `*.sh` скрипты, найденные в этом каталоге, для выполнения дальнейшей инициализации перед запуском службы.

**Предупреждение**:

- Скрипты в `/docker-entrypoint-initdb.d` запускаются только в том случае, если вы запускаете контейнер с пустым каталогом данных
- Любая существующая база данных останется нетронутой при запуске контейнера. Одна из распространенных проблем заключается в том, что если один из ваших `/docker-entrypoint-initdb.d` скриптов завершается неудачно (что приводит к завершению работы скрипта точки входа) и ваш оркестратор перезапускает контейнер с уже инициализированным каталогом данных, он не продолжит работу с вашими скриптами.

- Пример запуска контейнера со скриптами инциализации

```shell
## Export PostgreSQL version
export POSTGRES_VERSION='15'

## Launch container
docker run --rm -d \
  --name postgres-pro \
  -e DOCKER_DATABASE_USER=docker \
  -e DOCKER_DATABASE_PASSWORD=test \
  -e DOCKER_DATABASE_NAME=docker \
  -e ABUBA_DATABASE_USER=abuba \
  -e ABUBA_DATABASE_PASSWORD=haha \
  -e ABUBA_DATABASE_NAME=abuba \
  -e TZ="Europe/Moscow" \
  -v "$(pwd)/configuration/init:/docker-entrypoint-initdb.d" \
  -v "$(pwd)/configuration/sql-scripts:/sql-scripts" \
  -p 5432:5432 \
  postgres-pro:"${POSTGRES_VERSION}"

## Check scripts work
PGPASSWORD='haha' psql -U abuba -h localhost -d abuba -qAXt -c 'SELECT key FROM license;'
```

### [Database Configuration](#contents)

```shell
## Export PostgreSQL version
export POSTGRES_VERSION='15'

## Get the default config
docker run -i --rm postgres-pro:"${POSTGRES_VERSION}" cat /usr/share/postgresql/postgresql.conf.sample > my-postgres.conf

## Customize the config and run postgres with custom config
docker run --rm -d \
  --name postgres-pro \
  -v "$(pwd)/my-postgres.conf":/etc/postgresql/postgresql.conf \
  -e POSTGRES_PASSWORD=mysecretpassword \
  postgres-pro:"${POSTGRES_VERSION}" \
  -c 'config_file=/etc/postgresql/postgresql.conf'
```

### [Security configuration](#contents)

- Пример запуска наиболее безопасного образа PostgreSQL с соблюдением SecOps методологии

```shell
## Generate certificate
if [[ ! -s certs/server-privkey.pem && ! -s certs/server.key && ! -s certs/server.req && ! -s certs/server.crt ]]; then
  mkdir -p certs
  openssl req -new -text -passout pass:abcd -subj /CN=localhost -out certs/server.req -keyout certs/server-privkey.pem
  openssl rsa -in certs/server-privkey.pem -passin pass:abcd -out certs/server.key
  openssl req -x509 -in certs/server.req -text -key certs/server.key -out certs/server.crt
  chmod 600 certs/server.key
fi

## Change directory owners
sudo chown -R 2000:2000 certs

## Create data field inda host and change owner to 2000
mkdir -p test/data/psql
sudo chown 2000:2000 test/data/psql

## Launch docker-compose
docker compose up -d

## Along with the database, a service will also be launched that
## will take a backup depending on the settings in the .env file

## After test, remove direcories and turn off compose stack
docker compose down
sudo rm -rf certs
sudo rm -rf test
```

## [Environment variables](#contents)

|     Имя     | Значение по умолчанию | Тип | Описание |
|     :---    |         :----:        |  :----:  |   ---:   |
| `POSTGRES_PASSWORD` | NGRSoftlab | string | Пароль по умолчанию для доступа к базе данных, если не был установлен иной при помощи переменной. |
| `DEBUG` | '' | string | Включить режим отлибаки для входной точки. Установите переменную как `-e DEBUG=ON` чтобы включить режим отладки. |
| `POSTGRES_USER` | postgres | string | Эта необязательная переменная среды используется вместе с `POSTGRES_PASSWORD` для установки пользователя и его пароля. Эта переменная создаст указанного пользователя с полномочиями суперпользователя и базу данных с тем же именем. Если она не указана, то `postgres` будет использоваться пользователь по умолчанию. |
| `POSTGRES_DB` | postgres | string | Эта необязательная переменная среды может использоваться для определения другого имени для базы данных по умолчанию, которая создается при первом запуске образа. Если она не указана, то будет использовано `POSTGRES_USER` значение. |
| `POSTGRES_INITDB_ARGS` | '' | string | Эта необязательная переменная среды может использоваться для отправки аргументов в `postgres initdb`. Значение представляет собой строку аргументов, разделенных пробелами, как и ожидает `postgres initdb`. Это полезно для добавления функций, таких как контрольные суммы страниц данных: `-e POSTGRES_INITDB_ARGS="--data-checksums"`. |
| `POSTGRES_INITDB_WALDIR` | '' | string | Эта необязательная переменная среды может использоваться для определения другого местоположения журнала транзакций Postgres. По умолчанию журнал транзакций хранится в подкаталоге основной директории данных Postgres(`PGDATA`). Иногда может быть желательно хранить журнал транзакций в другом каталоге, который может поддерживаться хранилищем с другими характеристиками производительности или надежности. |
| `POSTGRES_HOST_AUTH_METHOD` | '' | string | Эта необязательная переменная может использоваться для управления `auth-method` соединениями `host`, `all` для баз данных, `all` для пользователей и `all` для адресов. Если не указано, то используется `scram-sha-256`аутентификация по паролю. В неинициализированной базе данных это будет заполнено pg_hba.confпримерно этой строкой: `echo "host all all all ${POSTGRES_HOST_AUTH_METHOD}" >> pg_hba.conf` [^1] [^2] [^3] |
| `PGDATA` | `/var/lib/pgpro/${postgrespro_package_suffix}/data` | stringspec | Эта необязательная переменная может использоваться для определения другого местоположения — например, подкаталога — для файлов базы данных. Значение по умолчанию — `/var/lib/pgpro/${postgrespro_package_suffix}/data`. Если используемый вами том данных — это точка монтирования файловой системы (например, постоянные диски `GCE`) или удаленная директория, которая не может быть назначена пользователю `postgres`(например, некоторые монтирования `NFS`), или содержит директории/файлы (например, `lost+found`), Postgres `initdb` требует создания подкаталога в точке монтирования для хранения данных. |

## [Available extensions](#contents)

Список расширений, доступный в PostgresPro

```sql
postgres=# SELECT * FROM pg_available_extensions;

        name        | default_version | installed_version |                                comment                                 
--------------------+-----------------+-------------------+------------------------------------------------------------------------
 intarray           | 1.5             |                   | functions, operators, and index support for 1-D arrays of integers
 cube               | 1.5             |                   | data type for multidimensional cubes
 earthdistance      | 1.1             |                   | calculate great-circle distances on the surface of the Earth
 tcn                | 1.0             |                   | Triggered change notifications
 fasttrun           | 2.0             |                   | fast transaction-unsafe truncate
 hunspell_ru_ru     | 1.0             |                   | Russian Hunspell Dictionary
 bytea_toaster      | 1.0             |                   | bytea_toaster - appendable bytea toaster
 pg_wait_sampling   | 1.1             |                   | sampling based statistics of wait events
 pg_buffercache     | 1.3             |                   | examine the shared buffer cache
 rum                | 1.3             |                   | RUM index access method
 sslinfo            | 1.2             |                   | information about SSL certificates
 moddatetime        | 1.0             |                   | functions for tracking last modification time
 dump_stat          | 1.2             |                   | move pg_statistic to new instance of PostgreSQL
 postgres_fdw       | 1.1             |                   | foreign-data wrapper for remote PostgreSQL servers
 old_snapshot       | 1.0             |                   | utilities in support of old_snapshot_threshold
 btree_gist         | 1.7             |                   | support for indexing common datatypes in GiST
 pg_variables       | 1.3             |                   | session variables with various types
 pg_query_state     | 1.1             |                   | tool for inspection query progress
 hunspell_en_us     | 1.0             |                   | en_US Hunspell Dictionary
 aqo                | 1.6             |                   | machine learning for cardinality estimation in optimizer
 pg_walinspect      | 1.0             |                   | functions to inspect contents of PostgreSQL Write-Ahead Log
 fulleq             | 2.0             |                   | exact equal operation
 pgstattuple        | 1.5             |                   | show tuple-level statistics
 fuzzystrmatch      | 1.1             |                   | determine similarities and distance between strings
 insert_username    | 1.0             |                   | functions for tracking who changed a table
 pg_proaudit        | 2.0             |                   | provides auditing functionality
 pg_trgm            | 1.6             |                   | text similarity measurement and index searching based on trigrams
 pg_tsparser        | 1.0             |                   | parser for text search
 seg                | 1.4             |                   | data type for representing line segments or floating-point intervals
 mchar              | 2.3             |                   | SQL Server text type
 dict_int           | 1.0             |                   | text search dictionary template for integers
 isn                | 1.2             |                   | data types for international product numbering standards
 pg_pathman         | 1.5             |                   | Partitioning tool for PostgreSQL
 amcheck            | 1.3             |                   | functions for verifying relation integrity
 ptrack             | 2.5             |                   | block-level incremental backup engine
 pg_stat_statements | 1.10            |                   | track planning and execution statistics of all SQL statements executed
 plpgsql            | 1.0             | 1.0               | PL/pgSQL procedural language
 pgrowlocks         | 1.2             |                   | show row-level locking information
 hunspell_nl_nl     | 1.0             |                   | Dutch Hunspell Dictionary
 citext             | 1.6             |                   | data type for case-insensitive character strings
 btree_gin          | 1.3             |                   | support for indexing common datatypes in GIN
 unaccent           | 1.1             |                   | text search dictionary that removes accents
 lo                 | 1.1             |                   | Large Object maintenance
 bloom              | 1.0             |                   | bloom access method - signature file based index
 xml2               | 1.1             |                   | XPath querying and XSLT
 tablefunc          | 1.0             |                   | functions that manipulate whole tables, including crosstab
 jsquery            | 1.1             |                   | data type for jsonb inspection
 dict_xsyn          | 1.0             |                   | text search dictionary template for extended synonym processing
 pageinspect        | 1.11            |                   | inspect the contents of database pages at a low level
 autoinc            | 1.0             |                   | functions for autoincrementing fields
 hstore             | 1.8             |                   | data type for storing sets of (key, value) pairs
 intagg             | 1.1             |                   | integer aggregator and enumerator (obsolete)
 dblink             | 1.2             |                   | connect to other PostgreSQL databases from within a database
 pg_visibility      | 1.2             |                   | examine the visibility map (VM) and page-level visibility info
 pg_freespacemap    | 1.2             |                   | examine the free space map (FSM)
 hunspell_fr        | 1.0             |                   | French Hunspell Dictionary
 toastapi           | 1.1             |                   | toastapi - Pluggable TOAST API
 file_fdw           | 1.0             |                   | foreign-data wrapper for flat file access
 adminpack          | 2.1             |                   | administrative functions for PostgreSQL
 tsm_system_rows    | 1.0             |                   | TABLESAMPLE method which accepts number of rows as a limit
 shared_ispell      | 1.1.0           |                   | Provides shared ispell dictionaries.
 ltree              | 1.2             |                   | data type for hierarchical tree-like structures
 uuid-ossp          | 1.1             |                   | generate universally unique identifiers (UUIDs)
 pg_surgery         | 1.0             |                   | extension to perform surgery on a damaged relation
 tsm_system_time    | 1.0             |                   | TABLESAMPLE method which accepts time in milliseconds as a limit
 pgcrypto           | 1.3             |                   | cryptographic functions
 refint             | 1.0             |                   | functions for implementing referential integrity (obsolete)
 pg_prewarm         | 1.2             |                   | prewarm relation data
(68 rows)
```

---

[^1]: 🛠️ Не рекомендуется использовать, `trust` так как это позволяет любому подключаться без пароля, даже если он установлен (например, через `POSTGRES_PASSWORD`). Для получения дополнительной информации см. документацию PostgreSQL по [Trust Authentication](https://www.postgresql.org/docs/14/auth-trust.html)
[^2]: 🛠️ Если установлено `POSTGRES_HOST_AUTH_METHOD` значение `trust`, то `POSTGRES_PASSWORD` не требуется
[^3]: 🛠️ Если вы установите для этого параметра альтернативное значение (например, `scram-sha-256`), вам могут потребоваться дополнительные параметры `POSTGRES_INITDB_ARGS` для правильной инициализации базы данных (например, `POSTGRES_INITDB_ARGS=--auth-host=scram-sha-256`).
