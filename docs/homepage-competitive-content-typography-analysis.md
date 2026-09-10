# Nova Vector homepage competitive content and typography analysis

Version: 1.0 · Date: 2026-09-09

This document compares the Nova Vector homepage with representative Industrial
IoT, industrial edge, manufacturing operations, and industrial automation
platforms. It records the positioning patterns, buyer language, typography
systems, gaps, and recommended homepage direction for the v3 website.

The analysis complements:

- [`p3-content-review.md`](p3-content-review.md)
- [`v3-navigation-url-map.md`](v3-navigation-url-map.md)
- [`v3-screenshot-inventory.md`](v3-screenshot-inventory.md)

## Document versioning

| Version | Date | Changes |
| --- | --- | --- |
| 1.0 | 2026-09-09 | Initial competitor-content benchmark, typography review, Nova Vector gap analysis, and recommended homepage type scale. |

## Scope and methodology

The review covers:

1. PTC ThingWorx
2. Siemens Industrial Edge
3. AWS IoT SiteWise
4. Microsoft Azure IoT
5. ThingsBoard
6. MachineMetrics
7. Ignition by Inductive Automation

Homepage positioning and terminology were reviewed against the companies'
public product pages and search-result presentation on 2026-09-08 and
2026-09-09. Rendered desktop typography was measured directly on the public PTC,
Siemens, ThingsBoard, MachineMetrics, and Ignition pages. AWS and Microsoft
typography references use their official Cloudscape and Fluent design systems;
they should not be treated as exact measurements of every marketing-page
element.

Competitor claims are included only to understand public positioning. This
document does not assert that every competitor capability is available in every
edition, deployment model, or region.

## Executive conclusion

Nova Vector should combine four approaches:

- **MachineMetrics:** outcome-led manufacturing language.
- **Siemens:** disciplined enterprise hierarchy and clear explanation of what
  the platform is and what it solves.
- **Ignition:** a memorable structure for communicating a broad industrial
  platform.
- **ThingsBoard:** direct technical language and visible product depth.

Nova Vector should not imitate any one competitor. Its defensible position is
the combination of mixed-generation equipment connectivity, manufacturing
operations, process and state modeling, coordinated alarm response, industrial
edge management, flexible deployment, and an operational data foundation for
AI.

Recommended core positioning:

> An Industrial IoT and operations platform that connects mixed-generation
> equipment, digitalizes production and support workflows, and operates from
> edge to enterprise.

## Competitive homepage content comparison

| Company | Primary public message | What works | Lesson for Nova Vector |
| --- | --- | --- | --- |
| PTC ThingWorx | ThingWorx IIoT Platform | Establishes the product category immediately, then connects it to revenue, cost, quality, flexibility, and innovation. | Name the category first and follow it with business outcomes. |
| Siemens Industrial Edge | Smarter manufacturing with Industrial Edge computing | Answers “What is it?” and “What does it solve?” with centralized management, IT/OT integration, production analytics, maintenance, and automation. | Organize complex technology around buyer questions and recognizable industrial use cases. |
| AWS IoT SiteWise | Collect and process industrial data | Uses a simple data journey: collect, store, organize, monitor, calculate industrial metrics, and prevent equipment or production problems. | Prefer direct verbs and make the path from equipment data to operational value easy to understand. |
| Microsoft Azure IoT | Build an interoperable data foundation for AI | Connects IT/OT collaboration, edge-to-cloud operation, scalability, and AI readiness. | Nova Vector's “operational value now, AI-ready later” position is credible and current. |
| ThingsBoard | IoT platform for device management, data collection, processing, and visualization | Describes the platform's technical scope directly and reinforces it with product screenshots. | Preserve technical clarity, but lead with industrial outcomes rather than a generic feature inventory. |
| MachineMetrics | A smarter way to run manufacturing operations | Speaks directly about machines, people, ERP, scheduling, work orders, downtime, OEE, and production analytics. | Use this as the strongest content reference for Nova Vector's manufacturing story. |
| Ignition | One industrial platform for SCADA, IIoT, MES, HMI, reporting, and edge computing | Communicates broad capability through a memorable “Connect, Design, Deploy” structure and a clear commercial proposition. | Give Nova Vector a similarly memorable platform journey without imitating Ignition's product model. |

## What the market language indicates

The reviewed competitors repeatedly use the following categories:

- Industrial IoT platform and IIoT platform
- Industrial connectivity and IT/OT integration
- Real-time production monitoring
- OEE and production performance
- Downtime reduction and equipment reliability
- Asset monitoring and asset health
- Manufacturing operations and MES
- Industrial edge and edge management
- Remote operations
- Data contextualization and industrial data foundation
- AI readiness, predictive maintenance, and industrial AI
- Enterprise integration

These terms are more useful than generic phrases such as “unlock insights,”
“next-generation transformation,” or “future-ready innovation.” Category and
use-case language helps buyers understand the product and gives search engines
unambiguous subject context.

## Nova Vector's strongest defensible differentiators

### Mixed-generation industrial connectivity

