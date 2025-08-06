<!-- markdownlint-disable MD033 MD041 -->
<p><img src="https://static.tildacdn.com/tild3733-3430-4331-a637-336233396534/logo.svg" alt="NGRSOFTLAB logo" title="NGR" align="right" height="60" /></p>
<!-- markdownlint-enable MD033 MD041 -->

# PostgreSQL Pro

<!-- markdownlint-disable MD033 MD041 MD051 -->
<div>
  <h4 align="center">
    <img src="https://img.shields.io/badge/Dive%20efficiency-99%25-brightgreen.svg?logo=Docker&style=plastic" alt="Dive efficiency"/>
    <img src="https://img.shields.io/badge/Made%20with-%E2%9D%A4%EF%B8%8F-9cf?style=plastic" alt="Made with love"/>
    <img src="https://img.shields.io/badge/Powered%20by-Docker-blue?logo=Docker&style=plastic" alt="Powered by Docker"/>
    <img src="https://shields.io/badge/NGR -Team-yellow?style=plastic&logo=data:image/svg%2bxml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIGZpbGw9Im5vbmUiIHZpZXdCb3g9IjIyLjcgMCA1MS45IDUxLjciPjxwYXRoIGZpbGwtcnVsZT0iZXZlbm9kZCIgY2xpcC1ydWxlPSJldmVub2RkIiBkPSJNNzQuNSAwSDYzLjhsMy42IDMuNWMuNy43LjcgMS45IDAgMi43LS43LjctMS45LjctMi42IDBMNTguOSAwSDUzbDE0LjUgMTMuOWMuNy43LjcgMS45IDAgMi43LS43LjctMS45LjctMi42IDBMNDkgMGgtNi44bDI1LjMgMjQuM2MuNy43LjcgMS45IDAgMi43LS43LjctMS45LjctMi42IDBMMzkgMGgtNy43bDM2LjEgMzQuN2MuNy43LjcgMS45IDAgMi42cy0xLjkuNy0yLjYgMEwyOSAwYy0zLjUuNC02LjMgMy40LTYuMyA3djQ0LjdoMTAuNmwtMy42LTMuNGMtLjctLjctLjctMS45IDAtMi42czEuOS0uNyAyLjcgMGw1LjggNmg1LjlMMjkuNyAzNy45Yy0uNy0uNy0uNy0xLjkgMC0yLjcuNy0uNyAxLjktLjcgMi43IDBsMTUuOCAxNi40SDU1TDI5LjggMjcuNGMtLjctLjctLjctMS45IDAtMi43LjctLjcgMS45LS43IDIuNyAwbDI1LjggMjYuOEg2NkwyOS45IDE2LjljLS43LS43LS43LTEuOSAwLTIuNnMxLjktLjcgMi43IDBsMzUuNyAzNy4yYzMuNS0uMyA2LjMtMy4zIDYuMy03VjB6IiBmaWxsPSIjRjhBRDAwIi8+PC9zdmc+" alt="NGR Team" />
  </h4>
</div>

<div align="center">

![PostgreSQL Pro](docs/images/logo.svg)
</div>

<div align="center"> <sub> Ascii svg art by <a href="https://GitHub.com/martinthomson/aasvg">aasvg</a>. </sub> </div>
<!-- markdownlint-enable MD033 MD041 MD051 -->

## Description

