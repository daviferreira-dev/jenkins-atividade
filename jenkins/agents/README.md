# Agents Jenkins (E1)

Os dois nós são declarados no [casc.yaml](../casc.yaml) (inbound, WebSocket), então aparecem no controller já na primeira subida, offline, até o agent conectar.

| Nó | Onde roda | Rótulos | Executores |
|---|---|---|---|
| `linux-agent` | contêiner (Ubuntu/Debian + Docker CLI + Azure CLI) | `linux docker azure-cli` | 2 |
| `windows-agent` | Windows 11 (processo Java) | `windows` | 1 |

## Passo a passo

```bash
# 1) controller
export ADMIN_PASSWORD='...'
./jenkins/run.sh

# 2) segredo do agent Linux e subida do contêiner
export AGENT_SECRET=$(./jenkins/agents/get-secret.sh linux-agent)
export DOCKER_GID=$(stat -c %g /var/run/docker.sock)   # no Docker Desktop costuma ser 999
sudo mkdir -p /opt/jenkins-agent && sudo chown 1000:1000 /opt/jenkins-agent
docker compose -f jenkins/docker-compose.yml --profile agents up -d --build agent-linux
```

```powershell
# 3) agent Windows (Java 21 instalado)
$env:AGENT_SECRET = '<saída de get-secret.sh windows-agent>'
.\jenkins\agents\windows-agent.ps1
```

Print para o E1: *Manage Jenkins → Nodes* com Built-In (0 executores), `linux-agent` e `windows-agent` online.

## Observações
- O agent Linux usa o `docker.sock` do host para construir imagens: isso dá poder de root no host ao agent, por isso só ele (nunca o controller) monta o socket.
- O workspace é montado no mesmo caminho dentro e fora do contêiner (`/opt/jenkins-agent`), senão `agent { docker { ... } }` monta uma pasta vazia.
- Ajuste `remoteFS` do `windows-agent` em `casc.yaml` se o seu usuário não for `Aluno`.
- Esta configuração não foi executada durante a criação (sem Docker na máquina de desenvolvimento).
