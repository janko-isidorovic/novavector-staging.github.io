#!/usr/bin/env bash
# Switch a release checkout of the site from staging to production settings.
# Run on the branch that will be pushed to github.com/novavector/novavector.github.io,
# never on the staging line (new-design-v4): staging must stay non-indexed and on its own domain.
set -euo pipefail
# GA4 stream "Nova Vector - GA4" (https://www.novavector.com). Production only: staging keeps it empty.
ga_id="G-543RQBFBY7"
cd "$(dirname "$0")/../.."

config=_config.yml
for key in noindex google_analytics; do
  grep -q "^$key:" "$config" || { echo "$key key missing in $config" >&2; exit 1; }
done

sed -i -E \
  -e 's#^baseurl:.*#baseurl: ""#' \
  -e 's#^url:.*#url: "https://www.novavector.com"#' \
  -e 's#^noindex:.*#noindex: false#' \
  -e "s#^google_analytics:.*#google_analytics: \"$ga_id\"#" \
  "$config"
printf 'www.novavector.com\n' > CNAME

echo "Production settings applied:"
grep -E '^(baseurl|url|noindex|google_analytics):' "$config"
echo "CNAME: $(cat CNAME)"
