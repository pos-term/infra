# payment-processor REST API

> **Язык / Language:** [Русский](../../README.md) | English

The REST API contract between `payment-processor` and the cashier Android app `mobile-dashboard`. Specification: [`openapi.yaml`](../../openapi.yaml) (OpenAPI 3.1). Swagger UI runs in Docker Compose: http://localhost:8089.

REST is read-only. Transactions are created by terminals through Kafka; the message format is described in [docs/kafka](../../../docs/kafka/i18n/en/README.md).

## Endpoints

| Method | Path | Purpose |
|---|---|---|
| GET | `/v1/transactions` | Transaction history. Filters: `terminal_id`, `status`, `from`, `to`. Pagination: `limit`, `cursor` |
| GET | `/v1/transactions/{transaction_id}` | Status of one transaction |
| GET | `/v1/transactions/stream` | Real-time updates (SSE) |
| GET | `/v1/terminals` | Known terminals, for the filter in the app |
| GET | `/healthz` | Liveness probe, no token required |

## Decisions

- **The `Transaction` model** uses the same field names and formats as the Kafka contract: `transaction_id` (UUIDv7), `terminal_id`, `amount_minor`, `currency`, `reason`, time as RFC 3339 UTC with milliseconds. REST adds the `pending` status: it is not published to Kafka, but the cashier needs to see a payment that is being processed.
- **Real time: SSE.** The stream is server-to-client only, which is simpler to implement than WebSocket. Every status change arrives as a `transaction.updated` event whose body is a `Transaction`. After a disconnect the client reconnects with the `Last-Event-ID` header and the server replays what was missed. If there is nothing left to replay from, the server first sends a `resync` event: the client reloads history via `GET /v1/transactions`. The server sends a keep-alive every 15 seconds. There may be several processor instances; events are fanned out between them through Redis pub/sub.
- **Authentication:** a static Bearer token shared by cashier apps and set in the processor configuration. This is prototype-level protection: no accounts, no token rotation. Every endpoint except `/healthz` requires the token. The SSE client must be able to set headers (e.g. OkHttp-sse).
- **Scope:** a cashier sees transactions of all terminals; the `terminal_id` filter is optional.
- **Pagination:** cursor-based, newest first. The order is defined by `transaction_id`: UUIDv7 is ordered by creation time. The cursor is opaque and taken from `next_cursor`.
- **Errors:** RFC 9457 format (`application/problem+json`) with a stable `code` field: `invalid_parameter`, `unauthorized`, `not_found`, `internal_error`.
- **`reason` codes:** the list is not fixed yet; it is shared with the Kafka contract (`pos.transaction-results.v1`).

## Versioning

The API version is part of the path (`/v1`). Breaking changes ship as `/v2`; adding optional fields and endpoints does not change the version.
