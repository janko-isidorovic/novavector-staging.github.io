# Nova Vector Platform — Feature Overview

*October 2026 · for clients and sales engineers*

Nova Vector is an industrial IoT and digitalization platform. It connects
machines, sensors and sites. It turns their data into dashboards, alerts, tasks
and production records. It manages edge nodes and the AI models that run on
them. It also includes an AI assistant and a set of simulators for demos,
pilots and acceptance tests.

The platform is modular. A project starts with the modules it needs and adds
more later, in the cloud, on premises or both.

This overview describes each main feature in a few lines. Each feature's
detailed document is linked from the table below and at the end of its
section.

> All screenshots come from a demo installation fed by
> [Nova Vector Simulators](#10-simulators). The demo runs a battery energy
> storage (BESS) enclosure, a bottling line and an AI-server assembly line.

## At a glance

| Feature | What it gives you | Details |
| --- | --- | --- |
| [Device connectivity](#1-device-connectivity) | Connects new and legacy equipment over standard industrial and IoT protocols | [Document 1](01-device-connectivity.md) |
| [Devices and live data](#2-devices-and-live-data) | Keeps every device in one registry, organized as a hierarchy, with live and historical data | [Document 2](02-devices-and-live-data.md) |
| [Dashboards and reports](#3-dashboards-and-reports) | Gives a live overview of operations, and reports on plan attainment, downtime and reliability | [Document 3](03-dashboards-and-reports.md) |
| [Alerts, notifications and tasks](#4-alerts-notifications-and-tasks) | Sends alarms to the right people and turns them into tracked tasks | [Document 4](04-alerts-notifications-and-tasks.md) |
| [Process Simulator](#5-process-simulator) | Provides a live digital twin of a process: its machines, their states and the rules that link them | [Document 5](05-process-simulator.md) |
| [Manufacturing operations](#6-manufacturing-operations) | Handles work orders, recipes, production plans, shift planning, production counts and material use | [Document 6](06-manufacturing-operations.md) |
| [Edge management](#7-edge-management) | Installs, configures and updates whole fleets of edge nodes from one place | [Document 7](07-edge-management.md) |
| [Edge AI](#8-edge-ai) | Runs AI models on edge nodes and returns their results as data | [Document 8](08-edge-ai.md) |
| [AI Assistant (preview)](#9-ai-assistant-preview) | Answers questions about the platform and makes changes, in plain language | [Document 9](09-ai-assistant.md) |
| [Simulators](#10-simulators) | Simulates equipment and whole systems for demos, pilots and tests | [Document 10](10-simulators.md) |
| [Automation and integration](#11-automation-and-integration) | Offers device commands, schedules, low-code flows and open APIs | [Document 11](11-automation-and-integration.md) |
| [Security and administration](#12-security-and-administration) | Provides single sign-on and roles, keeps plants and sites apart, and monitors the platform | [Document 12](12-security-and-administration.md) |
| [Deployment options](#13-deployment-options) | Runs on premises, in the cloud or hybrid, on Docker or Kubernetes | [Document 13](13-deployment-options.md) |

---

## 1. Device connectivity

Nova Vector takes data from the equipment a site already has, so nothing needs
replacing. It reads industrial controllers and building systems directly. It
also accepts data from IoT devices and gateways.

- **Industrial and building protocols:** OPC UA, Modbus TCP, BACnet/IP and SNMP traps.
- **IoT protocols:** MQTT, HTTP and WebSocket. CoAP, and LoRaWAN for
  long-range, low-power sensors, are in pilot.
- **Gateways:** one connection serves all the devices behind a gateway or controller.
- **Report by exception:** a value can be sent only when it changes by more
  than a set amount. This keeps network traffic and storage low.
- **More protocols at the edge:** edge nodes add protocols through EdgeX
  Foundry (see [Edge management](#7-edge-management)).

![Modbus connections, each serving several devices](images/01-device-connectivity/modbus-connections.png)
*Modbus connections. Each connection serves a gateway with several devices behind it, and each can be switched on or off on its own.*

**Details:** [1. Device Connectivity](01-device-connectivity.md)

## 2. Devices and live data

Each device, machine and asset is registered once and placed in a hierarchy:
site, line, machine, sensor. A profile describes each device type once, and
every new device of that type reuses it.

- **One device list:** a table or tree view of all devices, with status, filters and CSV export.
- **Profile catalog:** reusable device types, with properties, versions and lifecycle states.
- **One page per device:** charts, real-time messages, alerts and connections for each device.
- **Full history:** all data is kept as time series and can be charted,
  exported and read through the data API.

![Devices in the tree view](images/02-devices-and-live-data/devices-tree.png)
*The tree view shows every device under its line or process, with its current status.*

![Live data of one device](images/02-devices-and-live-data/device-live-data.png)
*The page for one device (here an HVAC unit) shows its last hour of data, the raw messages and its alerts.*

**Details:** [2. Devices and Live Data](02-devices-and-live-data.md)

## 3. Dashboards and reports

The home dashboard gives an overview of the whole installation: message rates
per protocol, device and channel counts, open alerts, a site map and the
busiest channels.

Dashboards and reports are built with Grafana, embedded in the platform with
single sign-on. Default dashboards ship for devices, channels, KPIs, alerts
and tasks. Each user sees the reports owned by their groups.

Management reports are built for each project on the platform's own data,
adapted to the customer's process:

- **Plan attainment:** actual output against the shift, weekly and monthly plan, as it happens.
- **Downtime:** the number and duration of stoppages per machine and line, by reason.
- **Equipment reliability:** MTTR and MTBF per machine and line, with no extra hardware.
- **Team performance (needs RFID readers):** utilization and efficiency of operator and maintenance teams.

![Home dashboard](images/03-dashboards-and-reports/home-dashboard.png)
*The home dashboard shows message rates per protocol, totals, the site map and the busiest channels.*

**Details:** [3. Dashboards and Reports](03-dashboards-and-reports.md)

## 4. Alerts, notifications and tasks

Alerts fire when a value goes out of range or when a device stops reporting.
Each alert e-mails the right people, with its own recipients and message for
each level.

An alert can also raise a task for the maintenance or support team. The task
is resolved on its own when the alert clears, and a supervisor then closes
it. Tasks have categories, statuses, assignees, durations, reason codes and a
full change history.

![Task list](images/04-alerts-notifications-and-tasks/tasks.png)
*Maintenance, quality and safety tasks across three sites, with status, duration, assignee and resolution.*

**Details:** [4. Alerts, Notifications and Tasks](04-alerts-notifications-and-tasks.md)

## 5. Process Simulator

The Process Simulator is an operational digital twin. It models a process as a
set of machines. Each machine moves through a set of states, such as running,
idle, starved or stopped, and rules link the machines to each other and to the
state of the whole process.

- **Live mode:** the model follows real device data. It shows the current
  state of every machine and the state history of the whole process.
- **Simulation and replay:** recorded data is replayed through a copy of the
  model, faster than real time, to investigate an incident. Runs can be paused,
  resumed and compared side by side.
- **Explained changes:** every state change is logged, with the data that
  triggered it.
- **Versions:** process definitions are versioned, and every log entry records
  the version that made the change.

![Process Simulator: a production line](images/05-process-simulator/production-line.png)
*A bottling line in live mode. The top strip shows the state history of the line, and each card shows a machine, conveyor or sensor with its current state.*

**Details:** [5. Process Simulator](05-process-simulator.md)

## 6. Manufacturing operations

The platform includes a lightweight MES, so production planning and execution
work on the same live data as monitoring.

- **Products and KPIs:** product codes and packaging, and a validated speed
  for each product on each machine.
- **Recipes and routings:** a bill of materials and process steps for each
  product, with versions and alternatives.
- **Work orders:** good, scrap and rework pieces are counted from the
  machine's own data, and the material recorded on each shift is compared
  with the recipe.
- **Production plans and the shift planning board:** work orders are planned
  across machines and shifts by drag and drop, using each product's validated
  speed. Supervisors approve the plans, and only approved plans count.
- **Stoppages:** planned stoppages reduce a shift's capacity, and stoppages
  during the shift are recorded with a category.
- **Shop floor:** Zebra label printing from work orders, and attendance from
  RFID badge readers. Links to scales and to ERP or MES systems are built for
  each project.

![A recipe with its bill of materials](images/06-manufacturing-operations/recipe.png)
*A recipe (bill of materials) with materials, a service and energy per unit. It has versions, alternatives and a default.*

**Details:** [6. Manufacturing Operations](06-manufacturing-operations.md)

## 7. Edge management

Edge nodes run next to the equipment. They read field devices through EdgeX
Foundry, run local services such as AI models, and are all managed from the
platform.

- **Onboarding at scale:** a fleet is imported from a CSV file, and whole
  groups of nodes are installed in one step over SSH. A node type sets the
  software and agent configuration that each kind of node gets.
- **Catalog of approved software:** service bundles and agent packages must be
  approved before they can be deployed. Examples are the EdgeX 2.3, 3.1 and 4.0
  runtimes, the Edge AI runtime and the local operator console.
- **Rollouts:** updates roll out to groups of nodes, a set number at a time,
  and stop when too many fail. Each node checks that the new version comes up
  healthy, and restores the previous version if it does not.
- **Edge devices:** the platform shows the EdgeX devices on each node and
  charts their readings. Devices are copied from one node to others in a few
  steps, also from the platform's saved copy when the source node is offline.
- **Site registry:** nodes pull their software from a container registry
  that runs with the platform, not from the internet.
- **On-site access:** every node has a local operator console, with a local
  login when the platform cannot be reached. Remote sessions (SSH, RDP, VNC)
  to on-site machines run in the browser.

![Bundle catalog](images/07-edge-management/bundle-catalog.png)
*The bundle catalog lists approved software for edge nodes: three EdgeX releases, the Edge AI runtime, the local console and the simulator systems.*

**Details:** [7. Edge Management](07-edge-management.md)

## 8. Edge AI

Edge AI runs models where the data is produced. Each model is stored in the
platform's registry with versions and must be approved before use. It is then
deployed to selected edge nodes and runs there on the node's live device data.

The results come back to the platform as ordinary device data, within seconds.
Dashboards and reports can use them like any other signal.

- **Standard models:** models use the standard ONNX format and run on the node's CPU.
- **Checked before deployment:** the platform checks each node's
  architecture, runtime, memory and storage, and the bound device, before it
  sends a model.
- **Device inputs:** model inputs come from EdgeX device readings on the node.
  Camera-based models are in pilot.
- **Model control:** the platform shows the active model on each node. New
  versions are rolled out with a health check on every node, and a deployment
  can be rolled back to the version the nodes ran before.

![Edge AI model registry](images/08-edge-ai/models.png)
*The model registry shows each model's versions, approval status, size and checksum, with a deploy action.*

**Details:** [8. Edge AI](08-edge-ai.md)

## 9. AI Assistant (preview)

The AI Assistant is a chat page in the platform, offered as a preview. Users
ask questions in plain language, in English or Serbian. It answers from live
platform data and covers:

- devices, channels and their latest readings
- organizations, people and shifts
- tasks, production plans and schedules
- notifications and process simulations

The assistant can also make changes. It creates, changes and deletes devices
and channels after the user confirms. It can also run device commands and
start or stop simulations. Answers appear as tables and cards, with a short
written answer.

The assistant works with the user's own login and permissions. The language
model runs on a server in the customer's own environment, so questions and
data stay there.

> **Preview:** the assistant is best suited today to direct questions and
> requests about one kind of record. See its
> [current scope](09-ai-assistant.md#current-scope).

![AI Assistant](images/09-ai-assistant/confirm-create.png)
*A request in plain language to create a device: the assistant shows what it will create and waits for the user's confirmation.*

**Details:** [9. AI Assistant](09-ai-assistant.md)

## 10. Simulators

Nova Vector Simulators behave like real equipment, down to the protocol. The
platform can be shown, configured and tested before the hardware is available.

- **Protocols:** simulated Modbus TCP devices and gateways, BACnet/IP devices,
  SNMP trap sources and MQTT edge nodes. OPC UA adapters are tested against a
  standard OPC UA test server.
- **Three reference systems:** a battery energy storage enclosure, a bottling
  line and an AI-server assembly line. The devices in a system share one model,
  so a fault spreads as it would on site. For example, when the HVAC fails, the
  enclosure and the battery cells heat up. Above the cells' limit, the
  battery management system raises an over-temperature alarm and the inverter
  is held to a lower power.
- **Scenarios:** scripted events and faults in model time. Most scenarios
  check their expected outcomes and report how many were met. The model clock
  runs at up to 600 times real time.
- **One-command setup:** one command per system creates the matching devices,
  connections, alarms, tasks and production master data on the platform, and
  another removes them.
- **Runs anywhere:** on a laptop or on a separate lab machine. The systems are
  also packaged as edge node bundles for [Edge management](#7-edge-management).

![Simulator console for the BESS enclosure](images/10-simulators/bess-console.png)
*The console for the BESS enclosure shows the model clock, eight ready-made scenarios and one tab per simulated protocol.*

**Details:** [10. Simulators](10-simulators.md)

## 11. Automation and integration

- **Device commands:** defined once, with fixed or calculated values, and sent
  to devices on demand, on a schedule or repeatedly as a heartbeat.
- **Schedules and jobs:** recurring jobs at fixed intervals send commands to
  devices.
- **Rules and workflows:** a low-code visual editor (Node-RED) for custom flows
  and integrations. Threshold rules and alarms are part of
  [Alerts](#4-alerts-notifications-and-tasks).
- **Custom functions (preview):** a workspace for serverless functions hosted
  on the platform.
- **Open interfaces:** documented REST APIs with single sign-on, and MQTT, HTTP
  and WebSocket access for applications. Integrations with ERP, MES, quality
  and other systems are built for each project on these interfaces.

![Automation results on a device](images/11-automation-and-integration/automation-result.png)
*A command sent by a heartbeat every 5 seconds and by a one-minute schedule, as it arrives on a device.*

**Details:** [11. Automation and integration](11-automation-and-integration.md)

## 12. Security and administration

- **Single sign-on:** one login (Keycloak) for the console, dashboards and
  administration tools. Access to each module is given per user, and users
  can add two-factor login.
- **Groups:** every device and record belongs to a group, and users see only
  the data of their groups. One installation can hold several plants, sites
  and business units, kept apart.
- **Encryption:** HTTPS for the console, the APIs and device connections.
  Stored credentials of the industrial adapters are encrypted.
- **Monitoring:** built-in consoles for logs, metrics and tracing.
- **Edge nodes:** every command from the platform carries a short-lived token
  signed for that one node, and each node keeps an audit journal of the
  commands it received.

![Groups in User Admin](images/12-security-and-administration/groups.png)
*User administration inside the platform: the groups that keep each site's devices and records apart.*

**Details:** [12. Security and administration](12-security-and-administration.md)

## 13. Deployment options

- **Where it runs:** on the customer's servers or on a cloud server the customer
  controls, with edge nodes at the sites (hybrid). Sites without internet
  access are prepared for each project.
- **How it runs:** as containers. Docker Compose on a single Linux server is
  the standard scripted installation. Kubernetes installations (for example
  Rancher) are delivered for each project.
- **Modular:** protocol adapters, edge fleet services and the AI model server
  are optional. The industrial adapters and the main data-processing services
  (batch writer, decoder, notifications, tasks) can run as several instances.

**Details:** [13. Deployment options](13-deployment-options.md)
