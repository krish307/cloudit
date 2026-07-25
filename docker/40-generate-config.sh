#!/bin/sh
set -eu

TEMPLATE_FILE="/usr/share/nginx/html/config.template.js"
OUTPUT_FILE="/usr/share/nginx/html/config.js"

echo "Generating runtime configuration..."

envsubst \
  '${APP_NAME} ${APP_VERSION} ${ENVIRONMENT} ${COMPANY}' \
  < "$TEMPLATE_FILE" \
  > "$OUTPUT_FILE"

echo "Runtime configuration generated:"
cat "$OUTPUT_FILE"