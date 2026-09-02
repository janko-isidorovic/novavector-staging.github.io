# Nova Vector v3 navigation and URL map

This file records the approved P1 hierarchy, current destinations, and planned
canonical routes. P1 exposes only pages with substantive content. Additional
navigation items become visible when their P2/P3 pages are implemented.

## P1 visible navigation

| Group | Visible destination | Current route |
| --- | --- | --- |
| Platform | Platform Overview | `/pages/nova-vector-platform` |
| Platform | Open Architecture | `/pages/nova-vector-platform#open-architecture` |
| Platform | Platform Capabilities | `/pages/nova-vector-platform#platform-capabilities` |
| Edge | Nova Edge Overview | `/pages/nova-edge-computing` |
| Edge | EdgeX Foundry | `/pages/nova-edge-computing#edgex-foundry` |
| Edge | Edge Deployment & Operations | `/pages/nova-edge-computing#edge-operations` |
| Solutions | Manufacturing | `/pages/smart-industry` |
| Solutions | Industrial Infrastructure | `/pages/smart-building` |
| Company | Professional Services | `/pages/professional-services` |
| Company | Support | `/pages/support` |
| Company | Training | `/pages/training` |
| Company | Contact / Request a Demo | `/pages/contact#request-demo` |

Smart Agriculture and Smart City remain reachable from the Solutions page but
are intentionally secondary. Education remains published for compatibility but
is removed from primary and footer navigation pending a commercial decision.

## Planned canonical-route migration

| Current route | Planned v3 route | P1 decision |
| --- | --- | --- |
| `/` | `/` | Retain |
| `/pages/products` | `/industrial-iot-platform/` | Redirect when the P2 platform landing page exists |
| `/pages/nova-vector-platform` | `/industrial-iot-platform/` | Redirect after canonical page approval |
| `/pages/nova-edge-computing` | `/edge-computing-platform/` | Redirect after canonical page approval |
| `/pages/solutions` | `/solutions/` | Retain until the new solution hub exists |
| `/pages/smart-industry` | `/manufacturing/` | Redirect when the P2 manufacturing page exists |
| `/pages/smart-building` | `/industrial-infrastructure/` | Redirect when the P2 infrastructure page exists |
| `/pages/smart-agriculture` | Undecided secondary route | Retain; do not promote |
| `/pages/smart-city` | Undecided secondary route | Retain; do not promote |
| `/pages/education` | Archive or approved secondary route | Retain unlinked pending decision |
| `/pages/services` | `/company/` or `/services/` | Decide during P2 template work |
| `/pages/professional-services` | `/professional-services/` | Redirect with new page |
| `/pages/support` | `/support/` | Redirect with new page |
| `/pages/training` | `/training/` | Redirect with new page |
| `/pages/contact` | `/contact/` | Redirect with new page |
| `/pages/blog` | `/blog/` | Keep hidden until approved articles exist |

## Deferred navigation destinations

The following destinations are part of the approved information architecture
but must not appear in navigation until substantive pages exist:

- Architecture
- Device & Asset Management
- Real-Time Data & Analytics
- Process Automation and industrial state machines
- Industrial AI
- Industrial Edge Management
- Energy & Energy Storage
- Industrial OEMs / Connected Products
- Developers, Documentation, API, and Integrations
- Case Studies and Technical Articles
- GitHub, until an approved public source repository is available

Redirects should be implemented together with the new canonical pages so no
current URL points to missing or thin content.
