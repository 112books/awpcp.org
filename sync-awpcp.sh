#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════
#  awpcp.org — Script de sync + deploy
#  Ús: ./sync-awpcp.sh [status|sync|build]
# ═══════════════════════════════════════════════════════════════════════

set -euo pipefail

REMOTE="origin"
BRANCH="main"
DIR="$(cd "$(dirname "$0")" && pwd)"

RED='\033[0;31m'; GRN='\033[0;32m'
YLW='\033[1;33m'; BLU='\033[0;34m'
DIM='\033[2m'; RST='\033[0m'

print() { echo -e "${BLU}▶${RST} $1"; }
ok()    { echo -e "${GRN}✓${RST} $1"; }
err()   { echo -e "${RED}✗${RST} $1" >&2; }
dim()   { echo -e "${DIM}  $1${RST}"; }

cd "$DIR"

status() {
  echo ""
  print "Branca: ${YLW}$(git branch --show-current)${RST}"
  echo ""
  git status --short
  echo ""
  dim "Últims commits:"
  git log --oneline -5
  echo ""
}

sync() {
  print "Sincronitzant..."
  git add -A

  if git diff --cached --quiet; then
    ok "Res a sincronitzar"
    return
  fi

  git status --short
  echo ""
  read -r -p "  Missatge del commit: " msg
  [[ -z "$msg" ]] && msg="sync: $(date '+%Y-%m-%d %H:%M')"
  git commit -m "$msg"

  print "Pujant a ${REMOTE}/${BRANCH}..."
  git push "$REMOTE" "$BRANCH"
  ok "Sync complet — el GitHub Action desplegarà automàticament"
  dim "Segueix: https://github.com/112books/awpcp.org/actions"
}

build_local() {
  print "Build local..."
  cd "$DIR"
  hugo --minify || exit 1
  ok "Build correcte → ${DIR}/public/"
}

case "${1:-menu}" in
  status) status; exit 0 ;;
  sync)   sync;   exit 0 ;;
  build)  build_local; exit 0 ;;
esac

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " awpcp.org — Sync & Deploy"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo " 1) Status"
echo " 2) Sync (commit + push → GH Actions deploy)"
echo " 3) Build local (hugo --minify)"
echo " 0) Sortir"
echo ""
read -r -p "Opció: " opt
echo ""

case $opt in
  1) status ;;
  2) sync ;;
  3) build_local ;;
  0) exit 0 ;;
  *) err "Opció no vàlida"; exit 1 ;;
esac
