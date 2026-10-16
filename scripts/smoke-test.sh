#!/usr/bin/env bash
# Uso: smoke-test.sh <url-base> <tag-esperada>
set -euo pipefail
BASE="${1:?url base}"; TAG="${2:?tag esperada}"
body=$(curl --fail --silent --retry 6 --retry-delay 15 --retry-connrefused "$BASE/health")
echo "$body"
echo "$body" | grep -q "\"build\":\"$TAG\"" || { echo "versão em execução não é a $TAG" >&2; exit 1; }
