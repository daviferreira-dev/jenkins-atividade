# Agent Windows 11 da Carparts. Requer Java 21 no PATH.
# Uso: $env:AGENT_SECRET='...'; .\windows-agent.ps1 [-JenkinsUrl http://localhost:8080]
param([string]$JenkinsUrl = 'http://localhost:8080', [string]$Name = 'windows-agent')
if (-not $env:AGENT_SECRET) { throw 'defina $env:AGENT_SECRET (veja get-secret.sh)' }
$dir = Join-Path $env:USERPROFILE 'jenkins-agent'
New-Item -ItemType Directory -Force $dir | Out-Null
Invoke-WebRequest "$JenkinsUrl/jnlpJars/agent.jar" -OutFile "$dir\agent.jar"
java -jar "$dir\agent.jar" -url $JenkinsUrl -name $Name -secret $env:AGENT_SECRET -webSocket -workDir $dir
