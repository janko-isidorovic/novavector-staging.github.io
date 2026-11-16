#!/usr/bin/env bash
# Switch a release checkout of the site from staging to production settings.
# Run on the branch that will be pushed to github.com/novavector/novavector.github.io,
# never on the staging line (new-design-v4): staging must stay non-indexed and on its own domain.
set -euo pipefail
cd "$(dirname "$0")/../.."

config=_config.yml
grep -q '^noindex:' "$config" || { echo "noindex key missing in $config" >&2; exit 1; }

sed -i -E \
  -e 's#^baseurl:.*#baseurl: ""#' \
  -e 's#^url:.*#url: "https://www.novavector.com"#' \
  -e 's#^noindex:.*#noindex: false#' \
  "$config"
printf 'www.novavector.com\n' > CNAME

echo "Production settings applied:"
grep -E '^(baseurl|url|noindex):' "$config"
echo "CNAME: $(cat CNAME)"
