# Serbian (Latin) translation: glossary and rules

The Serbian site lives under `/sr/`, one page per English page with the same slug
(`/manufacturing/` → `/sr/manufacturing/`). Pages are in `pages/sr/`, the homepage is `sr/index.html`
with its includes in `_includes/sr/`, shared labels are in `_data/i18n.yml`, and the menus in
`_data/navigation_sr.yml` and `_data/footer_links_sr.yml`.

## Rules

1. **Serbian, Latin script, ekavian**, with full diacritics (č, ć, š, ž, đ). Never Cyrillic, never
   Croatian or Bosnian forms (write hiljada, nedelja, obaveštenje, kompanija, izabrati, podaci,
   not tisuća, tjedan, obavijest, tvrtka, odabrati, podatci), never Czech or Slovak letters
   (é, ě, ů).
2. **Natural, not literal.** Write it as a Serbian engineer or plant manager would say it. Short
   sentences. Same facts as the English: nothing added, nothing dropped, no stronger claims.
3. **Address the reader as "vi"** (lowercase: vi, vaš, vama).
4. **Brand and product names stay as they are and are not declined:** Nova Vector, Nova Edge,
   EdgeX, Grafana, Docker, Kubernetes, Modbus TCP, BACnet/IP, SNMP, MQTT, OPC UA, LoRaWAN, SenML,
   Sparkplug B. Use a noun in front when Serbian needs a case: "platforma Nova Vector",
   "sa platformom Nova Vector", "u sistemu Nova Edge".
5. **Abbreviations stay:** OEE, MES, ERP, SCADA, BMS, PLC, HMI, CMMS, BESS, MTBF, MTTR, API, AI,
   IoT, IIoT, SSO, VPN, SSH, FMU, CSV. Explain once per page where it helps: "OEE (ukupna
   efikasnost opreme)".
6. **Search titles** (front matter `title`) stay at most 46 characters, because the site adds
   " | Nova Vector". **Descriptions** at most 155 characters, the search term first.
7. **Internal links** in front matter (`url:`, `primary_url:`, `link.url`) get the `/sr` prefix:
   `/energy/` → `/sr/energy/`. Not: `/assets/...`, `mailto:`, external `https://` links, `#anchors`
   on the same page (`#request-demo` stays).
8. Units and numbers: decimal comma (1,5 kW, 99,9 %), a space before %, °C stays.

## Terms

| English | Serbian |
| --- | --- |
| Industrial IoT platform | industrijska IoT platforma |
| platform | platforma |
| edge computing | edge računarstvo |
| edge node | edge čvor |
| edge AI | AI na edge-u |
| fleet (of edge nodes) | flota (edge čvorova) |
| rollout | uvođenje (postepeno uvođenje) |
| device | uređaj |
| asset | sredstvo, oprema (by context) |
| device profile | profil uređaja |
| connectivity | povezivanje |
| live data | podaci uživo |
| telemetry | telemetrija |
| time series | vremenske serije |
| dashboard | kontrolna tabla |
| report | izveštaj |
| alert, alarm | alarm |
| alert rule | pravilo alarma |
| notification | obaveštenje |
| task | zadatak |
| task board (Kanban) | tabla zadataka (Kanban) |
| work order | radni nalog |
| shift | smena |
| shift plan | plan smena |
| production line | proizvodna linija |
| downtime, stoppage | zastoj |
| micro-stoppage | mikrozastoj |
| stoppage Pareto | Pareto zastoja |
| plan attainment | ispunjenje plana |
| output vs plan | proizvedeno u odnosu na plan |
| reliability | pouzdanost |
| maintenance | održavanje |
| recipe | recept |
| routing | tehnološki postupak |
| material consumption | utrošak materijala |
| genealogy | genealogija (sledljivost) |
| label printing | štampa etiketa |
| attendance | evidencija prisustva |
| operator | operater |
| process model, state machine | model procesa, mašina stanja |
| replay | reprodukcija (replay) |
| simulator, scenario | simulator, scenario |
| fault injection | ubacivanje kvarova |
| anomaly detection | detekcija anomalija |
| model registry | registar modela |
| AI assistant | AI asistent |
| on-premises | lokalno (na sopstvenim serverima) |
| cloud | oblak (u oblaku) |
| hybrid | hibridno |
| air-gapped | izolovano od interneta (air-gapped) |
| integration | integracija |
| implementation | implementacija |
| support | podrška |
| training | obuka |
| use case | slučaj upotrebe |
| Request a Demo | Zatražite demo |
| Explore the Platform | Upoznajte platformu |
| Discuss your use case | Razgovarajmo o vašem slučaju |
| Continue evaluating | Nastavite procenu |
| energy storage | skladištenje energije |
| battery energy storage system | baterijski sistem za skladištenje energije (BESS) |
| inverter (PCS) | invertor (PCS) |
| buildings & infrastructure | zgrade i infrastruktura |
| agriculture | poljoprivreda |
| manufacturing | proizvodnja |

## Menu labels

| English | Serbian |
| --- | --- |
| Platform | Platforma |
| Overview | Pregled |
| Devices & Connectivity | Uređaji i povezivanje |
| Reports & Analytics | Izveštaji i analitika |
| Alerts & Tasks | Alarmi i zadaci |
| Edge Computing | Edge računarstvo |
| Platform & Edge AI | AI na platformi i edge-u |
| Equipment Simulators | Simulatori opreme |
| Solutions | Rešenja |
| Manufacturing & OEE | Proizvodnja i OEE |
| Energy | Energetika |
| Agriculture | Poljoprivreda |
| Buildings & Infrastructure | Zgrade i infrastruktura |
| Services | Usluge |
| Implementation & Integration | Implementacija i integracija |
| Support | Podrška |
| Training | Obuka |
| About | O nama |
| Contact | Kontakt |
| Privacy Policy | Politika privatnosti |
| Cookie settings | Podešavanja kolačića |

## Added after the first translation (2026-11-27)

| English | Serbian |
| --- | --- |
| availability / performance / quality (OEE) | raspoloživost / učinak / kvalitet |
| MTBF / MTTR | srednje vreme između kvarova (MTBF) / srednje vreme popravke (MTTR) |
| gateway | gejtvej |
| meter, energy meter | brojilo, brojilo energije |
| deploy (software, models to nodes) | raspoređivanje |
| deployment (installation of the platform) | instalacija |
| changeover | promena proizvoda |
| scrap / rework | škart / dorada |
| template | šablon |
| go-live | puštanje u rad |
| acceptance test | prijemni test |
| store and forward | čuvanje i prosleđivanje (store and forward) |
| browser | pregledač |
| connected operations | povezano poslovanje |

Months in dates: "22. novembra 2026." (see `pages/sr/privacy-policy.md`). The GA4 retention has a Serbian twin in
`_config.yml` (`google_analytics_retention_sr`); change both together.
