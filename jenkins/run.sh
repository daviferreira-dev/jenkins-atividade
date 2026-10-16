#!/usr/bin/env bash
# Constrói e sobe o controller. A senha vem do ambiente, nunca do repositório.
set -euo pipefail
: "${ADMIN_PASSWORD:?defina ADMIN_PASSWORD antes de executar}"
cd "$(dirname "$0")"
docker compose up -d --build jenkins
