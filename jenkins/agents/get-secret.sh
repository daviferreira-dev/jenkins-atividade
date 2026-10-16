#!/usr/bin/env bash
# Uso: ADMIN_PASSWORD=... ./get-secret.sh <nome-do-nó>   (imprime o segredo do agent)
set -euo pipefail
NODE="${1:?nome do nó (linux-agent|windows-agent)}"
: "${ADMIN_PASSWORD:?defina ADMIN_PASSWORD}"
URL="${JENKINS_URL:-http://localhost:8080}"
curl -fsS -u "admin:${ADMIN_PASSWORD}" "$URL/computer/$NODE/jenkins-agent.jnlp" \
  | grep -oE '<argument>[0-9a-f]{64}</argument>' | head -1 | sed -E 's#</?argument>##g'
