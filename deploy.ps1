# Deploy rootmc-web to Cloudflare Pages (project: rootmc-web, domain: rootmc.net)
$ErrorActionPreference = "Stop"

function Import-DotEnvFile([string]$LiteralPath) {
    if (-not (Test-Path -LiteralPath $LiteralPath)) { return }
    Get-Content -LiteralPath $LiteralPath | ForEach-Object {
        $line = $_.Trim()
        if (-not $line -or $line.StartsWith("#")) { return }
        $p = $line.IndexOf("=")
        if ($p -gt 0) {
            $k = $line.Substring(0, $p).Trim()
            $v = $line.Substring($p + 1).Trim()
            if ($k -and $v) { Set-Item -Path "Env:$k" -Value $v }
        }
    }
}

Set-Location $PSScriptRoot
Import-DotEnvFile (Join-Path $PSScriptRoot ".env")

if (-not $env:CLOUDFLARE_API_TOKEN -or $env:CLOUDFLARE_API_TOKEN.Length -lt 20) {
    throw "Set CLOUDFLARE_API_TOKEN in .env (see .env.example)"
}
if (-not $env:CLOUDFLARE_ACCOUNT_ID) {
    throw "Set CLOUDFLARE_ACCOUNT_ID in .env"
}

node scripts/build.mjs

$project = "rootmc-web"
Write-Host "Deploying Pages project $project ..."

$projList = (npx wrangler pages project list 2>&1) | Out-String
if ($projList -notmatch $project) {
    Write-Host "Creating Pages project $project ..."
    npx wrangler pages project create $project --production-branch main 2>&1 | Out-Host
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

npx wrangler pages deploy build `
    --project-name $project `
    --branch main `
    --commit-dirty=true 2>&1 | Out-Host
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "Done. Production: https://rootmc.net"
