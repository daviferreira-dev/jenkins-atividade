# E5 · Multibranch + webhook

1. Jenkins: *New Item → Multibranch Pipeline* → *Branch Sources: GitHub* → credencial (token) → URL do repositório → *Script Path*: `Jenkinsfile`.
2. GitHub: *Settings → Webhooks → Add webhook* → Payload URL `https://<jenkins-acessível>/github-webhook/` (via proxy HTTPS ou túnel, nunca 8080 aberta) → eventos *push* e *pull request*.
3. GitHub: *Settings → Branches → Add rule* para `main`: exigir PR e o check do Jenkins verde antes do merge.
4. Abrir um PR de exemplo: apenas os stages Qualidade e Imagem rodam; Publicação, Homologação, Aprovação e Produção são exclusivos da `main` (`when { branch 'main' }`).

> Evidência: print do job por branch/PR, do webhook e da regra de proteção.
