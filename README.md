# product-tz — маркетплейс с навыком написания ТЗ

Этот репозиторий — **Claude Code маркетплейс** с одним плагином **`write-tz`**
(навык написания технических заданий по единому стандарту). Делитесь ссылкой на
репозиторий — коллеги ставят плагин себе одной командой и получают обновления
из этого репозитория.

## Как поделиться (автор — один раз)

1. Залить эту папку в git-репозиторий (GitHub / GitLab / внутренний):
   ```
   cd write-tz-plugin
   git init && git add . && git commit -m "write-tz plugin v1.0.0"
   git remote add origin <URL-репозитория>
   git push -u origin main
   ```
2. Дать коллегам ссылку на репозиторий.

(Без git тоже можно: заархивировать папку и передать — установка ниже работает и
с локальным путём.)

## Как установить (каждый продакт)

Выбрать путь по своему окружению.

### Вариант 1 — Claude Code в терминале (CLI), где доступна команда `/plugin`
```
/plugin marketplace add <URL-репозитория>      # или локальный путь к этой папке
/plugin install write-tz@product-tz
```
После установки навык доступен во всех проектах. Проверить: он появится в списке
навыков и сработает на «напиши ТЗ».

### Вариант 2 — десктоп-приложение / Cowork (команды `/plugin` нет)
Если в окружении пишет `/plugin isn't available in this environment` — установить
навык копированием папки в личный каталог навыков:

1. Взять из этого репозитория папку
   `plugins/write-tz/skills/write-tz` (в ней `SKILL.md`,
   `mockup-explanation-template.md`, `examples/`).
2. Скопировать её целиком в свой каталог навыков, чтобы получилось:
   ```
   C:\Users\<Имя>\.claude\skills\write-tz\SKILL.md
   C:\Users\<Имя>\.claude\skills\write-tz\mockup-explanation-template.md
   C:\Users\<Имя>\.claude\skills\write-tz\examples\...
   ```
   (macOS/Linux: `~/.claude/skills/write-tz/…`.)
3. Открыть **новую** сессию — текущая список навыков не перечитывает. Навык
   `write-tz` появится в списке и сработает на «напиши ТЗ».

Проще — готовыми скриптами из папки `scripts/` (Windows, PowerShell):
- **Установка:** `scripts\install-write-tz.ps1` — ПКМ → «Запустить с помощью
  PowerShell», либо
  `powershell -ExecutionPolicy Bypass -File .\scripts\install-write-tz.ps1`.
- **Обновление:** `scripts\update-write-tz.ps1` — делает `git pull` и
  перекладывает свежую версию навыка. Запускать при выходе новой версии.

После любого из них — открыть **новую** сессию Claude Code.

> Минус варианта 2: обновления не прилетают сами — при новой версии навыка нужно
> запустить `update-write-tz.ps1` (или скопировать папку заново). В варианте 1
> хватает `/plugin marketplace update`.

## Что нужно, чтобы навык реально работал

Плагин даёт только **форму** ТЗ. Содержание — за проектом. В рабочей папке фичи
завести:
- `CLAUDE.md` — терминология и стоп-слова продукта, матрица ролей, **тип трекера
  и формат вывода** (Jira Server → wiki markup; Jira Cloud → markdown/ADF),
  границы скоупа;
- `docs/` — бизнес-контекст и смежные закрытые тикеты (экспортом, не ссылкой);
- макеты — скриншоты с комментариями в чат или файлы-пояснения рядом.

Образец проектного `CLAUDE.md` (`CLAUDE.md.ba-example`) и шаблон пояснения к
макету — в составе навыка (`plugins/write-tz/skills/write-tz/`).

## Обновление навыка

Правите `plugins/write-tz/skills/write-tz/SKILL.md`, поднимаете `version` в
`plugins/write-tz/.claude-plugin/plugin.json` и в `.claude-plugin/marketplace.json`,
пушите. Коллеги обновляются: `/plugin marketplace update product-tz`.

## Замечание про examples

В навыке лежит реальный эталон формы B — `[#BA-7479]…pdf` (внутренний тикет BA).
При шеринге за пределы команды его можно удалить из
`plugins/write-tz/skills/write-tz/examples/` — на работу навыка это не влияет,
останется эталон формы A.

## Структура репозитория

```
write-tz-plugin/
├── .claude-plugin/
│   └── marketplace.json            # манифест маркетплейса (перечень плагинов)
├── plugins/
│   └── write-tz/
│       ├── .claude-plugin/
│       │   └── plugin.json          # манифест плагина
│       ├── README.md
│       └── skills/
│           └── write-tz/
│               ├── SKILL.md                          # сам навык
│               ├── CLAUDE.md.ba-example              # образец проектного CLAUDE.md (база знаний)
│               ├── mockup-explanation-template.md    # шаблон пояснения к макету
│               └── examples/                         # эталоны форм A и B
└── README.md                        # этот файл
```
