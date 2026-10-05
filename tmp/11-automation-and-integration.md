# 11. Automation and integration

*Nova Vector Platform · feature document 11 of 13 · October 2026 · for clients and sales engineers*

[← Feature overview](FEATURES.md)

The platform automates actions on devices and connects to other systems:

- **Device commands:** defined once and sent to devices on demand, on a
  schedule, or repeatedly as a heartbeat.
- **Rules and workflows:** a Node-RED editor for custom flows.
- **Custom functions (preview):** a workspace for serverless functions.
- **Open interfaces:** REST APIs with single sign-on, and MQTT, HTTP and
  WebSocket access for applications, so that ERP, MES, quality and other
  systems can exchange data with the platform.

Threshold rules and alarms are part of
[Alerts, notifications and tasks](04-alerts-notifications-and-tasks.md).
Process-level logic (states, transitions and actions) is part of the
[Process Simulator](05-process-simulator.md).

## Contents

- [How it fits together](#how-it-fits-together)
- [Device commands](#device-commands)
- [Schedules and jobs](#schedules-and-jobs)
- [Heartbeats](#heartbeats)
- [Rules and workflows: Node-RED](#rules-and-workflows-node-red)
- [Custom functions (preview)](#custom-functions-preview)
- [Integration with other systems](#integration-with-other-systems)
- [Current scope](#current-scope)
- [Questions to ask the customer](#questions-to-ask-the-customer)

---

## How it fits together

| Tool | What it is for | Where |
| --- | --- | --- |
| **Commands** | A value or a set of values to send to a device, for example a setpoint | Connectivity → Commands |
| **Send Command** | Send a command to a device now | Automation & Processing → Applications → Send Command |
| **Schedules and jobs** | Send commands at a fixed interval | Connectivity → Commands → Schedules, Jobs |
| **Heartbeats** | Send a command's value every few seconds, constant or changing | Connectivity → Commands → Heartbeats |
| **Node-RED** | Custom flows and integrations, built visually | Automation & Processing → Rules Engine |
| **Functions (preview)** | Custom code hosted on the platform | Automation & Processing → App Management |
| **APIs** | Integration with other systems | Administration → System → Open API |

**Lab run:** a test device and channel were created, with a command
*cooling_setpoint* (22 °C). The command was then:

1. sent once, by hand
2. started as a heartbeat every 5 seconds, counting from 20 to 25 °C
3. added to a job on a schedule that runs every minute

All three arrived on the test device within the expected times: the
heartbeat values every 5 seconds, and the scheduled value at each minute.
The test objects were deleted afterwards.

![Results of the lab run](images/11-automation-and-integration/automation-result.png)
*The test device on the platform: the heartbeat's values every 5 seconds (20 to 25 °C) and the scheduled command, as ordinary device data.*

## Device commands

A command is defined once and used everywhere:

- **Content:** a name, a unit and a value (number, text, true/false or
  data), or several values at once.
- **Expressions:** a value can be calculated when the command is sent, from
  inputs and parameters, with functions such as min, max, round and clamp.
  For example, a setpoint can be limited to a safe range.
- **Delivery:** the command is sent on a device's channel, as data of that
  device. Devices that listen on the channel, for example over MQTT,
  receive it, and the platform stores it with the device's other data.

**Who sends commands:**

- a user, from *Send Command* (pick the device, the channel and the command)
- a schedule (see below)
- a heartbeat (see below)
- the [Process Simulator](05-process-simulator.md), as a transition action
- the [AI Assistant](09-ai-assistant.md), on request

![Commands](images/11-automation-and-integration/commands.png)
*The command list with the lab run's cooling_setpoint command.*

## Schedules and jobs

- **Schedule:** an interval in minutes, a start and an optional end.
- **Job:** belongs to a schedule. Each time the schedule fires, the job runs.
- **Step:** each step of a job sends one command to one device on one
  channel.
- **On the device:** the device page's *Jobs* tab lists the jobs that send
  commands to that device, with their status.

Each job shows its last and next run. In the lab run, the job ran every
minute and showed the time of its next run.

![Schedules](images/11-automation-and-integration/schedules.png)
*The lab run's one-minute schedule.*

## Heartbeats

A heartbeat sends a command's value to a device repeatedly:

- **Interval:** from 100 milliseconds.
- **Value:** constant, counting up between a start and an end value, or
  calculated by an expression.
- **Automatic stop:** after a set time, if wanted.
- **Control:** start, stop and resume, with the current value shown live.

Heartbeats are useful to keep a device's setpoint fresh, to test a device or
an adapter, or to feed a demonstration.

![Heartbeats](images/11-automation-and-integration/heartbeats.png)
*An active heartbeat of the lab run, with its current value (21 °C).*

## Rules and workflows: Node-RED

Node-RED, a widely used open-source tool for visual flows, is built into the
console:

- **Editor:** flows are drawn by connecting nodes in the browser.
- **Nodes:** the standard Node-RED nodes: MQTT, HTTP, WebSocket, TCP and UDP,
  functions, switches, timers, and others.
- **Connecting to the platform:** a flow uses an application identity (see
  below) to read and send device data over MQTT or HTTP.
- **Typical uses:** forwarding data to another system, small calculations,
  or reacting to a value with a command.

## Custom functions (preview)

The *App Development* page opens a Nuclio workspace, an open-source platform
for serverless functions. Functions written in common languages (for
example Python, Go or JavaScript) run as containers on the platform server.
No ready-made functions ship with the platform; the workspace is for project
work.

## Integration with other systems

**REST APIs.** Every module has a REST API, the same one the console uses.

- **Authentication:** single sign-on tokens from Keycloak. An external
  system uses its own service account, set up for the project.
- **Groups:** a system sees and changes only the records of its groups,
  like a user.
- **Documentation:** an interactive API page (OpenAPI) in the console.

**Device-level access for applications.** An *application* is a platform
identity with its own key, like a device. Applications connect over:

- MQTT (also over TLS where the installation publishes it)
- HTTPS
- secure WebSocket

**Data out:**

- the data API: readings, aggregates and chart data for any time range
- [dashboards and reports](03-dashboards-and-reports.md) (Grafana)
- CSV export from the device pages

**Notifications:** e-mail, from alerts and from the Process Simulator.

![API documentation](images/11-automation-and-integration/open-api.png)
*The interactive API documentation in the console.*

## Current scope

This list gives sales engineers the current boundaries, so a proposal
matches what the platform delivers today.

- **Schedules:**
  - Fixed intervals in minutes, with a start and an end. No calendars,
    shift-based times or cron expressions.
  - Steps send commands; there are no other step types (for example HTTP
    calls or scripts).
  - Switching a job or a step off does not yet stop it. Delete it instead.
  - A step always reports success; delivery errors are not yet shown, and
    there is no run history.
- **Commands to MQTT devices:** set up and tested for each project.
- **Access:** schedules and heartbeats do not yet check that the device and
  channel belong to the user's group. Until a fix ships, give the command
  and schedule roles only to trusted users.
- **Node-RED:**
  - One editor for the whole installation. It is not separated by customer
    or group, and is meant for administrators.
  - No Nova Vector nodes yet; flows use the standard nodes and an
    application key.
  - External systems cannot yet call Node-RED flows directly; they use the
    platform APIs.
- **Custom functions (preview):** meant for administrators only, because a
  function has access to the server's container runtime.
- **Admin-only tools:** the platform does not yet limit Node-RED and the
  function workspace to administrators by itself. This is set up for each
  installation (see [Security and administration](12-security-and-administration.md)).
- **Integration:**
  - There are no ready-made ERP or MES connectors. Each integration is built
    for the project on the APIs, Node-RED or a custom function.
  - No outgoing webhooks; notifications are e-mail only.
  - No API keys: external systems use a service account.
  - The published API documentation covers part of the APIs; full coverage
    is being prepared.
  - No rate limiting at the gateway.

## Questions to ask the customer

- Which systems should exchange data with the platform: ERP, MES, quality,
  maintenance, a data lake? In which direction, and how often?
- What should be sent to devices: setpoints, recipes, start and stop? Who may
  send them, and should they need a confirmation?
- Are there recurring actions, for example a setpoint every shift or a
  nightly reset?
- Does the customer's team build flows or functions themselves, or should
  they be part of the project?
- How do the customer's systems authenticate: service accounts, a company
  directory, certificates?