- Direct platform-side OPC UA, Modbus TCP, BACnet/IP, and SNMP connectivity.
- MQTT, HTTP, CoAP, WebSocket, LoRaWAN, Sparkplug B, and EdgeX-based options.
- Retrofit of viable legacy equipment with sensors, an HMI, and a PLC.
- A consistent device and asset model across modern and retrofitted equipment.
- Profile-driven device descriptions, discovery, and binding where supported.

### Manufacturing operations beyond dashboards

- Shift, weekly, and monthly production plan attainment.
- Work-order production tracking.
- Produced quantity, scrap, rework, and serial tracking.
- Products, recipes, routings, and standard-versus-actual consumption.
- OEE, downtime, stoppage classification, MTTR, and MTBF.
- RFID-based operator and support-team context where RFID is deployed.

### Coordinated operational response

- Threshold, no-data, stoppage, and process-state alarms.
- Alarm-to-task creation, assignment, tracking, and resolution.
- Support-team response measurement.
- State transitions connected to notifications and persisted command requests.
- Atomic state change and command-request persistence, with asynchronous command
  execution by a separate service.

### Process modeling, simulation, and replay

- Industrial processes represented as explicit states and guarded transitions.
- Versioned simulation and historical replay workflows.
- Protocol and complete-system simulators for demonstrations, testing, and
  acceptance work before physical equipment is available.

### Industrial edge and deployment flexibility

- Local data collection and operation through Nova Edge and EdgeX.
- Local operator console for disconnected or restricted sites.
- Central health, workload, log, and software-deployment workflows.
- Cloud, on-premises, hybrid, and air-gapped deployment options.
- Edge fleet onboarding and rollout remain integrated beta capabilities for
  controlled early-adopter deployments.

### AI readiness without over-promising

- Operational data retains device, asset, process, production, alarm, and task
  context.
- An on-premises assistant can work with supported platform resources while
  data remains within the customer's deployment.
- Approved and signed ONNX models can be deployed to selected edge nodes, with
  results returned as ordinary telemetry.
- Edge AI remains an integrated beta capability.
- Model training remains in external data-science tooling; an in-platform
  training workspace remains on the roadmap.

## Positioning guardrails

The website must not copy the competitive-comparison document's claim that Nova
Vector is already publicly available under Apache 2.0. The approved current
position is:

> Nova Vector is built on open technologies and open standards. Nova Vector's
> own source code is not currently public.

Additional guardrails:

- Do not present roadmap capabilities as released features.
- Keep Edge AI and edge fleet management beta qualifications visible.
- Do not present customer-specific connectors as standard product features.
- Do not claim predictive maintenance as a packaged Nova Vector application
  until a supported, demonstrable offer exists.
- Use “condition monitoring” and “equipment reliability monitoring” where they
  more accurately describe the current capability.
- Do not publish invented customer results, percentages, or fleet sizes.

## Typography comparison

### Measured public-page typography

| Homepage | Primary font | Hero/display | Main sections | Subsections/cards | Body |
| --- | --- | ---: | ---: | ---: | ---: |
| PTC ThingWorx | Raleway | 48px | 32px | 24px | 18px |
| Siemens Industrial Edge | Siemens Sans / Siemens Roman | 48px | 32px | 24px | 16px |
| ThingsBoard | System sans-serif | 42px | 40px | 29px | 16–18px |
| MachineMetrics | DIN with Roboto body copy | 64px | 64px | 24px | 18–22px |
| Ignition | Proxima Nova | approximately 54px | 36px | 24px | 18–21px |

### Design-system references

| System | Typeface | Display | Large title | Standard body | Observation |
| --- | --- | ---: | ---: | ---: | --- |
| Microsoft Fluent 2 web | Segoe UI | 68px | 40px | 14px | Uses named semantic roles and recommends sentence case. |
| AWS Cloudscape | Open Sans | 42px | 24px page heading | 14px | Product-interface scale is intentionally denser than a marketing homepage. |

### Nova Vector's current inherited scale

The current homepage CSS contains or inherits visible text sizes including:

- 72px hero heading
- 36px capability-section heading
- 32px architecture heading
- 28px mobile section headings
- 24px general section headings
- 20px card headings
- 19px architecture-point headings
- 18px lead copy
- 17px capability introduction
- 16px body copy
- 14px legacy body, labels, captions, and supporting text

This creates too many visually similar levels. The page can feel assembled from
separate design systems even though it consistently uses Lato.

The principal issues are:

1. The 72px hero is disproportionately large relative to the 36px and 32px
   section headings.
2. Important legacy body copy can remain 14px while less important introductory
   text is 17px.
3. Closely spaced values such as 36px, 32px, 28px, and 24px do not always map to
   distinct semantic roles.
4. The 20px and 19px card-heading variants are visually indistinguishable and
   should be one role.

## Recommended Nova Vector typography system

Keep Lato and reduce the homepage to six roles:

