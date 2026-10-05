# 2. Devices and Live Data

*Nova Vector Platform · feature document 2 of 13 · October 2026 · for clients and sales engineers*

[← Feature overview](FEATURES.md)

Every machine, meter, sensor, controller and edge node is registered once in
the device registry. Each device has an owner group, a place in a hierarchy
and, usually, a profile that describes its type. Its readings are stored as a
time series and shown live on the device's own page. The same data then
drives dashboards, alerts, reports, production tracking and the AI Assistant.

This document covers the device registry, the device page, channels, device
profiles and how data is stored.

## Contents

- [The device registry](#the-device-registry)
- [The device list](#the-device-list)
- [Adding and editing devices](#adding-and-editing-devices)
- [The device page](#the-device-page)
- [Device Data: charts and tables](#device-data-charts-and-tables)
- [Channels](#channels)
- [Profiles: device types](#profiles-device-types)
- [Data storage and access](#data-storage-and-access)
- [Current scope](#current-scope)
- [Questions to ask the customer](#questions-to-ask-the-customer)

---

## The device registry

A device record holds:

- **Name and group:** the group owns the device. Users see and change only
  the devices of their own groups.
- **Parent:** the device it belongs to, such as a line, an enclosure or an
  edge node. Parent links build the hierarchy shown in the tree view and the
  *Components* list on each device.
- **Profile:** the device type, with its version (see
  [Profiles](#profiles-device-types)).
- **Status:** Normal, Notification, Warning, Error or NoData. Alert limits set
  the status automatically as readings arrive (see
  [Alerts, notifications and tasks](FEATURES.md#4-alerts-notifications-and-tasks)).
  It can also be set by hand.
- **Enable data:** marks the device as enabled or disabled, without deleting
  it (see [Current scope](#current-scope)).
- **Device ID and key:** the identity and password the device uses to send
  data (see [Device Connectivity](01-device-connectivity.md#examples-sending-and-receiving-data)).
- **Metadata:** free-form attributes, plus the values of the profile's custom
  fields.

Devices are created in three ways:

- by hand on the Devices page
- through the API, one at a time or in bulk
- automatically by the industrial connections: BACnet discovery and SNMP
  learn mode create one device per controller or trap sender (see
  [Device Connectivity](01-device-connectivity.md#industrial-equipment))

## The device list

The **Devices** page lists all devices, in a table or as a tree.

- **Table view:** name, parent, enabled, status, group, created by and
  created at. Every column can be sorted and filtered. The filters are kept
  while the user works, and *Clear filters* resets them.
- **Tree view:** devices under their parents, with a search box, *Expand all*
  and *Collapse all*, and a child count on each parent. The choice of table or
  tree is remembered.
- **CSV export:** exports the full device list to a CSV file.

![Devices in the table view](images/02-devices-and-live-data/devices-table.png)
*The table view. Each column has a filter and a sort, and the Status column shows each device's current state.*

![Devices in the tree view](images/02-devices-and-live-data/devices-tree.png)
*The tree view shows every device under its line or process, with its current status.*

## Adding and editing devices

**Add a device:** enter a name and choose the group. The data and status
switches can be set straight away. *Enable planning* makes the device
available in Marketing plans.

**Edit a device:** the edit page also sets the parent and the profile. The
profile list shows each profile with its version, for example
`line-machine-plc (v1)`.

**Profile Data:** a profile can define custom fields for its devices, such as
a serial number, an installation date or a rated power. They appear on the
device's *Profile Data* tab, with default values taken from the profile.

**Device key:** the key is shown on the *Details* tab and can be changed with
*Edit key*.

![Editing a device](images/02-devices-and-live-data/device-edit.png)
*Editing a device: group, parent and profile with its version. The Profile Data tab holds the custom fields that the profile defines.*

## The device page

Each device has one page with these tabs:

| Tab | What it shows |
| --- | --- |
| **Device Data** | Charts and a table of the device's readings, live and historical |
| **Details** | All device fields, the device ID and key, the profile data and the device's components |
| **Connections** | The channels the device publishes to; channels can be connected and disconnected here |
| **Real-time Messages** | Messages as they arrive, shown as a table of readings or as raw JSON |
| **Alerts** | The alerts and KPIs linked to the device, with their current state |
| **Jobs** | Scheduled jobs that involve the device |
| **Metadata** | The device's metadata, read-only |

![Device details](images/02-devices-and-live-data/device-details.png)
*The Details tab of a filling machine: type, profile and version, group, status and parent, with the device ID and key on the right.*

## Device Data: charts and tables

The *Device Data* tab charts every reading of the device, and lists the
readings in a table below the chart.

- **Date range:** presets from 1 minute to 30 days. Each device can choose
  which presets appear in its toolbar.
- **Real time:** new readings appear as they arrive. Polling at a chosen rate
  takes over if the live link is not available. The chart can be paused and
  refreshed on demand.
- **Zoom:** with the mouse wheel or the slider under the chart.
- **Filters:** by channel, subtopic and metric. When a device has more than
  ten series, a dialog picks which to show.
- **Chart types:** line or area (smooth or straight), step, scatter and bar.
  A min/max band shows the range of values inside each time bucket.
- **Series appearance:** colour, marker and size for each series.
- **Exports:**
  - the chart as a PNG image
  - the current table page as CSV
  - a PDF report with device details, the date range, the chart and the table
- **Saved per device:** the settings are stored with the device. Everyone who
  opens it sees the same view.
- **Grafana view:** a switch shows embedded Grafana panels for the device
  instead.

![Live data of one device](images/02-devices-and-live-data/device-live-data.png)
*The last hour of an HVAC unit's data: five series in the chart, and the latest readings in the table below.*

![Device Data settings](images/02-devices-and-live-data/device-data-settings.png)
*The settings panel: data filters, date-range presets, seven chart types, the min/max band, the number of points per series, and the colour and marker of each series.*

## Channels

A **channel** is a stream of messages. Devices publish to it, and
applications subscribe to it. Each device normally has its own channel, and
the industrial connections create one automatically.

- **Fields:** name, group, enabled, anonymous access, status, parent, profile
  and metadata. The list shows each channel's ID, which devices need in order
  to publish (see
  [Device Connectivity](01-device-connectivity.md#examples-sending-and-receiving-data)).
- **Channel page:** *Channel Data* (the same chart and table as Device Data,
  with each row labelled by device), *Details*, *Connections*, *Alerts* and
  *Metadata*.

![Channels](images/02-devices-and-live-data/channels.png)
*The channel list with IDs, enabled and anonymous flags, and owner groups.*

## Profiles: device types

A **profile** describes a device type once, so that every device of that type
reuses it. A profile holds:

- **Metrics:** the values the device reports. Each metric has a name, a
  display name, a unit and a data type (number, boolean, text or binary). It
  can also have a valid range, a resolution and a sampling interval.
- **Registers:** the default address of each metric, for each industrial
  protocol, with scale and offset. The Modbus, BACnet and OPC UA connections
  use them to generate their bindings for a device of this type, so the
  register map is entered only once (see
  [Device Connectivity](01-device-connectivity.md#industrial-equipment)).
- **Report-by-exception defaults:** publish-on-change, deadband and heartbeat
  for the whole profile, or for each metric.
- **Decoder:** a script that turns the device's own payload format into
  standard readings (see
  [Payload decoders](01-device-connectivity.md#payload-decoders)).
- **UI template and metadata model:** the custom fields for each device, and
  their default values.
- **Type, tags, properties, version and lifecycle status:** described below.

The profile page has tabs for Details, Properties, Metrics, Versions, Decoder,
UI Template, Metadata Model and Things. The Things tab lists every device that
uses the profile.

![Profile details](images/02-devices-and-live-data/profile-details.png)
*A profile's Details tab: group, version, lifecycle status with the allowed next states, and tags.*

![Profile metrics](images/02-devices-and-live-data/profile-metrics.png)
*The metrics of the PLC profile shared by the four machines of a bottling line. Each metric has a unit and a data type, a publish-on-change setting, and a Modbus register mapping.*

![A profile decoder](images/02-devices-and-live-data/profile-decoder.png)
*The Decoder tab of the profile for EdgeX edge nodes. The script turns each EdgeX reading into a standard reading.*

### Profile Catalog

The **Profile Catalog** helps users find the right profile. Facets on the left
filter by type, protocol, lifecycle status and tag, each with a count. A
search box finds profiles by name. Each row shows the profile's name, type,
version, status and tags, and opens the profile.

![Profile Catalog](images/02-devices-and-live-data/profile-catalog.png)
*The Profile Catalog, with type, protocol, status and tag facets on the left.*

### Versions

A device type changes over time: new firmware adds registers, or a vendor
changes a scaling. Profiles handle this with versions.

- **Fork new version:** copies the profile with its metrics and registers into
  the next version, which starts as a draft.
- **Restore:** forks a new version from an older one.
- **Side by side:** each version is a complete, independent definition, and
  several versions can be in use at the same time. A device stays on the
  version it was assigned until a user moves it, so devices on older firmware
  keep working.

![Profile versions](images/02-devices-and-live-data/profile-versions.png)
*The Versions tab, with Fork new version. Each version is an independent definition.*

### Lifecycle workflow

Each profile version has a lifecycle status. The default workflow runs
Draft → In Lab Test → Approved → In Production → Deprecated. A version can
also step back to Draft from In Lab Test, Approved or Deprecated.

- **Custom workflows:** each group can define its own states and transitions
  on the Lifecycle Workflow page. Exactly one state is the starting state.
- **Required roles:** each transition can require a role, for example a
  profile approver.
- **Changing status:** the profile page offers only the transitions the
  workflow allows from the current state.

![Lifecycle workflow](images/02-devices-and-live-data/lifecycle-workflow.png)
*The lifecycle workflow of one group: five states, and the transitions between them with the role each one requires.*

### Profile types and properties

**Profile types** group profiles, for example *edge*, *meter* or *inverter*.

**Profile properties** are type-level attributes, such as a rated power, a
hardware generation or a certification. Each property is defined once, for
one profile type or for all types, with:

- a key and a label
- a data type: text, integer, decimal, true/false, or a list of allowed values
- whether it is required, a unit and a default value
- where it appears: on the Details tab or the Properties tab of the profile

Values are checked when they are saved: numbers must be numbers, list values
must be on the list, and required properties must have a value. Property
values belong to the profile, which means the device type. Per-device values
use the profile's custom fields (see
[Adding and editing devices](#adding-and-editing-devices)).

![Adding a profile property](images/02-devices-and-live-data/profile-property.png)
*Adding a profile property of the list type. The allowed values are entered as a comma-separated list.*

### Import and export

Profiles move between installations as files.

- **Export:** one profile version is exported as a JSON file with its metrics
  and registers. Several profiles at once go into a ZIP file.
- **Import:** a JSON or ZIP file can be imported. When a profile with the same
  name already exists, the import can skip it, add the file as a new version,
  or create a copy. Each file gets a result: created, updated, skipped or
  failed.
- **After import:** imported profiles start as drafts, and missing profile
  types are created. Every file is checked first, so a bad file creates
  nothing.

![Profiles list](images/02-devices-and-live-data/profiles.png)
*The profiles list, with buttons for the catalog, the lifecycle workflow, import and export.*

## Data storage and access

- **Time series:** every reading is stored in a time-series database
  (TimescaleDB) with its device, channel, subtopic, name, unit and time. Values
  can be numbers, text, true/false or binary data. The latest value of every
  reading is also kept separately, for fast access.
- **Compression:** data older than seven days is compressed automatically.
  By default, data is kept indefinitely.
- **Data API:** applications and reports read the data through a REST API.
  Queries filter by time range, device, channel, subtopic, name, protocol and
  unit. Chart queries return time buckets with average, minimum, maximum and
  count, sized automatically to the number of points wanted.

## Current scope

This list gives sales engineers the current boundaries, so a proposal matches
what the platform delivers today.

- **Device Data:**
  - The chart offers preset ranges up to 30 days, with no custom date range.
    Older data is available through the data API and reports.
  - The CSV download exports the current page of the table only.
- **Device list:**
  - The page handles up to 10,000 devices per user.
  - The CSV export includes device keys. Treat the file as confidential.
- **Bulk device creation:** through the API, or through BACnet discovery and
  SNMP learn mode. There is no spreadsheet import screen for devices yet.
- **File import of readings:** reading historical data from CSV, JSON, XML or
  Excel files is not available as a general feature yet.
- **Key changes and disabling:** changing a device key, or switching off
  *Enable data*, does not yet cut off a device that has already connected with
  the old key. The Modbus, BACnet and OPC UA connections use their own on/off
  switches instead (see
  [Device Connectivity](01-device-connectivity.md#common-to-all-connections)).
- **Lifecycle status:** the status documents the approval process. It does
  not yet stop a deprecated version from being assigned to a device, or an
  in-production version from being edited.
- **Profile versions:**
  - Versions cannot be compared side by side.
  - A fork does not copy the property values.
  - Export and import do not carry the publish-on-change settings.
- **Data quality:** readings do not yet carry a good, uncertain or bad
  quality flag.
- **Data retention:** no retention period is set by default. One can be
  agreed and configured for each installation.

## Questions to ask the customer

- How many devices are there per site, and in total? How are they organized:
  site, area, line, machine?
- Which device types are there, and which attributes matter for each, such as
  serial number, installation date, rated power or location?
- Who approves a new device type or firmware version before it goes into
  production?
- How long must raw data be kept, and must older data be deleted at some
  point?
- Which views and exports do operators and managers need, and who needs PDF
  reports?
- Is historical data from existing systems to be brought into the platform?
