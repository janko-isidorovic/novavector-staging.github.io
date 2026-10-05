# 3. Dashboards and Reports

*Nova Vector Platform · feature document 3 of 13 · October 2026 · for clients and sales engineers*

[← Feature overview](FEATURES.md)

Nova Vector shows data at two levels:

- **Built-in views:** every device and channel has its own charts and tables,
  with PDF export (see [Devices and Live Data](02-devices-and-live-data.md#device-data-charts-and-tables)).
- **Dashboards and reports:** these are built with Grafana, which is part of
  the platform. Users reach them from the platform menu with the same single
  sign-on, and they read the same time-series data. This covers the home
  dashboard, the default dashboards for devices, channels, KPIs, alerts and
  tasks, and each project's own reports.

This document describes the home dashboard, Grafana inside the platform, the
built-in dashboards, the report list, and the reports Nova Vector builds for
a project.

## Contents

- [The home dashboard](#the-home-dashboard)
- [Grafana inside the platform](#grafana-inside-the-platform)
- [Built-in dashboards](#built-in-dashboards)
- [The report list](#the-report-list)
- [Reports built for each project](#reports-built-for-each-project)
- [Other report outputs](#other-report-outputs)
- [Current scope](#current-scope)
- [Questions to ask the customer](#questions-to-ask-the-customer)

---

## The home dashboard

The home dashboard is the first page after sign-in. It gives an overview of
the whole installation:

- **Messages per hour**, for each protocol
- **Messages per protocol** in the last hour
- **Location map** of the sites and devices that have a location
- **Totals:** devices, channels, connections, LoRaWAN devices, EdgeX gateways
  and alerts
- **Top 10 channels** in the last hour, by number of messages

The dashboard refreshes every 10 seconds and shows the last 6 hours by
default. An administrator can give a user a different home dashboard, for
example a plant overview for a plant manager.

![Home dashboard](images/03-dashboards-and-reports/home-dashboard.png)
*The home dashboard of the demo installation. Message rates per protocol, totals, the site map and the busiest channels.*

## Grafana inside the platform

- **Single sign-on:** users sign in to the platform once and are signed in to
  Grafana too. Their platform role sets their Grafana role: viewer, editor or
  administrator.
- **Embedded:** dashboards and reports open inside the platform pages, so
  users do not switch tools.
- **Data sources:** Grafana reads the platform's time-series database, so
  every stored reading is available to dashboards. It also reads the
  platform's system metrics.
- **Dashboard editor:** editors and administrators open the full Grafana
  editor from *Administration → Grafana*. There they build new dashboards with
  any of Grafana's charts, tables, gauges and maps.
- **Panel images:** a rendering service turns any panel into a PNG image, for
  sharing or embedding.

![Grafana dashboards](images/03-dashboards-and-reports/grafana-dashboards.png)
*The Nova Vector dashboard folder in Grafana, with the default dashboards that ship with the platform.*

## Built-in dashboards

The platform ships a set of default dashboards. The platform's own pages
open them for a specific device, channel, KPI, alert or task.

| Dashboard | What it shows | Where it opens |
| --- | --- | --- |
| **Homepage** | The installation overview described above | Home |
| **Things (devices)** | A chart and a table of one device's readings | Device page, in Grafana view |
| **Channels** | A chart and a table of one channel's readings | Channel page, in Grafana view |
| **KPI** | The readings behind one KPI | KPI page |
| **Alerts** | The readings behind one alert | Alert page |
| **Tasks** | Number of tasks per category and reason code; task history | Task pages |
| **Channels for EdgeX, LoRaWAN and OPC UA** | Variants of the channel dashboard for these channel types | Grafana |
| **Thing location** | Devices on a map | Grafana |
| **Server overview** | CPU, memory and disk of the platform server | Grafana |

![A device in Grafana view](images/03-dashboards-and-reports/device-dashboard.png)
*The default device dashboard for an HVAC unit: all of its readings over the last hour, with the raw readings in the table below.*

## The report list

**Reporting** in the main menu lists the reports a user may open. A report is
a Grafana dashboard with a name and an owner group.

- **Who sees what:** each user sees only the reports owned by their groups.
  For example, a production manager sees the line reports and an energy
  manager sees the enclosure reports.
- **Viewing:** a report opens full page inside the platform, in Grafana's
  presentation mode, with the time range and filters stored in the report.
- **Adding reports:** administrators add, change and remove reports under
  *Administration → Reports Admin*. A report needs a name, the address of a
  Grafana dashboard and an owner group.

![The report list](images/03-dashboards-and-reports/reports-list.png)
*The report list with two reports, each owned by a different group.*

![A report](images/03-dashboards-and-reports/report-view.png)
*A report opened from the list: the energy meter of a production line over the last six hours.*

![Adding a report](images/03-dashboards-and-reports/reports-admin.png)
*Adding a report under Reports Admin: a name, the dashboard address and the owner group.*

## Reports built for each project

Every operation measures performance a little differently, so Nova Vector
builds the management reports for each project. They are Grafana dashboards
on top of the platform's own data, adapted to the customer's process. Typical
reports are:

| Report | What it answers | Platform data it uses |
| --- | --- | --- |
| **Plan attainment** | Is actual output on track for the shift, week and month? | Production plans, work orders and produced quantities from line data |
| **Downtime analysis** | How many stoppages, how long, on which machine and line, and for what reason? | Stoppages with reason codes, machine states |
| **Equipment reliability** | How fast are breakdowns repaired (MTTR), and how long do machines run between failures (MTBF)? | Stoppages, machine states, maintenance tasks with their durations |
| **Team performance** | How busy and how efficient are operator and maintenance teams? | RFID badge presence, tasks, stoppages and plans (needs RFID readers) |
| **Energy and utilities** | How much energy does each line, machine or product use? | Meter readings, production records |

The data behind these reports is collected by the platform's own modules (see
[Manufacturing operations](FEATURES.md#6-manufacturing-operations) and
[Alerts, notifications and tasks](FEATURES.md#4-alerts-notifications-and-tasks)).
Each report then becomes a dashboard in the report list, visible to the
groups that need it.

## Other report outputs

- **Device and channel reports:** the Device Data view exports a PDF report
  with the device details, the chart and the readings, as well as PNG and CSV
  files (see [Devices and Live Data](02-devices-and-live-data.md#device-data-charts-and-tables)).
- **Shift reports:** a production plan exports a PDF of the previous shift,
  with its production table and its stoppage table. Each plan also shows a
  timeline of production and stoppages (see
  [Manufacturing operations](FEATURES.md#6-manufacturing-operations)).
- **CSV exports:** lists such as devices, channels, alerts and tasks export to
  CSV.

## Current scope

This list gives sales engineers the current boundaries, so a proposal matches
what the platform delivers today.

- **Management reports:** plan attainment, OEE, downtime, MTTR/MTBF and team
  reports do not ship as ready-made dashboards. They are built for each
  project, as described above. The only one that ships is the task dashboard
  with task counts per category and reason code.
- **Scheduled reports:** reports are not yet sent by e-mail on a schedule, and
  Grafana reports have no PDF download button in the platform.
- **Separation inside Grafana:**
  - The report list is filtered by group, but Grafana itself runs as one
    organization. A user who can open Grafana directly can open any of its
    dashboards.
  - The totals on the default home dashboard cover the whole installation,
    not just the user's groups.
  - Installations that must keep customers or sites apart inside Grafana need
    per-group dashboards and permissions set up for the project.
- **Home dashboard:** an administrator assigns it. Users cannot yet choose or
  rearrange their own home page.
- **Location map:** the device location dashboard needs a map-tile provider
  key. Without one, its map is empty.

## Questions to ask the customer

- Which reports do managers use today: plan attainment, OEE, downtime,
  MTTR/MTBF, energy, team performance? Who reads each one, and how often?
- How is each KPI calculated today: shift boundaries, planned stops, ideal
  cycle times?
- Must different customers, sites or departments be kept apart inside the
  reports?
- How should reports be distributed: on screen, as PDF, or by e-mail on a
  schedule?
- Do other BI tools, such as Power BI or Excel, also need the data?
