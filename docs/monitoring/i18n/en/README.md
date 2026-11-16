# Payment processor metrics

> **Language:** [Русский](../../README.md) | English

`GET /metrics` exposes Prometheus counters on the processor's HTTP port. It requires `Authorization: Bearer <API_TOKEN>`. A missing or wrong token returns `401`. Monitoring clients call the processor directly.

| Counter | Incremented when |
|---|---|
| `payment_processor_results_published_total{status="success"}` | Kafka acknowledges a successful payment result |
| `payment_processor_results_published_total{status="failed"}` | Kafka acknowledges a business decline |
| `payment_processor_dlq_published_total` | Kafka acknowledges a dead-letter message |
| `payment_processor_processing_retries_total` | The handler tries the same record again after a transient error and backoff |

Counters start at zero on each instance. At-least-once redelivery can publish a result again and increment its counter again. Count unique payments by `transaction_id` in Postgres. The only label is `status` with the fixed values `success` and `failed`.

For local Compose with the default test token:

```bash
curl -fsS -H 'Authorization: Bearer dev-token' http://localhost:8080/metrics
```
