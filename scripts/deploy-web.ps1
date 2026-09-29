$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
Push-Location $projectRoot
try {
  $apiUrl = (& gcloud.cmd run services describe longyuan-api --project=longyuan-wellness --region=europe-west2 --format='value(status.url)').Trim()
  if ($LASTEXITCODE -ne 0 -or $apiUrl -notmatch '^https://') {
    throw 'Unable to resolve deployed API URL.'
  }
  & flutter build web "--dart-define=API_BASE_URL=$apiUrl"
  if ($LASTEXITCODE -ne 0) { throw 'Flutter build failed.' }
  & firebase.cmd deploy --only hosting --project longyuan-wellness --non-interactive
  if ($LASTEXITCODE -ne 0) { throw 'Web deployment failed.' }
} finally { Pop-Location }
