<#
  Первичная установка навыка write-tz в личный каталог навыков Claude Code.
  Для окружений БЕЗ команды /plugin (десктоп-приложение / Cowork).

  Как запустить:
    1. Склонируй или скачай этот репозиторий.
    2. ПКМ по файлу → «Запустить с помощью PowerShell»
       либо в PowerShell:  powershell -ExecutionPolicy Bypass -File .\scripts\install-write-tz.ps1
    3. Открой НОВУЮ сессию Claude Code — навык появится в списке.
#>

$ErrorActionPreference = "Stop"

# Папка навыка внутри репозитория (относительно расположения этого скрипта)
$repoRoot = Split-Path -Parent $PSScriptRoot
$src = Join-Path $repoRoot "plugins\write-tz\skills\write-tz"
$dst = Join-Path $env:USERPROFILE ".claude\skills\write-tz"

if (-not (Test-Path (Join-Path $src "SKILL.md"))) {
    Write-Host "Не найден SKILL.md по пути: $src" -ForegroundColor Red
    Write-Host "Запускай скрипт из папки склонированного репозитория write-tz-plugin." -ForegroundColor Red
    exit 1
}

New-Item -ItemType Directory -Force -Path $dst | Out-Null
Copy-Item (Join-Path $src "*") -Destination $dst -Recurse -Force

Write-Host "Навык write-tz установлен в: $dst" -ForegroundColor Green
Write-Host "Открой НОВУЮ сессию Claude Code — список навыков перечитывается только при старте." -ForegroundColor Yellow

