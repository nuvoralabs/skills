#!/usr/bin/env bash
#
# Fetch Nuvora Nexus Sentinel documentation as clean Markdown.
#
# Every page on sentinel.nuvoralabs.com is available as Markdown by appending
# `.md` to its path. This wraps that with a 6-hour cache so repeated reads in one
# session cost nothing.
#
# Usage:
#   fetch-docs.sh get <path|url> [...]   Fetch one or more pages
#   fetch-docs.sh search <term> [...]    List index entries matching all terms
#   fetch-docs.sh security <recipe>      Fetch a security recipe by slug
#   fetch-docs.sh api <package>          Fetch a generated API reference page
#   fetch-docs.sh index                  The full page index (llms.txt)
#   fetch-docs.sh full                   The entire corpus (~300 KB — last resort)
#   fetch-docs.sh clean                  Drop the cache
#
# Paths are forgiving: `docs/authorization`, `/docs/authorization/`,
# `docs/authorization.md` and the full URL all resolve to the same page.
#
# Examples:
#   fetch-docs.sh get docs/authorization articles/passkeys
#   fetch-docs.sh search refresh token rotation
#   fetch-docs.sh security credential-stuffing
#   fetch-docs.sh api Nuvora.Nexus.Sentinel.OidcServer

set -euo pipefail

BASE_URL="https://sentinel.nuvoralabs.com"
CACHE_DIR="${TMPDIR:-/tmp}/nuvora-sentinel-docs"
CACHE_TTL_MINUTES=360

# Print the header comment block as help text.
usage() { awk 'NR > 1 { if ($0 !~ /^#/) exit; sub(/^# ?/, ""); print }' "$0"; }

# Turn anything page-shaped into an absolute .md URL.
resolve_url() {
  local p="$1"
  case "$p" in
    http://*|https://*) ;;
    /*) p="${BASE_URL}${p}" ;;
    *)  p="${BASE_URL}/${p}" ;;
  esac
  p="${p%/}"          # trailing slash
  case "$p" in
    *.md|*.txt|*.xml|*.json) printf '%s\n' "$p" ;;   # already a concrete file
    *)                       printf '%s.md\n' "$p" ;;
  esac
}

fetch() {
  local url cache_key cache_file
  url="$(resolve_url "$1")"
  cache_key="$(printf '%s' "$url" | tr -c 'A-Za-z0-9' '_')"
  cache_file="${CACHE_DIR}/${cache_key}"

  mkdir -p "$CACHE_DIR"

  if [ -f "$cache_file" ] && [ -z "$(find "$cache_file" -mmin "+${CACHE_TTL_MINUTES}" 2>/dev/null)" ]; then
    cat "$cache_file"
    return 0
  fi

  local tmp status
  tmp="$(mktemp "${CACHE_DIR}/.dl.XXXXXX")"
  status="$(curl -sL --max-time 45 -w '%{http_code}' -o "$tmp" "$url" || echo 000)"

  if [ "$status" != "200" ]; then
    rm -f "$tmp"
    echo "error: $url returned HTTP $status" >&2
    echo "hint: run '$(basename "$0") index' to see the real page paths." >&2
    return 1
  fi

  mv "$tmp" "$cache_file"
  cat "$cache_file"
}

cmd="${1:-}"
[ $# -gt 0 ] && shift || true

case "$cmd" in
  get)
    [ $# -gt 0 ] || { echo "error: get needs at least one page path" >&2; exit 2; }
    rc=0
    for page in "$@"; do
      printf '\n===== %s =====\n\n' "$(resolve_url "$page")"
      fetch "$page" || rc=1
    done
    exit $rc
    ;;

  security)
    [ $# -eq 1 ] || { echo "error: security needs exactly one recipe slug" >&2; exit 2; }
    fetch "security/${1#security/}"
    ;;

  api)
    [ $# -eq 1 ] || { echo "error: api needs exactly one package name" >&2; exit 2; }
    # Nuvora.Nexus.Sentinel.OidcServer -> api/nuvora-nexus-sentinel-oidcserver
    slug="$(printf '%s' "$1" | tr '.' '-' | tr '[:upper:]' '[:lower:]')"
    fetch "api/${slug}"
    ;;

  index)
    fetch "llms.txt"
    ;;

  full)
    echo "warning: llms-full.txt is ~300 KB; prefer 'get' on specific pages." >&2
    fetch "llms-full.txt"
    ;;

  search)
    [ $# -gt 0 ] || { echo "error: search needs at least one term" >&2; exit 2; }
    index="$(fetch "llms.txt")"
    for term in "$@"; do
      index="$(printf '%s\n' "$index" | grep -i -- "$term" || true)"
    done
    if [ -z "$index" ]; then
      echo "No index entry matched: $*" >&2
      echo "hint: try fewer or broader terms, or run '$(basename "$0") index'." >&2
      exit 1
    fi
    printf '%s\n' "$index"
    ;;

  clean)
    rm -rf "$CACHE_DIR"
    echo "cache cleared: $CACHE_DIR"
    ;;

  ""|-h|--help|help)
    usage
    ;;

  *)
    echo "error: unknown command '$cmd'" >&2
    echo >&2
    usage >&2
    exit 2
    ;;
esac
