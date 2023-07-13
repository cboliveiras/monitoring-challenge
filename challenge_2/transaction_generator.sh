hour=0
minute=0

while [ $hour -lt 24 ]; do
  while [ $minute -lt 60 ]; do
    time=$(printf "%02dh%02d" "$hour" "$minute")
    approved=$((RANDOM % 10))
    denied=$((RANDOM % 3))
    refunded=$((RANDOM % 10))
    reversed=$((RANDOM % 3))
    backend_reversed=$((RANDOM % 10))
    failed=$((RANDOM % 3))
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

    minute=$((minute + 1))
  done

  minute=0
  hour=$((hour + 1))
done
