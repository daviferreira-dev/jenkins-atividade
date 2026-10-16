pipeline {
    agent none                                  // cada stage escolhe seu agent

    options {
        timeout(time: 45, unit: 'MINUTES')
        buildDiscarder(logRotator(numToKeepStr: '20'))
        disableConcurrentBuilds()
    }

    environment {
        APP      = 'carparts-api'
        ACR      = 'carpartsacr'
        REGISTRY = 'carpartsacr.azurecr.io'
        RG       = 'rg-carparts'
        TAG      = "${env.BUILD_NUMBER}"
        COMMIT   = "${env.GIT_COMMIT}"
    }

    stages {
        stage('Qualidade') {
            agent { docker { image 'node:22-alpine'; label 'linux && docker' } }
            environment { npm_config_cache = "${env.WORKSPACE}/.npm" }
            steps {
                sh 'npm ci'
                sh 'npm run lint'
                sh 'npm test'                   // gera reports/junit.xml
            }
            post {
                always { junit allowEmptyResults: true, testResults: 'reports/*.xml' }
            }
        }

        stage('Imagem') {
            agent { label 'linux && docker' }
            steps {
                sh 'docker build --build-arg BUILD_TAG=$TAG -t $REGISTRY/$APP:$TAG .'
            }
        }

        stage('Publicação no ACR') {
            when { branch 'main' }
            agent { label 'linux && docker && azure-cli' }
            steps {
                withCredentials([usernamePassword(credentialsId: 'azure-sp',
                                                  usernameVariable: 'AZURE_CLIENT_ID',
                                                  passwordVariable: 'AZURE_CLIENT_SECRET'),
                                 string(credentialsId: 'azure-tenant-id', variable: 'AZURE_TENANT_ID')]) {
                    sh '''
                        az login --service-principal --username "$AZURE_CLIENT_ID" \
                                 --password "$AZURE_CLIENT_SECRET" --tenant "$AZURE_TENANT_ID" --output none
                        az acr login --name "$ACR"
                        docker push "$REGISTRY/$APP:$TAG"
                    '''
                }
            }
            post { always { sh 'az logout || true' } }
        }

        stage('Deploy homologação') {
            when { branch 'main' }
            agent { label 'linux && azure-cli' }
            steps {
                withCredentials([usernamePassword(credentialsId: 'azure-sp',
                                                  usernameVariable: 'AZURE_CLIENT_ID',
                                                  passwordVariable: 'AZURE_CLIENT_SECRET'),
                                 string(credentialsId: 'azure-tenant-id', variable: 'AZURE_TENANT_ID')]) {
                    sh './scripts/deploy.sh homologacao "$TAG"'
                }
                sh './scripts/smoke-test.sh https://carparts-api-hml.azurewebsites.net "$TAG"'
            }
            post { always { sh 'az logout || true' } }
        }

        stage('Aprovação') {
            when { branch 'main' }
            steps {                              // sem agent: não ocupa executor esperando
                script {
                    timeout(time: 1, unit: 'DAYS') {
                        env.APROVADOR = input(
                            message: "Publicar ${env.APP}:${env.TAG} (commit ${env.COMMIT}) em produção?",
                            ok: 'Aprovar',
                            submitter: 'admin',
                            submitterParameter: 'APROVADOR')
                    }
                    // rastreabilidade exigida pelas montadoras: quem aprovou, qual commit, qual imagem
                    echo "APROVAÇÃO: ${env.APROVADOR} aprovou ${env.APP}:${env.TAG} (commit ${env.COMMIT})"
                    currentBuild.description = "Aprovado por ${env.APROVADOR} · commit ${env.COMMIT.take(7)}"
                }
            }
        }

        stage('Deploy produção') {
            when { branch 'main' }
            agent { label 'linux && azure-cli' }
            steps {
                // mesma imagem já testada em homologação: nada é recompilado
                withCredentials([usernamePassword(credentialsId: 'azure-sp',
                                                  usernameVariable: 'AZURE_CLIENT_ID',
                                                  passwordVariable: 'AZURE_CLIENT_SECRET'),
                                 string(credentialsId: 'azure-tenant-id', variable: 'AZURE_TENANT_ID')]) {
                    sh './scripts/deploy.sh producao "$TAG"'
                }
                sh './scripts/smoke-test.sh https://carparts-api-prd.azurewebsites.net "$TAG"'
            }
            post { always { sh 'az logout || true' } }
        }
    }

    post {
        success { echo "Entrega de ${env.APP}:${env.TAG} concluída." }
        failure {
            mail to: 'devops@carparts.example',
                 subject: "Falhou: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                 body: "Detalhes em ${env.BUILD_URL}"
        }
    }
}
