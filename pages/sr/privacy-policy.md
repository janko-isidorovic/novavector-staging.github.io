---
layout: legal
permalink: /sr/privacy-policy/
lang: sr-Latn
title: Politika privatnosti
title_accent: privatnosti
eyebrow: Pravne informacije
description: "Kako Nova Vector obrađuje podatke o ličnosti na www.novavector.com: kolačići, Google Analytics uz pristanak i vaša prava prema GDPR-u."
summary: Kako obrađujemo podatke o ličnosti na ovom sajtu, koje kolačiće koristimo i koja prava imate prema GDPR-u.
---

{% assign nv_months = "januara,februara,marta,aprila,maja,juna,jula,avgusta,septembra,oktobra,novembra,decembra" | split: "," %}{% assign nv_m = site.privacy_policy_updated | date: "%-m" | minus: 1 %}{% assign nv_y = site.privacy_policy_updated | date: "%Y" %}{% assign updated = site.privacy_policy_updated | date: "%-d" | append: ". " | append: nv_months[nv_m] | append: " " | append: nv_y | append: "." %}
{% assign ga_suffix = site.google_analytics | remove: "G-" %}
{% if ga_suffix == "" %}{% assign ga_suffix = "&lt;ID&gt;" %}{% endif %}

<p class="nv-legal__updated">Poslednje ažuriranje: {{ updated }}</p>

Ova politika objašnjava kako {{ site.legal_name }} („mi“) obrađuje podatke o ličnosti kada posećujete
**www.novavector.com**. Usklađena je sa Opštom uredbom EU o zaštiti podataka o ličnosti
(Uredba (EU) 2016/679, „GDPR“) i Zakonom o zaštiti podataka o ličnosti Republike Srbije
(„Službeni glasnik RS“, br. 87/2018).

Ova politika se odnosi samo na sajt. Poslovni upiti koje nam šaljete e-poštom ili telefonom nisu deo
sajta. Podaci o ličnosti u instalacijama platforme Nova Vector koje vodimo ili podržavamo za klijente
obrađuju se prema ugovoru sa svakim klijentom.

## 1. Ko je odgovoran

Rukovalac vašim podacima o ličnosti je:

{{ site.legal_name }}<br>
Generala Ljubomira Milica 10<br>
11041 Beograd, Srbija<br>
E-pošta: [info@novavector.com](mailto:info@novavector.com)<br>
Telefon: +381 64 1151 256

Sva pitanja o ovoj politici i sve zahteve za ostvarivanje vaših prava pošaljite na
[info@novavector.com](mailto:info@novavector.com), sa rečju „Privacy“ u naslovu poruke.

## 2. Ukratko

- **{{ site.legal_name }} ne čuva podatke o ličnosti posetilaca ovog sajta.** Sajt nema obrasce,
  korisničke naloge ni bazu podataka. Podatke o poseti čuvaju samo sledeće usluge:
  - **Google**, samo ako prihvatite analitičke kolačiće. Podaci su pseudonimni i ne identifikuju vas
    po imenu (odeljak 3.2).
  - **Calendly**, samo ako zakažete sastanak preko alata za zakazivanje (odeljak 3.3).
  - **GitHub**, koji hostuje sajt, u svojim tehničkim evidencijama pristupa (odeljak 3.1).
- Ceo sajt možete da koristite bez prihvatanja kolačića.
- **Google Analytics** koristimo samo ako u baneru za kolačiće kliknete **Prihvati**. Taj pristanak
  možete u svakom trenutku da povučete preko <button type="button" class="nv-cookie-link nv-legal__inline-button" data-cookie-settings>Podešavanja kolačića</button>,
  koja se nalaze i na dnu svake stranice.
- Ne koristimo reklamne kolačiće, ne prodajemo podatke o ličnosti i ne donosimo odluke o vama
  automatizovanim putem.
- Fontove, slike i video-snimke isporučujemo sa sopstvenog sajta. Kada otvorite stranicu, ne kontaktira
  se nijedna druga usluga treće strane. Jedini izuzetak je Calendly, i to samo kada sami otvorite alat
  za zakazivanje sastanaka.

## 3. Šta obrađujemo i zašto

### 3.1 Poseta sajtu (hosting)

Sajt je smešten na usluzi **GitHub Pages**, koju pruža GitHub, Inc., 88 Colin P. Kelly Jr. Street,
San Francisco, CA 94107, SAD. Kada otvorite stranicu, vaš pregledač šalje tehničke podatke koje prima
svaki veb-server: vašu IP adresu, datum i vreme, traženu stranicu, stranicu sa koje ste došli, kao i
podatke o pregledaču i operativnom sistemu. GitHub evidentira IP adrese posetilaca iz bezbednosnih
razloga.

