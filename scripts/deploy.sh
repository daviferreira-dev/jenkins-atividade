#!/usr/bin/env bash
# Uso: deploy.sh <homologacao|producao> <tag>
# Requer Azure CLI e as variáveis AZURE_CLIENT_ID, AZURE_CLIENT_SECRET e AZURE_TENANT_ID
# (injetadas pelo withCredentials do Jenkins). Nunca imprime os segredos.
set -euo pipefail

ENV_NAME="${1:?ambiente (homologacao|producao)}"
TAG="${2:?tag da imagem}"
RG="${RG:-rg-carparts}"
ACR="${ACR:-carpartsacr}"
APP="${APP:-carparts-api}"

case "$ENV_NAME" in
  homologacao) WEBAPP="${APP}-hml" ;;
  producao)    WEBAPP="${APP}-prd" ;;
  *) echo "ambiente inválido: $ENV_NAME" >&2; exit 2 ;;
esac

az login --service-principal --username "$AZURE_CLIENT_ID" \
         --password "$AZURE_CLIENT_SECRET" --tenant "$AZURE_TENANT_ID" --output none

# a mesma imagem (mesma tag) é promovida entre os ambientes
az acr repository show --name "$ACR" --image "$APP:$TAG" --output none

az webapp config container set \
  --resource-group "$RG" --name "$WEBAPP" \
  --container-image-name "$ACR.azurecr.io/$APP:$TAG" \
  --container-registry-url "https://$ACR.azurecr.io" --output none
az webapp restart --resource-group "$RG" --name "$WEBAPP"
echo "Deploy de $APP:$TAG em $ENV_NAME ($WEBAPP) concluído."
