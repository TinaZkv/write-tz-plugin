<#
  Проверка JSON-манифестов плагина перед публикацией:
    - нет UTF-8 BOM в начале файла (BOM ломает парсер /plugin в Claude Code);
    - файл — валидный JSON.

  Запуск:  powershell -ExecutionPolicy Bypass -File .\scripts\check-json.ps1
  Код возврата: 0 — всё чисто, 1 — есть проблема.
#>

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$files = @(
  (Join-Path $root ".claude-plugin\marketplace.json"),
  (Join-Path $root "plugins\write-tz\.claude-plugin\plugin.json")
)

$bad = $false
foreach ($f in $files) {
  $name = Split-Path $f -Leaf
  if (-not (Test-Path $f)) { Write-Host "[ПРОПУСК] нет файла: $f" -ForegroundColor Yellow; continue }

  $b = [System.IO.File]::ReadAllBytes($f)
  $hasBom = ($b.Length -ge 3 -and $b[0] -eq 0xEF -and $b[1] -eq 0xBB -and $b[2] -eq 0xBF)

  $jsonOk = $true
  try { [System.IO.File]::ReadAllText($f) | ConvertFrom-Json | Out-Null } catch { $jsonOk = $false }

  if ($hasBom)        { Write-Host "[FAIL] $name — начинается с UTF-8 BOM" -ForegroundColor Red; $bad = $true }
  if (-not $jsonOk)   { Write-Host "[FAIL] $name — невалидный JSON" -ForegroundColor Red; $bad = $true }
  if (-not $hasBom -and $jsonOk) { Write-Host "[OK]   $name" -ForegroundColor Green }
}

if ($bad) {
  Write-Host "Проверка НЕ пройдена. Пересохрани JSON как 'UTF-8 без BOM'." -ForegroundColor Red
  Write-Host "Чем починить (PowerShell): " -ForegroundColor Yellow
  Write-Host '  $u=New-Object System.Text.UTF8Encoding($false); [IO.File]::WriteAllText($p,[IO.File]::ReadAllText($p),$u)' -ForegroundColor Yellow
  exit 1
}
Write-Host "Все JSON чистые: без BOM и валидны." -ForegroundColor Green
exit 0

