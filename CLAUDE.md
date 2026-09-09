# CLAUDE.md — A.W.P.C.P. · awpcp.org

Guia operativa per a Claude Code en aquest projecte.

## El projecte

Web multilingüe per a **A.W.P.C.P.** (Around the World Pinhole Camera Project), organització sense ànim de lucre de Barcelona que coordina el **Worldwide Pinhole Photography Day** (últim diumenge d'abril). Fundada el 2020 per Alfonso de Castro i Joan Linux.

- **Producció:** `https://awpcp.org`
- **Repositori:** GitHub (`112books/awpcp` o similar)
- **Analytics:** GoatCounter (`awpcp.goatcounter.com`)

---

## Stack tècnic

| Capa | Tecnologia |
|------|-----------|
| SSG | Hugo 0.159 |
| Idiomes | CA / ES / EN (multilingüe nativa) |
| Analítica | GoatCounter (sync automàtic cada hora) |
| CI/CD | GitHub Actions (deploy + analytics) |
| Hosting | GitHub Pages (CNAME: awpcp.org) |
| Scripts | Python 3 (procesament analytics) |

---

## Entorns

| Entorn | URL |
|--------|-----|
| Local | `http://localhost:1313` |
| Producció | `https://awpcp.org` |

No hi ha staging — el flux és directe `dev → main → GitHub Pages`.

---

## Comandos habituals

```bash
# Local
hugo server

# Build optimitzat
hugo --minify

# Sync + deploy (script principal)
./sync-awpcp.sh            # menú interactiu
./sync-awpcp.sh status     # git status + últims commits
./sync-awpcp.sh sync       # commit + push → GitHub Actions deploya
./sync-awpcp.sh build      # build local
```

---

## Estructura principal

```
awpcp.org/
├── content/               # CA/ES/EN per secció (about, editions, diy, legal...)
│   └── editions/{YEAR}/   # Edicions anuals (2022, 2025, 2026...)
├── layouts/               # Templates (editions, cameras, partials, shortcodes)
├── static/admin/          # Dashboard analytics (analytics.json)
├── scripts/               # build-analytics-json.py + process-analytics.py
├── i18n/                  # Strings ca/es/en.toml
├── .github/workflows/     # deploy.yml + fetch-analytics.yml (cron cada hora)
├── sync-awpcp.sh          # Script principal de deploy
└── hugo.toml              # Config principal
```

---

## Convencions

**Branca única:** `main` — tot va directament a producció

**Commits via script:** `./sync-awpcp.sh sync` (demana missatge, fa add + commit + push)

**Analytics commits automàtics:** `chore: update analytics [skip ci]`

**Multilingüe:** carpetes `ca/`, `es/`, `en/` dins cada secció de contingut

**Secret requerit:** `GOATCOUNTER_API_KEY` a GitHub Secrets

---

## Regles operatives

- `./sync-awpcp.sh` és el punt d'entrada — no cal conèixer GitHub Actions
- El deploy és automàtic en cada push a `main` (< 2 min)
- Analytics se sincronitzen automàticament cada hora via GitHub Actions
- `public/` és ignorat al `.gitignore` (build output)
- **HTML unsafe mode actiu** al Markdown — permet HTML raw als continguts

---

## Control horari

Skill actiu: `gestor-hores` — registra automàticament el temps de treball per sessió.

- Logs a `.taques/awpcp.org/YYYY-MM-DD.md` (creat automàticament)
- Comandes: `/time-log [tasca] [hores]`, `/time-report [periode]`, `/time-config [hores] [tarifa]`
- No modificar manualment els fitxers `.taques/` — són append-only
