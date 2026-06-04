<#
  Обновление навыка write-tz из общего git-репозитория.
  Для окружений БЕЗ команды /plugin (десктоп-приложение / Cowork).

  Делает две вещи:
    1. git pull — подтягивает свежую версию навыка из репозитория;
    2. копирует навык в личный каталог ~/.claude/skills/write-tz (перезапись).

  Как запустить:
    ПКМ по файлу → «Запустить с помощью PowerShell»
    либо:  powershell -ExecutionPolicy Bypass -File .\scripts\update-write-tz.ps1
  После — открой НОВУЮ сессию Claude Code.
#>

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$src = Join-Path $repoRoot "plugins\write-tz\skills\write-tz"
$dst = Join-Path $env:USERPROFILE ".claude\skills\write-tz"

# 1. Подтянуть свежую версию из git (если это git-репозиторий)
if (Test-Path (Join-Path $repoRoot ".git")) {
    Write-Host "git pull..." -ForegroundColor Cyan
    Push-Location $repoRoot
    try { git pull } finally { Pop-Location }
} else {
    Write-Host "Это не git-репозиторий — пропускаю git pull, копирую то, что есть локально." -ForegroundColor Yellow
}

# 2. Показать версию навыка из манифеста
$pluginJson = Join-Path $repoRoot "plugins\write-tz\.claude-plugin\plugin.json"
if (Test-Path $pluginJson) {
    $ver = (Get-Content $pluginJson -Raw -Encoding utf8 | ConvertFrom-Json).version
    Write-Host "Версия навыка в репозитории: $ver" -ForegroundColor Cyan
}

# 3. Перезаписать личную копию
if (-not (Test-Path (Join-Path $src "SKILL.md"))) {
    Write-Host "Не найден SKILL.md по пути: $src" -ForegroundColor Red
    exit 1
}
New-Item -ItemType Directory -Force -Path $dst | Out-Null
# чистим старое содержимое, чтобы удалённые в новой версии файлы не оставались
Get-ChildItem $dst -Recurse -Force | Remove-Item -Recurse -Force
Copy-Item (Join-Path $src "*") -Destination $dst -Recurse -Force

Write-Host "Навык write-tz обновлён в: $dst" -ForegroundColor Green
Write-Host "Открой НОВУЮ сессию Claude Code, чтобы подхватить изменения." -ForegroundColor Yellow

