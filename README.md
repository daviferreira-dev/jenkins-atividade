# Carparts · CI/CD com Jenkins (SAP1-DEVOPS)

Aluno: Davi Ferreira Da Cunha · RA 26179855

| Entregável | Onde |
|---|---|
| E1 Arquitetura | [docs/entregas/E1-arquitetura.md](docs/entregas/E1-arquitetura.md) |
| E2 Controller reprodutível | [jenkins/](jenkins/) (`Dockerfile`, `plugins.txt`, `casc.yaml`, `docker-compose.yml`, `run.sh`) |
| E1 Agents Linux/Windows | [jenkins/agents/](jenkins/agents/README.md) |
| E3 Jenkinsfile | [Jenkinsfile](Jenkinsfile) |
| E4 Azure | [docs/entregas/E4-azure.md](docs/entregas/E4-azure.md), [scripts/](scripts/) |
| E5 Multibranch + webhook | [docs/entregas/E5-multibranch-webhook.md](docs/entregas/E5-multibranch-webhook.md) |
| E6 Métricas | [docs/entregas/E6-metricas.md](docs/entregas/E6-metricas.md) |
| Plano de entrega (seção 13) | [docs/entregas/plano-de-entrega.md](docs/entregas/plano-de-entrega.md) |
| Evidências (prints/logs) | [docs/entregas/evidencias/](docs/entregas/evidencias/) – checklist por entregável |

Aplicação de exemplo: API Node.js (`src/`, `test/`, `Dockerfile`) com `/health`.

```bash
export ADMIN_PASSWORD='...'   # nunca commitar
./jenkins/run.sh              # sobe o controller em http://localhost:8080
```
Segredos ficam apenas nas credenciais do Jenkins (`azure-sp`, `azure-tenant-id`).