Среда для сборки контейнера с PostgreSQL Pro на базе Astra Linux. Образ соблюдает исключение ПО для проникновения в контейнер используя [divert](https://www.opennet.ru/man.shtml?topic=dpkg-divert&category=8&russian=2) для удаления большинства не нужных бинарных файлов

Сборка основана на [официальном сборщике Docker-library](https://github.com/docker-library/postgres/tree/master), сопровождении [настройки PostgreSQL Pro для 1С](https://github.com/JacobBermudes/PostgresPro-1c/tree/main), сопровождении [init файла](https://git.org.ru/Djam/postgrespro-1c/src/branch/import/postgrespro.init.in) и [официальной документации PostgreSQL Pro](https://postgrespro.ru/products/download/postgrespro/15.12.1)

Присоединяйтесь к нашим социальным сетям:

<!-- markdownlint-disable MD033 -->

<div class="badges-row-public">
  <h4 align="center">
    <a href="https://t.me/NGR_Softlab">
      <img src="https://shields.io/badge/ngr-telegram-blue?logo=telegram&style=for-the-badge" alt="NGR Social Telegram" height="40" />
    </a>
    &emsp; &emsp; &emsp;
    <a href="https://www.ngrsoftlab.ru/?utm_source=tg&utm_medium=start" >
      <img src="https://shields.io/badge/ngr-web--page-yellow?style=for-the-badge&logo=data:image/svg%2bxml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIGZpbGw9Im5vbmUiIHZpZXdCb3g9IjIyLjcgMCA1MS45IDUxLjciPjxwYXRoIGZpbGwtcnVsZT0iZXZlbm9kZCIgY2xpcC1ydWxlPSJldmVub2RkIiBkPSJNNzQuNSAwSDYzLjhsMy42IDMuNWMuNy43LjcgMS45IDAgMi43LS43LjctMS45LjctMi42IDBMNTguOSAwSDUzbDE0LjUgMTMuOWMuNy43LjcgMS45IDAgMi43LS43LjctMS45LjctMi42IDBMNDkgMGgtNi44bDI1LjMgMjQuM2MuNy43LjcgMS45IDAgMi43LS43LjctMS45LjctMi42IDBMMzkgMGgtNy43bDM2LjEgMzQuN2MuNy43LjcgMS45IDAgMi42cy0xLjkuNy0yLjYgMEwyOSAwYy0zLjUuNC02LjMgMy40LTYuMyA3djQ0LjdoMTAuNmwtMy42LTMuNGMtLjctLjctLjctMS45IDAtMi42czEuOS0uNyAyLjcgMGw1LjggNmg1LjlMMjkuNyAzNy45Yy0uNy0uNy0uNy0xLjkgMC0yLjcuNy0uNyAxLjktLjcgMi43IDBsMTUuOCAxNi40SDU1TDI5LjggMjcuNGMtLjctLjctLjctMS45IDAtMi43LjctLjcgMS45LS43IDIuNyAwbDI1LjggMjYuOEg2NkwyOS45IDE2LjljLS43LS43LS43LTEuOSAwLTIuNnMxLjktLjcgMi43IDBsMzUuNyAzNy4yYzMuNS0uMyA2LjMtMy4zIDYuMy03VjB6IiBmaWxsPSIjRjhBRDAwIi8+PC9zdmc+" alt="NGR Social Media" height="40" />
    </a>
  </h4>
</div>

<!-- markdownlint-enable MD033 -->

## Contents

- [PostgreSQL Pro](#postgresql-pro)
  - [Description](#description)
  - [Contents](#contents)
  - [What is it](#what-is-it)
  - [Supported Technologies](#supported-technologies)
  - [How to work with](#how-to-work-with)
    - [Build variables](#build-variables)
  - [Features of the certified version assembly](#features-of-the-certified-version-assembly)
    - [Build variables certified](#build-variables-certified)
  - [How to run this](#how-to-run-this)
    - [Initialization scripts](#initialization-scripts)
    - [Database Configuration](#database-configuration)
    - [Security configuration](#security-configuration)
    - [Environment variables](#environment-variables)
  - [Migration plan](#migration-plan)
  - [Available extensions](#available-extensions)
  - [Package information](#package-information)
  - [Issues and solutions](#issues-and-solutions)
  - [Miscellaneous](#miscellaneous)

## [What is it](#contents)

Dockerfile для сборки PostgreSQL Pro, на базе отечественной ОС AstraLinux

## [Supported Technologies](#contents)

<!-- markdownlint-disable MD033 -->
|                                                 OS                                                  |                                                                                                                                    Postgres                                                                                                                                     | Status            |
| :-------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: | :---------------- |
| ![Astra 1.8](https://img.shields.io/badge/Astra-1.8.x-00ADD8?style=flat&logo=astra&logoColor=white) | ![Postgres Pro 15](https://img.shields.io/badge/postgres--pro-15-%23316192.svg?style=flat&logo=postgresql&logoColor=white) <br> ![Postgres Pro 15 Certified](https://img.shields.io/badge/postgres--pro--certified-15-%23316192.svg?style=flat&logo=postgresql&logoColor=white) | ✅ Fully supported |

<div align="center"> <sub> Таблица 1. Поддерживаемые версии Postgres Pro. </sub> </div>
<!-- markdownlint-enable MD033 -->

## [How to work with](#contents)

Для начала работы необходимо установить [pre-commit](https://pre-commit.com/) и хуки

```console
$ pip install pre-commit
$ pre-commit --version

pre-commit 4.2.0

$ pre-commit install

pre-commit installed at .git/hooks/pre-commit
pre-commit installed at .git/hooks/commit-msg
pre-commit installed at .git/hooks/pre-push
```

> [!warning]
> Чтобы проверить свои изменения, воспользуйтесь командой `pre-commit run --all-files`.
> Чтобы проверить конкретную задачу, воспользуетесь командой `pre-commit run <target> --all-files`.

Собрать образ `Astra Linux based`

> [!warning]
> Для установки продуктов Postgres Pro из закрытых репозиториев потребуется ключ доступа из Администрирование → Набор лицензий → Репозитории, ключи доступа доступны только Администраторам Наборов лицензий.
> Там же рядом с ключами доступа есть ссылки на репозитории и инструкции по их подключению для всех доступных продуктов.
> Ключи доступа являются идентификаторами организации, их следует беречь от утечек, как и любые другие учётные данные.
> В случае утечки ключ доступа может быть заблокирован Администратором Набора лицензий, а также сотрудниками Postgres Pro.
> При этом доступ к репозиториям, которые были подключены с этим ключом доступа, будет тоже заблокирован.
> Обратите внимание, что репозитории доступны только во время действия сертификатов на техническую поддержку соответствующих продуктов, после окончания действия сертификатов, репозитории закроются автоматически

Первым делом создайте из [действующего шаблона](configuration/auth.conf.example) файл с чувствительными данными, который обеспечить доступ до желаемых репозиториев:

```console
$ cp configuration/auth.conf.example configuration/auth.conf

## Edit 'configuration/auth.conf' file
```

Причина использования такого подхода объясняется [тут](https://docs.docker.com/build/building/secrets/). Для сохранения чувствительных данных, в production среде, сборку необходимо осуществлять без `--progress=plain` параметра

Затем можно приступив к сборке воспользовавшись одним из нижеперечисленных примеров по сборке:

```shell
## Export PostgreSQL version
export ASTRA_VERSION='1.8.2-slim'
export POSTGRES_VERSION="15-astra${ASTRA_VERSION}"

## PostgreSQL image: 189MB
docker build \
    --secret id=pg_auth,src=configuration/auth.conf \
    --progress=plain \
    --no-cache \
    -t postgres-pro:"${POSTGRES_VERSION}" \
    .
```

> [!note]
> СУБД Postgres Pro Standard
> Может быть установлена из online-репозиториев, инструкции по их подключению к своей версии ОС можно получить тут: <https://postgrespro.ru/products/download/postgrespro/latest?forclientsonly=1&key=XXXX-XXXXXX-XXXXXX>, где XXXX-XXXXXX-XXXXXX — ключ доступа из Администрирование → Набор лицензий → Репозитории, ключи доступа доступны только Администраторам Наборов лицензий.
> Документация [по установке](https://postgrespro.ru/docs/postgrespro/current/installation-bin)

Собрать `Astra Linux based` образ на другой платформе, например для 1С

```shell
## Export PostgreSQL version
export ASTRA_VERSION='1.8.2-slim'
export POSTGRES_VERSION="15-1c-astra${ASTRA_VERSION}"

## PostgreSQL image: 180MB
docker build \
    --secret id=pg_auth,src=configuration/auth.conf \
    --progress=plain \
    --no-cache \
    --build-arg postgrespro_link=https://repo.postgrespro.ru/1c/1c-15/keys/pgpro-repo-add.sh \
    --build-arg postgrespro_package_suffix=1c-15 \
    --build-arg postgrespro_version=15 \
    -t postgres-pro:"${POSTGRES_VERSION}" \
    .
```

> [!note]
> СУБД Postgres Pro для 1С:
> является тем же самым продуктом, что и обычный Postgres Pro Standard. Отличие только в лицензии, которая запрещает любое другое легальное использование данной СУБД, кроме как с 1С. Установка описана выше.

### [Build variables](#contents)

| Имя                          |                      Значение по умолчанию                      |   Тип   |                                                                                                      Описание |
| :--------------------------- | :-------------------------------------------------------------: | :-----: | ------------------------------------------------------------------------------------------------------------: |
| `image_registry`             |                               ''                                | string  |                   Адрес до реестра образа. Например: `--build-arg image_registry=my-container-registry:1111/` |
| `image_name`                 |                              astra                              | string  |                                                                                                   Имя образа. |
| `image_version`              |                           1.8.2-slim                            | string  |                                                                                                Версия образа. |
| `version`                    |                              1.0.0                              |  float  |                                                                       Версия выпуска минимального контейнера. |
| `postgrespro_link`           | <https://repo.postgrespro.ru/std/std-15/keys/pgpro-repo-add.sh> | string  | Ссылка до скрипта из [инструкции по установке](https://postgrespro.ru/products/download/postgrespro/15.12.1). |
| `postgrespro_package_suffix` |                             std-15                              | string  |                                                                         Версия выпуска пакета PostgreSQL Pro. |
| `postgrespro_version`        |                               15                                | integer |                                                                       Мажорная версия выпуска PostgreSQL Pro. |

<!-- markdownlint-disable MD033 -->
<div align="center"> <sub> Таблица 2. Переопределяемые аргументы для Dockerfile Postgres Pro. </sub> </div>
<!-- markdownlint-enable MD033 -->

## [Features of the certified version assembly](#contents)

> [!warning]
> Данные выше способы сопоставимы только не для сертифицированной версии!

Для сертифицированной, необходимо скачать базовый ISO образ(на момент написания поставка осуществлялась именно так) выданной в ЛК postgres-a. Скачать его можно в `tmp` директорию. Далее перейти в данную директорию распаковать его при помощи команды `7z x -opostgres-cert *.iso` (если `7z` отсутствует, то его необходимо установить в ОС при помощи пакета `p7zip-full`(для deb) или иной, в зависимости от вашей системы). Финальный шаг - это подготовка к установке `postgres-pro-certified` в контейнерной среде

```console
## Перемещаем файловый репозиторий в специально подготовленную директорию, на примере: Astra Smolensk 1.8_x86-64
$ cp -R tmp/postgres-cert/astra-smolensk/1.8/* opt/

## Обязательно проверьте, чтобы GPG ключ имел определенную запись: 'opt/keys/GPG-KEY-POSTGRESPRO'
$ cp -R tmp/postgres-cert/keys opt/

## Затем можно запускать сборку при помощи докера
```

```shell
## Export PostgreSQL version
export ASTRA_VERSION='1.8.2-slim'
export POSTGRES_VERSION="15-certified-astra${ASTRA_VERSION}"

## PostgreSQL image: 189MB
docker build \
    --progress=plain \
    --no-cache \
    -f Dockerfile.certified \
    -t postgres-pro:"${POSTGRES_VERSION}" \
    .
```

### [Build variables certified](#contents)

| Имя                          | Значение по умолчанию |   Тип   |                                                                                    Описание |
| :--------------------------- | :-------------------: | :-----: | ------------------------------------------------------------------------------------------: |
| `image_registry`             |          ''           | string  | Адрес до реестра образа. Например: `--build-arg image_registry=my-container-registry:1111/` |
| `image_name`                 |         astra         | string  |                                                                                 Имя образа. |
| `image_version`              |      1.8.2-slim       | string  |                                                                              Версия образа. |
| `version`                    |         1.0.0         |  float  |                                                     Версия выпуска минимального контейнера. |
| `postgrespro_package_suffix` |        std-15         | string  |                                             Версия выпуска пакета PostgreSQL Pro Certified. |
| `postgrespro_version`        |          15           | integer |                                           Мажорная версия выпуска PostgreSQL Pro Certified. |

<!-- markdownlint-disable MD033 -->
<div align="center"> <sub> Таблица 3. Переопределяемые аргументы для Dockerfile Postgres Pro Certified. </sub> </div>
<!-- markdownlint-enable MD033 -->

## [How to run this](#contents)

Базовый пример запуска контейнера

```shell
## Export PostgreSQL version
export ASTRA_VERSION='1.8.2-slim'
export POSTGRES_VERSION="15-astra${ASTRA_VERSION}"

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

## Example for 1C database
export ASTRA_VERSION='1.8.2-slim'
export POSTGRES_VERSION="15-1c-astra${ASTRA_VERSION}"

docker run --rm -d \
  --name postgres-pro \
  -e POSTGRES_PASSWORD=mypassword \
  -e LOCALE=ru_RU.utf8 \
  -e TZ="Europe/Moscow" \
  -v /mnt/volume/for/pg_Database:/var/lib/pgpro/1c-15/data \
  -p 5432:5432 \
  postgres-pro:"${POSTGRES_VERSION}"
```

Пример запуска контейнера со сгенерированными сертификатами

```shell
## Export PostgreSQL version
export ASTRA_VERSION='1.8.2-slim'
export POSTGRES_VERSION="15-astra${ASTRA_VERSION}"
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

Если Вы хотите выполнить дополнительную инициализацию в образе, добавьте один или несколько скриптов в директорию `/docker-entrypoint-initdb.d` в формате: `*.sql`, `*.sql.gz` `*.sh`. После того, как `docker-entrypoint.sh` вызывает создание пользователя и базы данных, следом выполнит все исполняемые `*.sh` скрипты, все `*.sql` файлы и экспортирует в качестве источника все неисполняемые `*.sh` скрипты, найденные в этом каталоге, для выполнения дальнейшей инициализации перед запуском службы.

> [!warning]
> Скрипты в `/docker-entrypoint-initdb.d` запускаются только в том случае, если Вы запускаете контейнер с пустым каталогом данных.
> Любая существующая база данных останется нетронутой при запуске контейнера. Одна из распространенных проблем заключается в том, что если один из ваших `/docker-entrypoint-initdb.d` скриптов завершается неудачно (что приводит к завершению работы скрипта точки входа) и ваш оркестратор перезапускает контейнер с уже инициализированным каталогом данных, он не продолжит работу с вашими скриптами

- Пример запуска контейнера со скриптами инициализации. Тесты создадут как пространство в базе данных, так и проведут стресс тест, где создадут таблицу и произведут вставку 1'000'000 записей

```shell
## Export PostgreSQL version
export ASTRA_VERSION='1.8.2-slim'
export POSTGRES_VERSION="15-astra${ASTRA_VERSION}"

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

## Checking database availability
COUNTER=0
until pg_isready -h localhost -p 5432 -U "${DOCKER_DATABASE_USER}" >/dev/null 2>&1; do
  echo "Waiting for the database to be ready, attempt number: $((COUNTER+1))"
  sleep 3
  ((COUNTER++)) || true
done
echo "Ready to accept connection"

## Check scripts work
PGPASSWORD='haha' psql -U abuba -h localhost -d abuba -qAXt -c 'SELECT key FROM license;'
PGPASSWORD='haha' psql -U abuba -h localhost -d abuba -qAXt -c "SELECT COUNT(*) FROM test_data;"
PGPASSWORD='test' psql -U docker -h localhost -d docker -c "SELECT 'Tables exists' AS check, COUNT(*) AS tables FROM information_schema.tables;"
PGPASSWORD='test' psql -U docker -h localhost -d docker -c "select now();"

## Large query be careful
PGPASSWORD='haha' psql -U abuba -h localhost -d abuba -c 'SELECT * FROM test_data;'
```

### [Database Configuration](#contents)

```shell
## Export PostgreSQL version
export ASTRA_VERSION='1.8.2-slim'
export POSTGRES_VERSION="15-astra${ASTRA_VERSION}"

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

Пример запуска наиболее безопасного образа PostgreSQL с соблюдением SecOps методологии

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

## Test connection
PGPASSWORD="$(grep POSTGRES_PASSWORD .env | cut -d= -f2)" psql -U "$(grep POSTGRES_USER .env | cut -d= -f2)" -h localhost -d "$(grep POSTGRES_DB .env | cut -d= -f2)" -c "select now();"

## After test, remove directories and turn off compose stack
docker compose down
sudo rm -rf certs
sudo rm -rf test
```

### [Environment variables](#contents)

| Имя                         |                Значение по умолчанию                |    Тип     |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            Описание |
| :-------------------------- | :-------------------------------------------------: | :--------: | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
| `LOCALE`                    |                     en_US.UTF8                      |   string   |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             Задаёт локаль при [инициализации базы данных](configuration/docker-entrypoint.sh#L314). |
| `POSTGRES_PASSWORD`         |                     NGRSoftlab                      |   string   |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   Пароль по умолчанию для доступа к базе данных, если не был установлен иной при помощи переменной. |
| `DEBUG`                     |                         ''                          |   string   |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     Включить режим отладки для входной точки. Установите переменную как `-e DEBUG=ON` чтобы включить режим отладки. |
| `POSTGRES_USER`             |                      postgres                       |   string   |                                                                                                                                                                                                                                                                                            Эта необязательная переменная среды используется вместе с `POSTGRES_PASSWORD` для установки пользователя и его пароля. Эта переменная создаст указанного пользователя с полномочиями суперпользователя и базу данных с тем же именем. Если она не указана, то `postgres` будет использоваться пользователь по умолчанию. |
| `POSTGRES_DB`               |                      postgres                       |   string   |                                                                                                                                                                                                                                                                                                                                                                              Эта необязательная переменная среды может использоваться для определения другого имени для базы данных по умолчанию, которая создается при первом запуске образа. Если она не указана, то будет использовано `POSTGRES_USER` значение. |
| `POSTGRES_INITDB_ARGS`      |                         ''                          |   string   |                                                                                                                                                                                                                                                                          Эта необязательная переменная среды может использоваться для отправки аргументов в `postgres initdb`. Значение представляет собой строку аргументов, разделенных пробелами, как и ожидает `postgres initdb`. Это полезно для добавления функций, таких как контрольные суммы страниц данных: `-e POSTGRES_INITDB_ARGS="--data-checksums"`. |
| `POSTGRES_INITDB_WALDIR`    |                         ''                          |   string   |                                                                                                                                                                                                   Эта необязательная переменная среды может использоваться для определения другого местоположения журнала транзакций Postgres. По умолчанию журнал транзакций хранится в подкаталоге основной директории данных Postgres(`PGDATA`). Иногда может быть желательно хранить журнал транзакций в другом каталоге, который может поддерживаться хранилищем с другими характеристиками производительности или надежности. |
| `POSTGRES_HOST_AUTH_METHOD` |                         ''                          |   string   |                                                                                                                                                                                    Эта необязательная переменная может использоваться для управления `auth-method` соединениями `host`, `all` для баз данных, `all` для пользователей и `all` для адресов. Если не указано, то используется `scram-sha-256`аутентификация по паролю. В неинициализированной базе данных это будет заполнено pg_hba.conf примерно этой строкой: `echo "host all all all ${POSTGRES_HOST_AUTH_METHOD}" >> pg_hba.conf` [^1] [^2] [^3] |
| `PGDATA`                    | `/var/lib/pgpro/${postgrespro_package_suffix}/data` | stringspec | Эта необязательная переменная может использоваться для определения другого местоположения — например, подкаталога — для файлов базы данных. Значение по умолчанию — `/var/lib/pgpro/${postgrespro_package_suffix}/data`. Если используемый вами том данных — это точка монтирования файловой системы (например, постоянные диски `GCE`) или удаленная директория, которая не может быть назначена пользователю `postgres`(например, некоторые монтирования `NFS`), или содержит директории/файлы (например, `lost+found`), Postgres `initdb` требует создания подкаталога в точке монтирования для хранения данных. |

<!-- markdownlint-disable MD033 -->
<div align="center"> <sub> Таблица 4. Переопределяемые переменные для [Docker-entrypoint.sh](configuration/docker-entrypoint.sh). </sub> </div>
<!-- markdownlint-enable MD033 -->

## [Migration plan](#contents)

Миграция, в контейнерной среде, осуществляется при помощи встроенной утилиты `pg_dumpall`

> [!warning]
> Перед началом миграции оставьте поднятым/включенным старый контейнер, с актуальной базой

Первым шагом, будет снятие дампа со старой базы. В среде контейнера это будет выглядеть следующим образом:

```shell
docker exec -t postgres pg_dumpall -c -U postgres > backup.sql
```

Следующим шагом, поднимите контейнер с PostgreSQL Pro с маппингом данных в другое место. Дайте время на инициализацию новой базы. Затем произведите закачку дампа в новую базу:

```shell
cat backup.sql | docker exec -i postgres-pro psql -U postgres
```

> [!note]
> Доступы, пользователи могут отличаться. Данные, что выше, приведены в качестве примера со стандартной базой

После проведенных манипуляций и отсутствии ошибок, можно сказать, что миграция завершена.

## [Available extensions](#contents)

Список расширений, доступный в PostgreSQL Pro

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

## [Package information](#contents)

В постовляемом репозитории существует множество связанных пакетов, имеющих отношение к `PostgreSQL Pro`. На примере 15 версии, при поиске посредством `apt search postgrespro` или `apt-cache search postgrespro | sed -e 's# - # | #g' -e 's#^#| #g' -e 's#$# |#g'`. Подробнее [тут](https://postgrespro.ru/docs/postgrespro/current/binary-installation-on-linux#CHOOSING-PGPRO-PACKAGES)

|                 Имя                 | Описание                                                                       |
| :---------------------------------: | :----------------------------------------------------------------------------- |
|       odbc-postgrespro-std-15       | ODBC driver for PostgresPro                                                    |
|   odbc-postgrespro-std-15-dbgsym    | debug symbols for odbc-postgrespro-std-15                                      |
|         pg-filedump-std-15          | Utility to recover data from broken PostgresPro Standard 15 database           |
|         postgrespro-std-15          | Easy configuration for Postgres Pro Standard 15                                |
|      postgrespro-std-15-client      | front-end programs for Postgres Pro Standard 15                                |
|  postgrespro-std-15-client-dbgsym   | debug symbols for postgrespro-std-15-client                                    |
|     postgrespro-std-15-contrib      | additional facilities for Postgres Pro Standard 15                             |
|  postgrespro-std-15-contrib-dbgsym  | debug symbols for postgrespro-std-15-contrib                                   |
|       postgrespro-std-15-dev        | development files for Postgres Pro Standard 15 programming                     |
|    postgrespro-std-15-dev-dbgsym    | debug symbols for postgrespro-std-15-dev                                       |
|       postgrespro-std-15-docs       | documentation for the Postgres Pro Standard database management system         |
|     postgrespro-std-15-docs-ru      | Russian documentation for the Postgres Pro Standard database management system |
|       postgrespro-std-15-jit        | JIT-compiler for Postgres Pro Standard 15                                      |
|    postgrespro-std-15-jit-dbgsym    | debug symbols for postgrespro-std-15-jit                                       |
|       postgrespro-std-15-libs       | PostgresPro C client and ECPG libraries                                        |
|   postgrespro-std-15-libs-dbgsym    | debug symbols for postgrespro-std-15-libs                                      |
|      postgrespro-std-15-plperl      | PL/Perl procedural language for PostgresPro Standard 15                        |
|  postgrespro-std-15-plperl-dbgsym   | debug symbols for postgrespro-std-15-plperl                                    |
|    postgrespro-std-15-plpython3     | PL/Python 3 procedural language for Postgre Pro Standard 15                    |
| postgrespro-std-15-plpython3-dbgsym | debug symbols for postgrespro-std-15-plpython3                                 |
|      postgrespro-std-15-pltcl       | PL/Tcl procedural language for Postgres Pro Standard 15                        |
|   postgrespro-std-15-pltcl-dbgsym   | debug symbols for postgrespro-std-15-pltcl                                     |
|      postgrespro-std-15-server      | object-relational SQL database, version 15 server                              |
|  postgrespro-std-15-server-dbgsym   | debug symbols for postgrespro-std-15-server                                    |

<!-- markdownlint-disable MD033 -->
<div align="center"> <sub> Таблица 5. Список поставляемых пакетов, из оффициально репозитория Postgres Pro. </sub> </div>
<!-- markdownlint-enable MD033 -->

Также доступен список поддерживаемых пакетов, постовляемых для PostgreSQL Pro. Существует несколько способов проверить:

- При помощи `apt-cache policy`

```shell
$ apt-cache policy postgrespro-std-15-server

postgrespro-std-15-server:
  Installed: 15.12.1-1.18x8664
  Candidate: 15.12.1-1.18x8664
  Version table:
 *** 15.12.1-1.18x8664 900
        900 http://repo.postgrespro.ru/std/std-15/astra-smolensk/1.8 1.8_x86-64/main amd64 Packages
        100 /var/lib/dpkg/status
```

- При помощи `apt-cache madison`

```shell
$ apt-cache madison postgrespro-std-15-server

postgrespro-std-15-server | 15.12.1-1.18x8664 | http://repo.postgrespro.ru/std/std-15/astra-smolensk/1.8 1.8_x86-64/main amd64 Packages
```

- При помощи `apt list -a`

```shell
$ apt list -a postgrespro-std-15-server

postgrespro-std-15-server/unknown,now 15.12.1-1.18x8664 amd64 [installed]
```

## [Issues and solutions](#contents)

- [По умолчанию](configuration/docker-entrypoint.sh#L333) PostgreSQL Pro имеет `scram-sha-256` метод аутентификации, что [отличается](https://github.com/docker-library/postgres/blob/master/15/bookworm/docker-entrypoint.sh#L242) от PostgreSQL. Чтобы предотвратить отличного от PostgreSQL поведения, при миграции на Pro версию, следует дополнительно передать переменную `POSTGRES_HOST_AUTH_METHOD`, которая вернёт поведение как в раннем Postgres-e. Пример передачи: `-e POSTGRES_HOST_AUTH_METHOD=md5`. Альтернативно, можно замаппить `pg_hba.conf` [файл](https://www.postgresql.org/docs/current/auth-pg-hba-conf.html), предварительно экспортировав его из старого Postgres-а, но данный вариант ялвяеться грязным трюком(dirty trick).

- Если, при старте PostgreSQL Pro на данные прошлой базы, Вы встречаетесь с содержимым, что представлены ниже, то необходимо осуществить [плановую миграцию](#migration-plan) на PostgreSQL Pro.

```text
...
An old version of the database format was found.
You need to dump and reload before using Postgres Pro std-15.
```

## [Miscellaneous](#contents)

Лого для проекта создано при помощи [`aasvg`](https://github.com/martinthomson/aasvg) проекта. Вы можете создать такое же и/или модифицировать имеющееся. Для этого воспользуйтесь [сайтом](https://patorjk.com/software/taag/#p=display&f=Doom) или установите `figlet`. Если Вы используете способ с установкой `figlet`, то вдобавок необходимо сказать необходимый шрифт, например я использую `Doom`. Далее, необходимо воспользоваться `aasvg` и конвертировать `ascii` арт в `svg`. Обратите внимание - по умолчанию будет svg в красном цвете, чтобы изменить цвет, необходимо изменить его определение [тут](docs/images/logo.svg#L76). Конвертация цвета происходит по следующему принципу - `%23316192`, где `%23` это закодированный URL символ `#`, итоговое получаемое значение `#316192`

```console
$ curl 'http://www.figlet.org/fonts/doom.flf' -o /usr/share/figlet/doom.flf
$ curl 'http://www.figlet.org/fonts/larry3d.flf' -o /usr/share/figlet/larry3d.flf
$ figlet -f doom 'PostgresPro'

______         _                    ______
| ___ \       | |                   | ___ \
| |_/ ___  ___| |_ __ _ _ __ ___ ___| |_/ _ __ ___
|  __/ _ \/ __| __/ _` | '__/ _ / __|  __| '__/ _ \
| | | (_) \__ | || (_| | | |  __\__ | |  | | | (_) |
\_|  \___/|___/\__\__, |_|  \___|___\_|  |_|  \___/
                   __/ |
                  |___/

$ aasvg --source --embed < docs/ascii.txt > docs/images/logo.svg
```

---

[^1]: 🛠️ Не рекомендуется использовать, `trust` так как это позволяет любому подключаться без пароля, даже если он установлен (например, через `POSTGRES_PASSWORD`). Для получения дополнительной информации см. документацию PostgreSQL по [Trust Authentication](https://www.postgresql.org/docs/14/auth-trust.html)
[^2]: 🛠️ Если установлено `POSTGRES_HOST_AUTH_METHOD` значение `trust`, то `POSTGRES_PASSWORD` не требуется
[^3]: 🛠️ Если Вы установите для этого параметра альтернативное значение (например, `md5`), вам могут потребоваться дополнительные параметры `POSTGRES_INITDB_ARGS` для правильной инициализации базы данных (например, `POSTGRES_INITDB_ARGS=--auth-host=md5`).
