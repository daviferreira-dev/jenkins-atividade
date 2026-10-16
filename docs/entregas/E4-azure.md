# E4 · Integração com a Azure

## 1. Service principal com escopo mínimo
```bash
az group create --name rg-carparts --location brazilsouth
az ad sp create-for-rbac --name sp-jenkins-carparts --role Contributor \
  --scopes /subscriptions/<ID_ASSINATURA>/resourceGroups/rg-carparts
```
A saída (`appId`, `password`, `tenant`) é mostrada uma vez: cadastre direto no Jenkins e **não salve em arquivo**.

## 2. Credenciais no Jenkins (Manage Jenkins → Credentials)
| ID | Tipo | Conteúdo |
|---|---|---|
| `azure-sp` | Username with password | usuário = `appId`, senha = `password` |
| `azure-tenant-id` | Secret text | tenant |

## 3. Recursos de homologação e produção
```bash
az acr create -g rg-carparts -n carpartsacr --sku Basic
az appservice plan create -g rg-carparts -n plan-carparts --is-linux --sku B1
for env in hml prd; do
  az webapp create -g rg-carparts -p plan-carparts -n carparts-api-$env \
    --container-image-name carpartsacr.azurecr.io/carparts-api:0
  az webapp identity assign -g rg-carparts -n carparts-api-$env
  # AcrPull para a identidade do app
  az role assignment create --assignee "$(az webapp identity show -g rg-carparts -n carparts-api-$env --query principalId -o tsv)" \
    --role AcrPull --scope "$(az acr show -n carpartsacr --query id -o tsv)"
done
```
O deploy é feito por `scripts/deploy.sh` (Azure CLI) seguido de `scripts/smoke-test.sh`, que consulta `/health` e confere se o `build` em execução é a tag implantada.

## Rollback
`./scripts/deploy.sh producao <tag-anterior>` reimplanta a imagem anterior, que permanece no ACR.

> Evidência: print do pipeline, do App Service atualizado e da credencial no Jenkins (sem valores).
