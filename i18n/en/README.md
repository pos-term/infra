# infra

> **Language:** English | [Русский](../../README.md)

Project infrastructure: Docker Compose and configs for local and test deployment of Kafka, Redis, Postgres, and the payment-processor service.

## Running

```bash
cp .env.example .env
docker compose up --build
```

The `payment-processor` service is built from the sibling repository: `payment-processor` must be checked out next to `infra` (`../payment-processor`). Check: `curl http://localhost:8080/healthz`.

> In the future the `payment-processor` image will be published to a registry, and building from the sibling repository will no longer be needed.

## Contracts

- [REST API](../../api/i18n/en/README.md): OpenAPI, Swagger UI at http://localhost:8089
- [Kafka](../../docs/kafka/i18n/en/README.md): topics and message schemas

> General project information and participants: https://github.com/pos-term/.github/blob/main/i18n/README_EN.md