- **Svrha:** isporuka sajta i očuvanje njegove bezbednosti.
- **Pravni osnov:** naš legitimni interes da vodimo bezbedan sajt (član 6. stav 1. tačka (f) GDPR).
- **Rok čuvanja:** kako je navedeno u [izjavi o privatnosti kompanije GitHub](https://docs.github.com/en/site-policy/privacy-policies/github-general-privacy-statement).
  Mi nemamo pristup tim evidencijama.

### 3.2 Google Analytics (samo uz vaš pristanak)

Ako u baneru za kolačiće kliknete **Prihvati**, koristimo **Google Analytics 4** da bismo razumeli kako
posetioci koriste sajt: koje stranice čitaju, kako nas pronalaze i gde bi stranice mogle da budu
jasnije. Ako kliknete **Odbij** ili ne izaberete ništa, Google Analytics se uopšte ne učitava i ne
postavljaju se nikakvi kolačići Google Analytics.

Uslugu pruža Google Ireland Limited, Gordon House, Barrow Street, Dublin 4, Irska („Google“), koji
podatke obrađuje u naše ime, prema uslovima obrade podataka koje smo s njim ugovorili.

**Podaci koji se prikupljaju:** pseudonimni identifikatori sačuvani u kolačićima; stranice koje
pregledate i kada; kako ste došli na sajt (na primer preko pretraživača ili linka); interakcije kao što
su pomeranje stranice, klikovi na linkove ka drugim sajtovima, puštanje video-snimaka i preuzimanje
fajlova; tip uređaja, operativni sistem, pregledač, veličina ekrana i jezik; i vaša približna lokacija
(zemlja, region, grad). Google Analytics 4 koristi vašu IP adresu samo da odredi približnu lokaciju i
ne evidentira je niti čuva.

**Šta ne radimo:** nismo uključili Google Signals ni funkcije za oglašavanje. Pristanak za čuvanje
podataka u svrhe oglašavanja i za personalizaciju uvek je postavljen na „denied“ (odbijeno). Analitičke
podatke ne povezujemo sa drugim podacima o vama i na osnovu njih ne možemo da vas identifikujemo.

- **Svrha:** statistička analiza korišćenja sajta, radi poboljšanja sajta i njegovog sadržaja.
- **Pravni osnov:** vaš pristanak (član 6. stav 1. tačka (a) GDPR). Čuvanje kolačića na vašem uređaju
  i njihovo čitanje takođe se zasnivaju na vašem pristanku.
- **Rok čuvanja:** podaci o događajima automatski se brišu nakon {{ site.google_analytics_retention_sr }}.
  Kolačići ističu posle 2 godine, osim ako ih ranije ne obrišete ili ne povučete pristanak.
- **Povlačenje pristanka:** otvorite <button type="button" class="nv-cookie-link nv-legal__inline-button" data-cookie-settings>Podešavanja kolačića</button>
  i kliknite **Odbij**. Google Analytics tada prestaje da radi na ovom sajtu, a njegovi kolačići se
  brišu. Povlačenje pristanka ne utiče na obradu sprovedenu pre povlačenja.
- **Prenos van EU:** Google može da obrađuje podatke u SAD. Google LLC je sertifikovan prema okviru
  EU-U.S. Data Privacy Framework, za koji je Evropska komisija 10. jula 2023. donela odluku o
  primerenosti.
- **Više informacija:** [politika privatnosti kompanije Google](https://policies.google.com/privacy) i
  [kako Google koristi informacije sa sajtova koji koriste njegove usluge](https://policies.google.com/technologies/partner-sites).

### 3.3 Zakazivanje sastanka preko usluge Calendly

Dugme **Razgovarajmo o vašem slučaju** na početnoj stranici otvara alat za zakazivanje kompanije
Calendly LLC, 115 E Main St, Ste A1B, Buford, GA 30518, SAD. Ništa se ne učitava sa usluge Calendly dok
ne kliknete to dugme. Kada ga kliknete, vaš pregledač se povezuje sa uslugom Calendly, a Calendly
obrađuje podatke koje unesete (ime, adresu e-pošte, vaše odgovore i termin koji izaberete) i može da
postavi sopstvene kolačiće.

- **Svrha:** dogovaranje sastanka koji ste zatražili.
- **Pravni osnov:** preduzimanje radnji na vaš zahtev pre zaključenja ugovora (član 6. stav 1. tačka (b) GDPR).
- **Rok čuvanja:** dok se sastanak i eventualne dalje aktivnosti ne završe. Koliko podatke čuva sam
  Calendly opisano je u [obaveštenju o privatnosti usluge Calendly](https://calendly.com/legal/privacy-notice).
- **Prenos van EU:** Calendly obrađuje podatke u SAD i oslanja se na EU-U.S. Data Privacy Framework i
  standardne ugovorne klauzule.

Ako ne želite da koristite Calendly, pišite nam na [info@novavector.com](mailto:info@novavector.com).

### 3.4 Linkovi ka mreži LinkedIn i drugim sajtovima

Sajt sadrži obične linkove, na primer ka našoj stranici na mreži LinkedIn. LinkedIn ne dobija nikakve
podatke sa ovog sajta dok ne otvorite takav link. Od tog trenutka važi politika privatnosti tog sajta.

## 4. Kolačići i slične tehnologije

| Naziv | Pružalac | Svrha | Trajanje | Kada se čuva |
|---|---|---|---|---|
| `nv-cookie-consent` (lokalno skladište pregledača) | {{ site.legal_name }} | Pamti vaš izbor u vezi sa kolačićima, da se baner ne bi prikazivao na svakoj stranici. Nikada ne napušta vaš pregledač. | 12 meseci | Kada kliknete Prihvati ili Odbij |
| `_ga` | Google | Razlikuje posetioce za Google Analytics | 2 godine | Samo kada kliknete Prihvati |
| `_ga_{{ ga_suffix }}` | Google | Čuva stanje sesije za Google Analytics | 2 godine | Samo kada kliknete Prihvati |
| Kolačići usluge Calendly | Calendly | Omogućavaju rad alata za zakazivanje | Pogledajte obaveštenje usluge Calendly | Samo kada otvorite alat za zakazivanje |
{: .nv-legal__table}

Zapis o pristanku je strogo neophodan da bi se poštovao vaš izbor i za njega pristanak nije potreban.
Kolačiće i lokalno skladište možete u svakom trenutku da obrišete i u podešavanjima pregledača; baner
će vas tada ponovo pitati.

## 5. Ko prima vaše podatke

{{ site.legal_name }} ne čuva podatke o vašoj poseti. Obrađuju ih samo pružaoci usluga navedeni
u odeljku 3: GitHub, Google i Calendly. Ne prodajemo podatke o ličnosti i ne prosleđujemo ih u svrhe
oglašavanja.

## 6. Vaša prava

Prema GDPR-u i Zakonu o zaštiti podataka o ličnosti Republike Srbije imate pravo da:

- **pristupite** podacima o ličnosti koje o vama čuvamo (član 15. GDPR);
- zahtevate **ispravku** netačnih podataka (član 16.);
- zahtevate **brisanje** svojih podataka (član 17.);
- zahtevate **ograničenje** obrade (član 18.);
- dobijete svoje podatke u prenosivom formatu (**prenosivost podataka**, član 20.);
- u svakom trenutku podnesete **prigovor** na obradu zasnovanu na našim legitimnim interesima (član 21.);
- u svakom trenutku **povučete pristanak**, sa dejstvom ubuduće (član 7. stav 3.), preko
  <button type="button" class="nv-cookie-link nv-legal__inline-button" data-cookie-settings>Podešavanja kolačića</button>.

Da biste ostvarili neko od ovih prava, pišite na [info@novavector.com](mailto:info@novavector.com).
Odgovaramo u roku od mesec dana. Pre toga možemo da zatražimo da potvrdite svoj identitet.

**Kako postupamo sa zahtevom.** {{ site.legal_name }} ne čuva podatke o vašoj poseti, pa u većini
slučajeva nemamo šta da vam dostavimo ili obrišemo. Sastanak zakazan preko alata za zakazivanje čuva
Calendly; možemo da ga pronađemo i obrišemo prema adresi e-pošte koju ste koristili. Podaci iz Google
Analytics su pseudonimni i ne možemo da ih povežemo sa vama po imenu. U skladu sa članom 11. GDPR ne možemo da odgovorimo na zahteve za pristup, ispravku ili brisanje tih podataka, osim ako
nam ne pošaljete svoj Google Analytics client ID (vrednost kolačića `_ga` u vašem pregledaču). Možete i
sami da ih obrišete: <button type="button" class="nv-cookie-link nv-legal__inline-button" data-cookie-settings>Podešavanja kolačića</button>
→ **Odbij** uklanja kolačiće, a Google briše sve analitičke podatke nakon
{{ site.google_analytics_retention_sr }}. Evidencije hostinga čuva GitHub; mi nemamo pristup njima.

Imate i pravo da podnesete pritužbu nadzornom organu. U Srbiji je to **Poverenik za informacije od
javnog značaja i zaštitu podataka o ličnosti**, Bulevar kralja Aleksandra 15, 11000 Beograd,
[www.poverenik.rs](https://www.poverenik.rs). Ako živite ili radite u EU ili Evropskom ekonomskom
prostoru, možete se obratiti i organu za zaštitu podataka o ličnosti u svojoj zemlji.

## 7. Da li morate da nam date podatke?

Ne. Sajt možete da koristite bez davanja ikakvih podataka o ličnosti i bez prihvatanja kolačića.

## 8. Bezbednost

Sajt se isporučuje isključivo preko šifrovane veze (HTTPS). Naši pružaoci usluga štite podatke koje za
nas obrađuju tehničkim i organizacionim merama primerenim riziku.

## 9. Deca

Sajt je namenjen kompanijama i nije usmeren na decu mlađu od 16 godina. Ne prikupljamo svesno njihove
podatke.

## 10. Izmene ove politike

Ovu politiku ažuriramo kada se promene sajt ili propisi. Datum na vrhu pokazuje najnoviju verziju.
