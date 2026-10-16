# E6 · Métricas e plano de melhoria

Linha de base: **lead time de 11 dias** · meta: **≤ 2 dias** em até dois meses.

## Coleta (preencher após ≥ 10 execuções)
| # | Commit | Início do commit | Prod. em | Lead time | Resultado |
|---|---|---|---|---|---|
| 1 | | | | | |
| … | | | | | |
| 10 | | | | | |

- **Lead time médio** = média(prod − commit)
- **Frequência de implantação** = nº de deploys em produção / semana
- **Taxa de falha** = builds com falha / total de builds

## Plano de melhoria
| Ação | Ganho esperado |
|---|---|
| Paralelizar lint e testes | −2 a −5 min por build |
| Automatizar homologação a cada merge na `main` | elimina espera manual (dias) |
| Aprovação com SLA de 4 h e notificação | reduz espera para produção |
| Cache de `npm` e camadas Docker | build mais rápido |

## Custo mensal estimado na Azure (meta ≤ US$ 150)
| Recurso | US$/mês (aprox.) |
|---|---|
| Container Registry Basic | 5 |
| App Service B1 Linux (plano compartilhado hml + prd) | 13 |
| Tráfego/logs | ~5 |
| **Total** | **~23** (confirmar na calculadora de preços da Azure) |
