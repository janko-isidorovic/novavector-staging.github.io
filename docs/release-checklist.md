# Production release checklist

Staging (`janko-isidorovic/novavector-staging.github.io`, branch `new-design-v4`) is never indexed:
`_config.yml` has `noindex: true`, which adds `noindex, nofollow` to every page and makes
`robots.txt` disallow everything. Pages themselves carry no indexing flags, so this one switch
decides for the whole site. Hidden pages use `published: false`.

## Before the push to production

1. Create the release branch from `new-design-v4`.
2. Run `tools/release/prepare-production.sh`. It sets `url: "https://www.novavector.com"`,
   `baseurl: ""`, `noindex: false` and writes `CNAME` (`www.novavector.com`).
3. Build locally and check:
   - `robots.txt` allows crawling and names `https://www.novavector.com/sitemap.xml`;
   - pages have no `noindex` meta tag;
   - canonical links, `og:url` and structured data use `https://www.novavector.com`;
   - `sitemap.xml` lists the new pages and none of the hidden ones;
   - old URLs redirect (see below).
4. Push the release branch to `master` of `github.com/novavector/novavector.github.io`.

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
- Submit `https://www.novavector.com/sitemap.xml` in Google Search Console.
