#!/usr/bin/env bash
# Tell Bing (and the other IndexNow engines: Yandex, Seznam, Naver, Yep) which pages changed,
# so they recrawl them within hours instead of weeks. Run after a production release is live.
#
#   tools/release/indexnow.sh                 # every URL in the live sitemap
#   tools/release/indexnow.sh /energy/ /about/   # only these paths
#
# The key is the name and content of the <key>.txt file at the site root; IndexNow fetches
# https://www.novavector.com/<key>.txt to confirm the request comes from the site owner.
# Google does not use IndexNow: for Google, submit the sitemap or request indexing in Search Console.
set -euo pipefail
cd "$(dirname "$0")/../.."

host="www.novavector.com"
key_file=$(ls | grep -E '^[0-9a-f]{32}\.txt$' | head -1)
[ -n "$key_file" ] || { echo "IndexNow key file (<32 hex>.txt) missing at the site root" >&2; exit 1; }
key="${key_file%.txt}"

live_key=$(curl -fsS "https://$host/$key_file" || true)
[ "$live_key" = "$key" ] || { echo "https://$host/$key_file does not serve the key yet; release first" >&2; exit 1; }

if [ $# -gt 0 ]; then
  urls=$(printf "https://$host%s\n" "$@")
else
  urls=$(curl -fsS "https://$host/sitemap.xml" | grep -o '<loc>[^<]*' | sed 's/<loc>//')
fi
[ -n "$urls" ] || { echo "no URLs to submit" >&2; exit 1; }

url_list=$(printf '%s\n' "$urls" | sed 's/.*/"&"/' | paste -sd, -)
body="{\"host\":\"$host\",\"key\":\"$key\",\"keyLocation\":\"https://$host/$key_file\",\"urlList\":[$url_list]}"

echo "Submitting $(printf '%s\n' "$urls" | wc -l) URL(s) to IndexNow"
code=$(curl -sS -o /dev/stderr -w '%{http_code}' -X POST "https://api.indexnow.org/indexnow" \
  -H 'Content-Type: application/json; charset=utf-8' --data "$body")
echo "HTTP $code (200 or 202 = accepted)"
[ "$code" = 200 ] || [ "$code" = 202 ]
