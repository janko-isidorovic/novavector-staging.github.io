---
layout: legal
permalink: /privacy-policy/
title: Privacy Policy
title_accent: Policy
eyebrow: Legal
description: "How Nova Vector handles personal data on www.novavector.com: cookies, Google Analytics by consent, and your rights under the GDPR."
summary: How we process personal data on this website, which cookies we use, and the rights you have under the GDPR.
---

{% assign updated = site.privacy_policy_updated | date: "%-d %B %Y" %}
{% assign ga_suffix = site.google_analytics | remove: "G-" %}
{% if ga_suffix == "" %}{% assign ga_suffix = "&lt;ID&gt;" %}{% endif %}

<p class="nv-legal__updated">Last updated: {{ updated }}</p>

This policy explains how {{ site.legal_name }} ("we", "us") processes personal data when you visit
**www.novavector.com**. It follows the EU General Data Protection Regulation
(Regulation (EU) 2016/679, "GDPR") and the Law on Personal Data Protection of the Republic of Serbia
(Official Gazette of the RS, No. 87/2018).

This policy covers the website only. Business enquiries you send us by email or phone are not part of
the website. Personal data in Nova Vector platform installations that we run or support for customers is
processed under the contract with each customer.

## 1. Who is responsible

The controller of your personal data is:

{{ site.legal_name }}<br>
Generala Ljubomira Milica 10<br>
11041 Belgrade, Serbia<br>
Email: [info@novavector.com](mailto:info@novavector.com)<br>
Phone: +381 64 1151 256

Send any question about this policy, or any request to exercise your rights, to
[info@novavector.com](mailto:info@novavector.com) with "Privacy" in the subject line.

## 2. Summary

- **{{ site.legal_name }} does not save personal data about visitors to this website.** The website
  has no forms, user accounts or database. Data about a visit is stored only by these services:
  - **Google**, only if you accept analytics cookies. The data is pseudonymous and does not identify you
    by name (section 3.2).
  - **Calendly**, only if you book a meeting through the scheduler (section 3.3).
  - **GitHub**, which hosts the website, in its technical access logs (section 3.1).
- You can use the whole website without accepting cookies.
- We use **Google Analytics** only if you click **Accept** in the cookie banner. You can withdraw that
  consent at any time with <button type="button" class="nv-cookie-link nv-legal__inline-button" data-cookie-settings>Cookie settings</button>,
  which is also at the bottom of every page.
- We do not use advertising cookies, we do not sell personal data, and we do not make decisions about you
  by automated means.
- Fonts, images and videos are served from our own site. No other third-party service is contacted when
  you open a page. The only exception is Calendly, and only when you open the meeting scheduler yourself.

## 3. What we process and why

### 3.1 Visiting the website (hosting)

The website is hosted on **GitHub Pages**, a service of GitHub, Inc., 88 Colin P. Kelly Jr. Street,
San Francisco, CA 94107, USA. When you open a page, your browser sends technical data that every web
server receives: your IP address, the date and time, the page requested, the referring page, and your
browser and operating system. GitHub logs visitors' IP addresses for security purposes.

