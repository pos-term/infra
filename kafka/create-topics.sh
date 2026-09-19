#!/bin/sh
# Creates the project topics. Idempotent: existing topics are left untouched.
# Partitions and retention of an already existing topic are not changed;
# use kafka-topics.sh --alter or recreate the topic to change them.
set -e

BOOTSTRAP="${BOOTSTRAP_SERVER:-kafka:9092}"
KAFKA_TOPICS=/opt/kafka/bin/kafka-topics.sh

DAY_MS=86400000

create_topic() {
  name="$1"
  partitions="$2"
  retention_days="$3"

  "$KAFKA_TOPICS" --bootstrap-server "$BOOTSTRAP" \
    --create --if-not-exists \
    --topic "$name" \
    --partitions "$partitions" \
    --replication-factor 1 \
    --config "retention.ms=$((retention_days * DAY_MS))"
}

# Payments from terminals: keyed by terminal_id, 3 partitions to scale the processor
create_topic pos.transactions.v1 3 7

# Processing results for terminals: a terminal may be powered off, so keep 3 days
create_topic pos.transaction-results.v1 1 3

# Messages that cannot be processed
create_topic pos.transactions.dlq.v1 1 14

echo "Topics:"
"$KAFKA_TOPICS" --bootstrap-server "$BOOTSTRAP" --list
