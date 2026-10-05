# 10. Simulators

*Nova Vector Platform · feature document 10 of 13 · October 2026 · for clients and sales engineers*

[← Feature overview](FEATURES.md)

Nova Vector Simulators behave like real equipment, down to the protocol.
The platform reads them exactly as it reads real devices, so it can be shown,
configured and tested before the hardware is available:

- **Demonstrations:** a live site with realistic data, alarms and production
  figures.
- **Pilots and projects:** adapters, alarms, dashboards and reports are set up
  and checked against simulated devices first.
- **Acceptance tests:** fault cases that are hard to create on real equipment,
  such as a cooling failure, a grid outage or a lost connection, run on
  demand.
- **Load tests:** many simulated edge nodes publish to the platform at once.

## Contents

- [How it works](#how-it-works)
- [Protocols](#protocols)
- [The reference systems](#the-reference-systems)
- [Scenarios and faults](#scenarios-and-faults)
- [The operator console](#the-operator-console)
- [Connecting to the platform](#connecting-to-the-platform)
- [Load, network and replay tests](#load-network-and-replay-tests)
- [Where it runs](#where-it-runs)
- [Current scope](#current-scope)
- [Questions to ask the customer](#questions-to-ask-the-customer)

---

## How it works

| Part | What it does |
| --- | --- |
| **System model** | One model for a whole system, for example a battery enclosure. It computes every value on each tick of its own model clock, so the devices influence each other as they would on site. |
| **Protocol simulators** | One simulator per protocol (Modbus, BACnet, SNMP, MQTT). Each presents its devices on the network, with the model's values, as real equipment would. |
| **Scenarios** | Scripted events in model time: set values, inject faults, check expected outcomes. |
| **Operator console** | A web page for each simulator, and one for the whole system, to watch and control it. |
| **Provisioning** | One command creates the matching devices, connections and seed data on the platform. |

**Model clock:** from 0.1 to 600 times real time. It can be paused and
stepped. An eight-hour shift runs in under a minute at the highest rate.

## Protocols

| Protocol | What is simulated |
| --- | --- |
| **Modbus TCP** | Devices and gateways: many unit IDs behind one address. Coils, discrete inputs, holding and input registers; 16-, 32- and 64-bit integers, floats and strings, with any word order and scaling. Exception codes, offline units and gateway timeouts. |
| **BACnet/IP** | Devices with analog, binary and multi-state inputs, outputs and values. Discovery (Who-Is/I-Am), reading single and multiple properties, writing with the 16 priority levels. Devices with and without segmentation support. |
| **SNMP** | Trap and inform sources in versions 1, 2c and 3, including authentication and encryption. Traps fire when a modelled value rises, falls or changes, or on a schedule. |
| **MQTT** | Edge nodes that publish their devices' readings to the platform in SenML, with the node's own credentials. From one node up to a fleet of nodes. |
| **OPC UA** | OPC UA adapters are tested against Microsoft's standard OPC UA test server (OPC PLC), which runs next to the simulators. |

![Modbus register map](images/10-simulators/modbus-register-map.png)
*The Modbus simulator of the battery enclosure: one listener with four units (inverter, battery management system, two sensors), and the inverter's register map with encodings, live values, raw words and quality.*

![BACnet objects](images/10-simulators/bacnet-objects.png)
*The BACnet simulator: the HVAC unit's objects with present values, units and priority arrays. Setpoints written by the platform appear here with their priority.*

## The reference systems

Three complete systems ship with the simulators, ready to use. Together they
have 47 devices and 22 scenarios.

### Battery energy storage enclosure

| Device | Protocol |
| --- | --- |
| Inverter (PCS) | Modbus, unit 1 |
| Battery management system | Modbus, unit 2 |
| Two temperature and humidity sensors (DL10) | Modbus, units 10 and 11 |
| HVAC unit | BACnet, device 1001 |
| Enclosure controller | SNMP v2c traps |
| UPS | SNMP v1 traps |
| Network switch | SNMP v3 traps |
| Edge node of the enclosure | MQTT, all devices every minute |

The model links the devices. For example, when the HVAC fails, the enclosure
heats up, the battery cells warm, and the heat-related values on every
device change with it. When the cells pass their limit, the battery
management system raises an over-temperature alarm and limits the power, and
the inverter follows that limit.

**Scenarios (8):** daily cycle, HVAC failure, grid outage, door open, setpoint
writes, communication loss, network impairment, and a load test against the
MQTT adapter.

![Devices of the battery enclosure](images/10-simulators/bess-devices.png)
*The ten devices of the battery enclosure in the system console, each with its protocol, state and faults.*

### Bottling line

Four machines (filler, capper, labeller, packer), three conveyors with
buffers, an energy meter, a hall sensor and an andon panel. The machines are
on Modbus and the andon sends SNMP traps.

- **Machine model:** states, cycle counts, scrap, speed. A stopped machine
  starves the machines after it and blocks the machines before it, through
  the conveyors.
- **Scenarios (6):** a full shift with breaks and two product changeovers, a
  breakdown, a changeover, micro-stops, speed writes, and a meter that sends
  stale and bad data.

![Bottling line](images/10-simulators/production-line.png)
*The bottling line: model time at 20 times real time, the groups of devices, and the six scenarios.*

### AI-server assembly line

Five assembly stations, a transport cart, a boot check, rack integration
(racks of eight servers), a rework bench and an andon panel: 26 devices.

- **Traceability:** each station reports on Modbus and sends trace events
  over MQTT: server and part serial numbers, the employee badge, and each
  step.
- **Scenarios (8):** a shift, a bad lot of GPUs with boot failures and
  rework, a parts shortage, a cart breakdown, a duplicate serial number,
  operator badges, an ESD humidity drop, and a communication loss.

![AI-server assembly line](images/10-simulators/assembly-line.png)
*The assembly line: six groups of devices (two sections, transport, traceability clients, parts pools, utilities) and eight scenarios.*

## Scenarios and faults

**A scenario** is a list of steps in model time. A step can:

- set or hold a value, for example the outside temperature or a setpoint
- inject a fault on a device or on one value
- trigger an event, or change the network (see below)
- check an expected outcome, for example "the enclosure is above 28 °C"

**Results:** the console shows how many expectations were met and how many
were not. Expectations are checked against the simulated system.

**Faults** can also be injected by hand, on a whole device or on one value,
with an optional duration:

- offline, slow responses, protocol error codes
- stale values, uncertain or bad quality
- noise, drift, dropped messages

**Lab run: HVAC failure.** The *hvac-failure* scenario of the battery
enclosure was run at 10 times real time:

1. The HVAC compressor failed five minutes into the scenario, seen on BACnet
   and as an SNMP trap.
2. The enclosure heated up. The platform recorded the sensor's temperature
   rising from about 24 °C to 31 °C, and the humidity falling.
3. After the repair at 35 minutes, the temperature fell back.

The scenario met 9 of its 11 expectations. The other two expected a hard
charge, but the battery was already full after weeks of model time, so its
power was limited to 25 kW. The result showed this at a glance.

![Scenario results](images/10-simulators/scenario-results.png)
*The battery enclosure's scenarios after the lab run: hvac-failure with 9 expectations met and 2 not met, grid outage with 11 met and 1 not met.*

![The HVAC failure on the platform](images/10-simulators/platform-hvac-failure.png)
*The same run on the platform: an enclosure sensor's temperature (yellow) rising to about 31 °C while the HVAC was down, around 7:12 PM, and the humidity (blue) falling. The platform read the sensor over Modbus, as it would read a real one.*

## The operator console

Every simulator has its own web console, and each system has a console that
combines them, with a tab per simulator:

- **System:** the model clock (rate, pause, step), the device groups and the
  scenarios with their results.
- **Devices:** every device with its protocol, state and faults.
- **Device detail:** live values with their quality, set, hold and release of
  any value, fault injection, and a log of the protocol requests the device
  received from the platform.
- **Events and faults:** a live event stream and the active faults.
- **Protocol pages:**
  - Modbus: listeners and register maps.
  - BACnet: objects and priority arrays.
  - SNMP: traps, with manual sending and schedules.
  - MQTT: nodes and load operations.

![Device detail](images/10-simulators/device-detail.png)
*The HVAC unit in the console: live values with quality and source, set and hold for each value, the fault form, and the request log.*

![SNMP traps](images/10-simulators/snmp-traps.png)
*The SNMP simulator: the enclosure controller's traps with their triggers (for example "door_open rises"), schedules and counters.*

## Connecting to the platform

One command per system prepares the platform for it, through the
platform's own interfaces:

- devices, channels and device profiles
- the protocol adapter configurations: Modbus connections and points,
  BACnet connections and bindings, SNMP receivers and bindings, MQTT edge
  nodes
- alarms with task templates, task categories and sample tasks
- a [Process Simulator](05-process-simulator.md) process for the system
- for the two lines: production master data for
  [Manufacturing operations](06-manufacturing-operations.md): an
  organization, positions, people with RFID badges, products, materials,
  recipes, routings, work orders, shifts, shift plans for a week, and KPIs

**Group:** everything is created in a group chosen for the run, so several
demonstrations can share one installation.

**Removal:** another command removes what the first one created. Shared
lists (document types, statuses, shifts, task categories) and the group
remain.

## Load, network and replay tests

- **Load:** the MQTT simulator runs fleets of edge nodes, each with its own
  credentials. It can ramp them up, send bursts and storms, and make them
  all reconnect at once. It reports what was sent and the publish times.
- **Network impairment:** latency, jitter, packet loss and a full partition
  between a simulator and the platform, by hand or as a scenario step. This
  needs a Linux host.
- **Record and replay:** MQTT traffic can be recorded and replayed.

![MQTT nodes](images/10-simulators/mqtt-nodes.png)
*The MQTT simulator: the enclosure's edge node publishing its seven devices every minute, and the load operations (ramp, burst, storm, reconnect storm).*

## Where it runs

- **Docker:** each simulator is a small container image. Each system is one
  Docker Compose stack.
- **Next to the platform:** on the same machine, for example a laptop for a
  demonstration.
- **On a separate machine:** a Linux virtual machine on its own network,
  closer to a real site, where the network can also be impaired.
- **On an edge node:** each system can be packaged as an
  [Edge management](07-edge-management.md) bundle.

## Current scope

This list gives sales engineers the current boundaries, so a proposal
matches what the platform delivers today.

- **Security:** the consoles and control interfaces have no login. Run the
  simulators on a trusted network, separate from production systems. By
  default their ports are open on all network interfaces of the host.
- **Protocols:**
  - Modbus TCP only (no RTU, no TLS).
  - BACnet without change-of-value subscriptions, BBMD routing or MS/TP.
  - SNMP simulates trap and inform sources; it does not answer polling.
  - MQTT publishes SenML. Sparkplug B output is partial, and the platform
    does not read Sparkplug B yet.
  - OPC UA uses the standard test server, outside the modelled systems.
- **Scenarios:**
  - Expectations are checked in the simulated system, not on the platform.
  - The console shows how many expectations were met, not which ones; only
    the latest run is kept.
  - Three of the 22 scenarios have no expectations.
  - A system that has run for a long time drifts away from its starting
    point (for example, a full battery). Reloading the system restarts its
    model from the beginning before an important demonstration.
- **The HVAC example:** in the shipped scenario, the HVAC is repaired before
  the cells reach their alarm limit. The over-temperature alarm and the
  power limit are in the model, but this scenario does not reach them yet.
- **Groups:** removing a system's objects from one group can also remove the
  same system's objects in another group. Until this is fixed, a system
  should be provisioned in one group per installation.
- **Load tests:** fleets of MQTT nodes are supported; runs with hundreds or
  thousands of nodes have not been measured yet.
- **Edge nodes:** the systems are packaged for edge nodes, but not yet rolled
  out to one in a test.
- **Images:** published as development versions.

## Questions to ask the customer

- Which devices and protocols does the site have? Are register maps, object
  lists or MIBs available?
- What should the simulation be used for: a demonstration, a pilot, an
  acceptance test, a load test?
- Which failures matter most, and which should be shown or tested?
- Should a model of the customer's own system be built, or is a reference
  system close enough?
- Where would the simulators run, and on which network?
- How many devices and sites should a load test represent?
