# Метрики процессора платежей

> **Язык / Language:** Русский | [English](i18n/en/README.md)

`GET /metrics` отдаёт счётчики в формате Prometheus на HTTP-порту процессора. Для запроса нужен заголовок `Authorization: Bearer <API_TOKEN>`. При отсутствии токена или неверном токене процессор возвращает `401`. Мониторинг обращается к процессору напрямую.

| Счётчик | Когда увеличивается |
|---|---|
| `payment_processor_results_published_total{status="success"}` | Kafka подтвердила публикацию успешного результата |
| `payment_processor_results_published_total{status="failed"}` | Kafka подтвердила публикацию результата с бизнес-отказом |
| `payment_processor_dlq_published_total` | Kafka подтвердила публикацию сообщения в DLQ |
| `payment_processor_processing_retries_total` | Обработчик повторно запускается для той же записи после временной ошибки и ожидания |

Счётчики начинаются с нуля у каждого экземпляра. Повторная публикация результата по гарантии at-least-once увеличивает счётчик ещё раз. Число уникальных платежей определяется по `transaction_id` в Postgres. Единственная метка — `status` с фиксированными значениями `success` и `failed`.

Для локального Compose со стандартным тестовым токеном:

```bash
curl -fsS -H 'Authorization: Bearer dev-token' http://localhost:8080/metrics
```
