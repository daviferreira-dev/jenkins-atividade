# Plano de entrega (seção 13)

Aluno: Davi Ferreira Da Cunha · RA 26179855

## E1 · Arquitetura Jenkins da Carparts — peso 15%
Vou desenhar um diagrama mostrando o controller rodando em contêiner Docker, com 0 executores no nó interno, e os agents: um Linux (Ubuntu 24.04 com Docker, rótulo linux && docker) pra rodar testes e construir imagens, e um Windows 11 pra componentes que dependem desse sistema. Vou indicar as portas usadas (8080 web, 50000 agents) e justificar por que optei por rodar o controller em Docker local em vez de VM ou AKS, considerando o tamanho da equipe e o orçamento. Evidência: print do diagrama e do painel de nodes do Jenkins mostrando os agents conectados.

## E2 · Controller reprodutível (Dockerfile + plugins + JCasC) — peso 15%
Vou criar um Dockerfile baseado na imagem oficial do Jenkins, um plugins.txt com os plugins necessários (Git, Docker Pipeline, Multibranch, Matrix Authorization) e um casc.yaml configurando o controller: 0 executores no nó interno, autorização por matriz e sem acesso anônimo. Depois vou subir o container com docker build e docker run pra provar que a configuração é reprodutível, sem precisar passar pelo assistente manual. Evidência: os três arquivos versionados no repositório e um print do Jenkins já configurado automaticamente na primeira subida.

## E3 · Jenkinsfile de CI/CD — peso 25%
Vou escrever um Jenkinsfile declarativo com agent none no topo, e stages de qualidade (lint e testes com npm), build da imagem Docker, publicação condicionada à branch main, deploy em homologação, uma etapa de aprovação manual com input fora de agent, e deploy em produção promovendo a mesma imagem. Vou usar post pra notificar em caso de falha e publicar os resultados dos testes com junit. Evidência: o arquivo Jenkinsfile no repositório e um print da execução completa do pipeline no Jenkins, mostrando todos os stages verdes.

## E4 · Integração com a Azure — peso 20%
Vou criar um service principal com az ad sp create-for-rbac, limitando o escopo só ao grupo de recursos da aplicação, e cadastrar essas credenciais no Jenkins (usuário/senha e tenant separados). No pipeline, vou usar a Azure CLI pra fazer login, construir a imagem no Azure Container Registry e atualizar o App Service de homologação, seguido de um smoke test no endpoint de saúde. Evidência: prints do pipeline executando o deploy, do App Service atualizado na Azure e da credencial cadastrada no Jenkins (sem expor os valores sensíveis).

## E5 · Multibranch + webhook — peso 10%
Vou configurar um item do tipo Multibranch Pipeline no Jenkins apontando pro repositório no GitHub, e cadastrar um webhook no GitHub apontando pra /github-webhook/ do Jenkins, disparando em eventos de push e pull request. Vou proteger a branch main exigindo que o check do Jenkins passe antes de permitir merge. Evidência: print do Jenkins mostrando um job criado automaticamente por branch/PR, do webhook configurado no GitHub e da regra de proteção de branch ativa.

## E6 · Métricas e plano de melhoria — peso 15%
Vou rodar o pipeline pelo menos 10 vezes e coletar, a partir do histórico do Jenkins, o lead time médio, a frequência de implantação e a taxa de falhas, comparando com a linha de base atual de 11 dias. Com base nesses números, vou montar um plano com ações concretas pra reduzir o lead time até 2 dias (como paralelizar testes e automatizar a homologação) e uma estimativa de custo mensal dos recursos usados na Azure, confirmando que fica dentro dos US$ 150. Evidência: planilha ou tabela com os dados das execuções e o texto do plano de melhoria.

