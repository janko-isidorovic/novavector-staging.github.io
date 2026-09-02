# P3 content review register

This register separates reviewable website copy from claims that still need technical, commercial, legal, or disclosure approval. All v3 pages remain `noindex` while this review is open.

## Approval gates

| Claim area | Draft treatment | Approval required |
| --- | --- | --- |
| Deployment | Edge, on-premises, private-cloud, and cloud options are described at category level | Confirm supported topology, ownership, resilience, and HA for each offer |
| Protocols | No universal protocol list is published | Confirm protocol, EdgeX device-service, gateway, and version support per configuration |
| Commands | State change and command-request persistence may be atomic; execution is asynchronous | Confirm wording with platform engineering |
| Edge management | Allowlisted systemd/container operations, metrics, health, and logs are qualified by configuration | Confirm released agent version and production scope |
| Simulation and replay | Described without promising version-selection behavior | Confirm released version and supported workflow |
| AI at the edge | Data/analytics integration is current; managed model lifecycle and accelerator support are roadmap | Product owner approval before changing roadmap labels |
| Open technologies | No claim that Nova Vector source code is public or Apache 2.0 | Legal/commercial approval for final wording |
| EdgeX history | No historical leadership claim in the page draft | Provide an approved primary source before publication |
| Customer evidence | All examples remain anonymized and unquantified | Customer disclosure approval and evidence for every metric |

## Proposed anonymized case studies

### Automotive component manufacturing — production visibility

- Challenge: fragmented production signals and limited context for line stoppages.
- Architecture: machine telemetry, production plans, operator classification, operational dashboards, and OEE analysis.
- Evidence needed: connected-line scope, reporting period, calculation method, before/after baseline, and disclosure owner.

### Distributed energy or storage — operational state

- Challenge: relate telemetry and alarms from distributed assets to an explicit operating condition.
- Architecture: edge connectivity, time-series telemetry, state transitions, alarms, notification workflows, and approved control integration.
- Evidence needed: anonymized asset scope, supported interfaces, event volume, operational result, and disclosure owner.

### Industrial OEM — connected equipment service

- Challenge: provide remote product visibility without replacing customer infrastructure.
- Architecture: device identity, installed-asset hierarchy, telemetry, alarms, diagnostics, APIs, and tenant boundaries.
- Evidence needed: product-family scope, deployment model, service workflow, measured result, and disclosure owner.

## Technical article briefs

| Working title | Reader question | Product link |
| --- | --- | --- |
| Edge Computing vs Cloud Computing for Industrial IoT | Which processing belongs near equipment, and which belongs centrally? | `/edge-computing-platform/` |
| How to Calculate OEE from Real-Time Machine Data | Which signals, contexts, and classifications produce a defensible OEE calculation? | `/manufacturing-oee-software/` |
| How to Detect and Classify Manufacturing Downtime | How should machine detection and operator input work together? | `/manufacturing/` |
| EdgeX Foundry Architecture Explained | How do device services, core services, messages, and exports fit together? | `/edgex-foundry-platform/` |
| MQTT vs NATS for Industrial IoT | What roles can each messaging system play in an edge-to-platform architecture? | `/integrations/` |
| State Machines for Industrial Process Modeling | When does explicit state improve alarms, commands, and workflow behavior? | `/industrial-state-machine/` |
| Building a Digital Representation of a Production Process | How do assets, telemetry, state, and production context form an operational model? | `/industrial-iot-platform/` |
| Running AI Models on Industrial Edge Computers | What must be managed beyond the model runtime? | `/edge-ai-industrial-iot/` |
| Time-Series Data for Industrial IoT | How should current values, history, aggregation, and asset context be separated? | `/iot-timeseries-analytics/` |
| Designing Reliable Edge-to-Cloud Industrial Systems | Where should buffering, retries, idempotency, observability, and ownership live? | `/architecture/` |

Every article requires technical review. Product-specific version, performance, security, compatibility, and availability claims must link to maintained documentation or an approved source.
