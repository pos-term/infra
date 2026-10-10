# infra

> **Язык / Language:** Русский | [English](i18n/en/README.md)

Инфраструктура проекта: Docker Compose и конфиги для локального и тестового развёртывания Kafka, Redis, Postgres и сервиса payment-processor.

## Запуск

```bash
cp .env.example .env
docker compose up --build
```

Сервис `payment-processor` собирается из соседнего репозитория: `payment-processor` должен лежать рядом с `infra` (`../payment-processor`). Проверка: `curl http://localhost:8080/healthz`.

> В будущем образ `payment-processor` будет публиковаться в реестр, и сборка из соседнего репозитория станет не нужна.

## Контракты

- [REST API](api/README.md): OpenAPI, Swagger UI на http://localhost:8089
- [Kafka](docs/kafka/README.md): топики и схемы сообщений

> Общая информация по проекту и участниках: https://github.com/pos-term/.github/blob/main/profile/README.md
