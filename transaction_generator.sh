#!/bin/bash

while true; do
  time=$(date +%Hh%M)
  approved=$((RANDOM % 10))
  denied=$((RANDOM % 5))
  refunded=$((RANDOM % 10))
  reversed=$((RANDOM % 10))
  backend_reversed=$((RANDOM % 10))
  failed=$((RANDOM % 5))
  processing=$((RANDOM % 8))

  # Construct the JSON payload
  payload='{
    "time": "'"$time"'",
    "data": {
      "approved": '"$approved"',
      "denied": '"$denied"',
      "refunded": '"$refunded"',
      "reversed": '"$reversed"',
      "backend_reversed": '"$backend_reversed"',
      "failed": '"$failed"',
      "processing": '"$processing"'
    }
  }'

  # Make the curl request with the JSON payload
  curl -X POST http://localhost:3000/new_transaction \
    -H "Content-Type: application/json" \
    -d "$payload"

  sleep 60  # Wait for 1 minute before sending the next request
done
