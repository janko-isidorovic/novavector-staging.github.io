# Production release checklist

Staging (`janko-isidorovic/novavector-staging.github.io`, branch `v4.1`) is never indexed:
`_config.yml` has `noindex: true`, which adds `noindex, nofollow` to every page and makes
`robots.txt` disallow everything. Pages themselves carry no indexing flags, so this one switch
decides for the whole site. Hidden pages use `published: false`.

## Before the push to production

1. Update the release branch. The production repository has no history in common with staging, so
   the release branch sits on top of production `v4.1` and takes the staging files as a new commit.
   In a checkout of the production repository with staging added as remote `staging`:

   ```sh
   git fetch origin && git fetch staging
   git switch -c release origin/v4.1     # or switch to the existing release branch and pull
   git rm -rq . && git checkout staging/v4.1 -- .
   ```

2. Run `tools/release/prepare-production.sh`. It sets `url: "https://www.novavector.com"`,
   `baseurl: ""`, `noindex: false`, `google_analytics: "G-543RQBFBY7"` (GA4 stream
   "Nova Vector - GA4") and writes `CNAME` (`www.novavector.com`). Staging keeps
   `google_analytics` empty so test visits are not counted.
3. Build locally and check:
   - `robots.txt` allows crawling and names `https://www.novavector.com/sitemap.xml`;
   - pages have no `noindex` meta tag;
   - canonical links, `og:url` and structured data use `https://www.novavector.com`;
   - `sitemap.xml` lists the new pages and none of the hidden ones;
   - old URLs redirect (see below);
   - pages carry the consent loader with `var GA = "G-543RQBFBY7"` and the cookie banner
     (`id="nv-cookie"`); build with `JEKYLL_ENV=production`, as GitHub Pages does (`jekyll serve`
     leaves the ID out);
   - no page contacts a third party before consent (Google Analytics loads only after Accept in the
     cookie banner; fonts are self-hosted; Calendly loads only when "Discuss Your Use Case" is clicked);
   - `/privacy-policy/` names the right company (`legal_name`) and GA4 retention
     (`google_analytics_retention`, must match GA4 Admin > Data retention). Any new third-party service,
     cookie or form needs a section in `pages/privacy-policy.md` and a new `privacy_policy_updated` date.
4. Commit, then push the release branch to `v4.1` of `github.com/novavector/novavector.github.io`:
   `git push origin release:v4.1`. GitHub Pages publishes www.novavector.com from `v4.1` (since
   2026-11-22; `v4.0` is the previous release). If Pages is switched to another branch, update this line.
   Never push to `master`: it keeps the previous site (before the v4 design) as the fallback. The push
   is a fast-forward; it never needs `--force`.

## Old URLs

The live site's `/pages/...` URLs are kept as redirects (`jekyll-redirect-from`, `redirect_from:`
in the front matter of the target page):

| Old URL | New page |
|---|---|
| `/pages/products`, `/pages/nova-vector-platform`, `/pages/paas` | `/industrial-iot-platform/` |
| `/pages/nova-edge-computing` | `/edge-computing-platform/` |
| `/pages/smart-industry`, `/pages/solutions` | `/manufacturing/` |
| `/pages/smart-building`, `/pages/smart-providers` | `/industrial-infrastructure/` |
| `/pages/services`, `/pages/professional-services`, `/pages/services-details` | `/professional-services/` |
| `/pages/support` | `/support/` |
| `/pages/training`, `/pages/tutorials` | `/training/` |
| `/pages/contact` | `/contact/` |
| `/pages/about` | `/about/` |
| `/pages/smart-agriculture` | `/smart-agriculture/` |
| `/pages/index-2`, `/pages/index-3`, `/pages/portfolio`, `/pages/portfolio-details`, `/pages/smart-retail`, `/pages/blog/` | `/` |

Still on the old design, without a new page: `/pages/smart-city`, `/pages/education`.

## After the push

- Open a few old URLs on www.novavector.com and confirm they land on the new pages.
- Run `tools/release/indexnow.sh` (every sitemap URL) or `tools/release/indexnow.sh /path/ ...`
  (only the changed pages). It tells Bing and the other IndexNow engines to recrawl; it needs the
  `<key>.txt` file at the site root to be live.
- Google does not use IndexNow: in Google Search Console, resubmit `https://www.novavector.com/sitemap.xml`
  and use URL Inspection > Request indexing for the most important changed pages.