| Role | Desktop | Mobile | Line height | Typical use |
| --- | ---: | ---: | ---: | --- |
| Hero or page heading | 48px | 36px | 1.15 | Homepage slider H1 and internal-page H1 |
| Section heading | 32px | 28px | 1.25 | Major homepage sections, including semantic H2 and H3 elements |
| Card or capability heading | 20px | 20px | 1.35 | Industry cards, architecture points, and service cards |
| Hero or section introduction | 18px | 17px | 1.55 | Hero support and one introductory paragraph per major section |
| Body copy | 16px | 16px | 1.65 | Normal explanatory content |
| Label, caption, or navigation | 14px | 14px | 1.45–1.55 | Eyebrows, captions, navigation, metadata, and compact controls |

Use font weight, spacing, color, and placement rather than additional font sizes
to create emphasis. Retain sentence case for headings; avoid MachineMetrics-style
all-uppercase display text as the homepage baseline.

## Recommended homepage narrative

The existing original-homepage composition should remain the baseline:

- Animated hero slider
- Central platform infographic
- Alternating text and product-image sections
- One architecture visualization
- Image-led industry use cases
- Restrained cards rather than a page built entirely from card grids

Within that layout, the platform journey should become memorable:

> Connect → Digitalize operations → Respond → Optimize → AI-enable

Each stage should provide an independent benefit. The customer should be able to
start with one machine, production line, facility, or remote site without an
all-at-once transformation.

## Recommended homepage content priorities

### 1. Establish the category

The first slide should retain an explicit category statement:

> Industrial IoT Platform for Connected Operations

The supporting copy should explain modern and legacy connectivity, real-time
production visibility, operational response, and edge-to-enterprise scope.

### 2. Lead with high-intent operational use cases

The homepage should prioritize:

1. Industrial IoT platform
2. Real-time production monitoring and OEE
3. Industrial connectivity for modern and legacy equipment
4. Manufacturing downtime and maintenance response
5. Industrial edge management and remote-site operation

Specialist terms such as digital twins, state machines, protocol simulators,
EdgeX, and Edge AI should support those buyer outcomes and link to substantive
capability pages.

### 3. State the difference from monitoring-only platforms

Recommended working statement:

> Unlike monitoring-only IoT platforms, Nova Vector connects equipment data
> with production plans, work orders, process state, alarms, maintenance tasks,
> and team activity.

This statement requires product-owner review but does not depend on a named
competitor claim.

### 4. Add customer proof

The largest current homepage gap is evidence. Add one restrained proof section
rather than another generic card grid.

The following customer outcomes have been confirmed by Nova Vector and are
approved for anonymized homepage use:

| Deployment | Measured result | Operational foundation |
|---|---:|---|
| Smart agriculture | 38% year-over-year increase in crop yield | Real-time air, soil, and weather sensing replaced twice-yearly laboratory analysis and supported fertilization optimization. |
| Smart buildings | 17% year-over-year reduction in operating cost | Floor-level occupancy analysis revealed underused areas and enabled targeted energy savings. |
| Industrial digitalization | 35% OEE improvement over two years | Micro-stoppage visibility exposed significant production losses and guided operator training and utilization improvements. |
| Smart energy | 75% reduction in go-to-market timeline | Predictive monitoring and control technology accelerated development of an energy-storage and delivery solution. |

Customer names and outbound customer links must not appear in the homepage
version. Results should be described as deployment-specific rather than typical
or guaranteed outcomes.

The existing anonymized manufacturing example can continue to cover:

- Mixed modern and retrofitted legacy equipment
- Direct Modbus TCP and OPC UA connectivity where supported
- Additional sensors, HMI, and PLC retrofit where required
- Live production plan and downtime monitoring
- Alarm-to-support workflow
- Optional RFID operator and response context

Any additional quantity, improvement, deployment size, or result still requires
evidence and customer-disclosure approval before publication.

## Proposed implementation sequence

1. Normalize homepage typography to the approved six-role scale.
2. Verify long SEO-focused headings at desktop, small-desktop, tablet, and mobile
   widths.
3. Refine the platform infographic around the five-stage customer journey.
4. Add one approved, anonymized customer-proof section.
5. Replace candidate screenshots with current, sanitized product captures using
   the screenshot inventory.
6. Review metadata and internal links after final homepage copy approval.

## Source pages

Sources were reviewed on 2026-09-08 and 2026-09-09:

- PTC ThingWorx: <https://www.ptc.com/en/products/thingworx>
- Siemens Industrial Edge: <https://www.siemens.com/en-us/products/industrial-edge/>
- AWS IoT SiteWise: <https://aws.amazon.com/iot-sitewise/>
- Microsoft Azure IoT: <https://azure.microsoft.com/en-us/solutions/iot>
- ThingsBoard: <https://thingsboard.io/>
- MachineMetrics: <https://www.machinemetrics.com/>
- Ignition: <https://inductiveautomation.com/ignition/>
- Microsoft Fluent 2 typography: <https://fluent2.microsoft.design/typography>
- AWS Cloudscape typography: <https://cloudscape.design/foundation/visual-foundation/typography/>

This analysis should be revisited when competitor positioning changes materially
or before a major Nova Vector website release.
