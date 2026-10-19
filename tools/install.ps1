param([Parameter(Position=0)][string]$GarrysModPath)

$ErrorActionPreference = "Stop"
$source = Join-Path (Split-Path -Parent $PSScriptRoot) "addon/adamovian_metro"
if (-not (Test-Path -LiteralPath $source -PathType Container)) { throw "Addon source not found: $source" }
if ([string]::IsNullOrWhiteSpace($GarrysModPath)) { $GarrysModPath = Join-Path ${env:ProgramFiles(x86)} "Steam/steamapps/common/GarrysMod/garrysmod" }
if (-not (Test-Path -LiteralPath $GarrysModPath -PathType Container)) { throw "Garrys Mod folder not found: $GarrysModPath" }
$dest = Join-Path $GarrysModPath "addons/adamovian_metro"
New-Item -ItemType Directory -Force -Path $dest | Out-Null
Copy-Item -Path (Join-Path $source "*") -Destination $dest -Recurse -Force
Write-Host "Adamovian Metro installed to: $dest"