- **Purpose:** to deliver the website and keep it secure.
- **Legal basis:** our legitimate interest in running a secure website (Art. 6(1)(f) GDPR).
- **Retention:** as set out in the [GitHub Privacy Statement](https://docs.github.com/en/site-policy/privacy-policies/github-general-privacy-statement).
  We have no access to these logs.

### 3.2 Google Analytics (only with your consent)

If you click **Accept** in the cookie banner, we use **Google Analytics 4** to understand how visitors
use the website: which pages are read, how visitors find us, and where pages could be clearer. If you
click **Reject**, or make no choice, Google Analytics is not loaded at all and no Google Analytics
cookies are set.

The service is provided by Google Ireland Limited, Gordon House, Barrow Street, Dublin 4, Ireland
("Google"), which processes the data on our behalf under data processing terms agreed with us.

**Data collected:** pseudonymous identifiers stored in cookies; the pages you view and when; how you
reached the site (for example a search engine or a link); interactions such as scrolling, clicks on
links to other websites, video plays and file downloads; device type, operating system, browser, screen
size and language; and your approximate location (country, region, city). Google Analytics 4 uses your
IP address only to derive the approximate location and does not log or store it.

**What we do not do:** we have not enabled Google Signals or advertising features. Consent for
advertising storage and personalisation is always set to "denied". We do not combine analytics data
with other data about you and cannot identify you from it.

- **Purpose:** statistical analysis of website use to improve the website and its content.
- **Legal basis:** your consent (Art. 6(1)(a) GDPR). Storing and reading the cookies on your device is
  also based on your consent.
- **Retention:** event data is deleted automatically after {{ site.google_analytics_retention }}.
  The cookies expire after 2 years unless you delete them or withdraw consent earlier.
- **Withdrawing consent:** open <button type="button" class="nv-cookie-link nv-legal__inline-button" data-cookie-settings>Cookie settings</button>
  and click **Reject**. Google Analytics then stops on this site and its cookies are deleted. Withdrawal
  does not affect processing carried out before it.
- **Transfer outside the EU:** Google may process the data in the USA. Google LLC is certified under
  the EU-U.S. Data Privacy Framework, for which the European Commission adopted an adequacy decision
  on 10 July 2023.
- **More information:** [Google Privacy Policy](https://policies.google.com/privacy) and
  [How Google uses information from sites that use its services](https://policies.google.com/technologies/partner-sites).

### 3.3 Scheduling a meeting with Calendly

The **Discuss Your Use Case** button on the homepage opens a scheduler from Calendly LLC, 115 E Main St,
Ste A1B, Buford, GA 30518, USA. Nothing is loaded from Calendly until you click that button. When you
click it, your browser connects to Calendly, and Calendly processes the data you enter (name, email
address, your answers and the time you choose) and may set its own cookies.

- **Purpose:** to arrange a meeting you asked for.
- **Legal basis:** steps taken at your request before entering into a contract (Art. 6(1)(b) GDPR).
- **Retention:** until the meeting and any follow-up are settled. Calendly's own retention is described
  in the [Calendly Privacy Notice](https://calendly.com/legal/privacy-notice).
- **Transfer outside the EU:** Calendly processes data in the USA and relies on the EU-U.S. Data Privacy
  Framework and standard contractual clauses.

If you prefer not to use Calendly, email us at [info@novavector.com](mailto:info@novavector.com).

### 3.4 Links to LinkedIn and other websites

The website contains ordinary links, for example to our LinkedIn page. LinkedIn receives no data from
this website until you follow such a link. From then on, the privacy policy of that website applies.

## 4. Cookies and similar technologies

| Name | Provider | Purpose | Duration | When it is stored |
|---|---|---|---|---|
| `nv-cookie-consent` (browser local storage) | {{ site.legal_name }} | Remembers your cookie choice so the banner is not shown on every page. It never leaves your browser. | 12 months | After you click Accept or Reject |
| `_ga` | Google | Distinguishes visitors for Google Analytics | 2 years | Only after you click Accept |
| `_ga_{{ ga_suffix }}` | Google | Keeps the Google Analytics session state | 2 years | Only after you click Accept |
| Calendly cookies | Calendly | Run the meeting scheduler | See Calendly's notice | Only when you open the scheduler |
{: .nv-legal__table}

The consent record is strictly necessary to respect your choice and needs no consent. You can also
delete cookies and local storage in your browser settings at any time; the banner will then ask again.

## 5. Who receives your data

{{ site.legal_name }} does not store data about your visit. It is processed only by the providers named
in section 3: GitHub, Google and Calendly. We do not sell personal data or pass it on for advertising.

## 6. Your rights

Under the GDPR and the Serbian Law on Personal Data Protection you have the right to:

- **access** the personal data we hold about you (Art. 15 GDPR);
- have inaccurate data **corrected** (Art. 16);
- have your data **erased** (Art. 17);
- **restrict** processing (Art. 18);
- receive your data in a portable format (**data portability**, Art. 20);
- **object** at any time to processing based on our legitimate interests (Art. 21);
- **withdraw your consent** at any time, with effect for the future (Art. 7(3)), using
  <button type="button" class="nv-cookie-link nv-legal__inline-button" data-cookie-settings>Cookie settings</button>.

To exercise a right, email [info@novavector.com](mailto:info@novavector.com). We answer within one
month. We may ask you to confirm your identity first.

**How we handle a request.** {{ site.legal_name }} does not store data about your visit, so in most
cases there is nothing for us to give you or delete. A meeting booked through the scheduler is stored
by Calendly; we can find and delete it by the email address you used. Google Analytics data is
pseudonymous and we cannot link it to you by name. Under Art. 11 GDPR we cannot answer access, correction or erasure requests for it unless
you send us your Google Analytics client ID (the value of the `_ga` cookie in your browser). You can
also delete it yourself: <button type="button" class="nv-cookie-link nv-legal__inline-button" data-cookie-settings>Cookie settings</button>
→ **Reject** removes the cookies, and Google deletes all analytics data after
{{ site.google_analytics_retention }}. Hosting logs are held by GitHub; we have no access to them.

You also have the right to lodge a complaint with a supervisory authority. In Serbia this is the
**Commissioner for Information of Public Importance and Personal Data Protection**, Bulevar kralja
Aleksandra 15, 11000 Belgrade, [www.poverenik.rs](https://www.poverenik.rs). If you live or work in the
EU or EEA, you can also contact the data protection authority of your country.

## 7. Do you have to provide data?

No. You can use the website without providing any personal data and without accepting cookies.

## 8. Security

The website is served only over an encrypted connection (HTTPS). Our providers protect the data they
process for us with technical and organisational measures appropriate to the risk.

## 9. Children

The website is intended for businesses and is not directed at children under 16. We do not knowingly
collect their data.

## 10. Changes to this policy

We update this policy when the website or the law changes. The date at the top shows the latest version.
