# 1. Device Connectivity

*Nova Vector Platform · feature document 1 of 13 · October 2026 · for clients and sales engineers*

[← Feature overview](FEATURES.md)

Nova Vector takes data from the equipment a site already has. It reads PLCs,
energy meters, inverters, battery systems and building controllers directly,
over their own industrial protocols. It also accepts data that IoT devices,
gateways and edge nodes send to it. All data ends up in one common format, so
dashboards, alerts, reports and production records work the same way whatever
the source.

This document describes each protocol, how a device is connected, and what is
common to all connections.

## Contents

- [Protocols at a glance](#protocols-at-a-glance)
- [How a device connects](#how-a-device-connects)
- [Industrial equipment](#industrial-equipment): Modbus TCP, BACnet/IP, OPC UA, SNMP traps
- [IoT devices and gateways](#iot-devices-and-gateways): MQTT, HTTP, WebSocket, CoAP, LoRaWAN
- [Examples: sending and receiving data](#examples-sending-and-receiving-data): curl and mosquitto on Ubuntu and Windows
- [Payload decoders](#payload-decoders)
- [Data from edge nodes](#data-from-edge-nodes)
- [Common to all connections](#common-to-all-connections)
- [Current scope](#current-scope)
- [Questions to ask the customer](#questions-to-ask-the-customer)

---

## Protocols at a glance

For industrial equipment, the platform opens the connection and collects the
data itself.

| Protocol | Typical equipment | How data is collected | Writes from the platform |
| --- | --- | --- | --- |
| **Modbus TCP** | PLCs, energy meters, inverters, battery systems, Modbus gateways | The platform polls registers at a set rate | Coils and holding registers |
| **BACnet/IP** | HVAC units, building and room controllers | The platform polls objects at a set rate | Analog objects |
| **OPC UA** | PLCs, SCADA and machine servers | The server reports changes through a subscription | Through the API |
| **SNMP v1, v2c, v3** | Network switches, UPS units, enclosure and IT controllers | The device sends traps and informs | No |

IoT devices send data to the platform on their own.

| Protocol | Typical use | How the device signs in | Availability |
| --- | --- | --- | --- |
| **MQTT** | Sensors, gateways, edge nodes | Device ID and device key | Available |
| **HTTP** | Devices and applications that post readings | Device key | Available |
| **WebSocket** | Web applications and two-way device links | Device key | Available |
| **CoAP** | Small, battery-powered devices | Device key | Pilot |
| **LoRaWAN** | Long-range, low-power sensors | Through the LoRaWAN network server | Pilot |

The **Protocol Catalog** lists every protocol the platform offers, and whether
it is polled by the platform or pushed by the device. Administrators can switch
a protocol off, or clone one to adjust it for a single group.

![Protocol Catalog](images/01-device-connectivity/protocol-catalog.png)
*The Protocol Catalog. Modbus TCP, BACnet/IP and OPC UA are polled by the platform. HTTP, MQTT, CoAP, WebSocket, LoRaWAN and SNMP traps are pushed by the devices.*

## How a device connects

Four building blocks appear on every connectivity screen. Some screens call a
device a *Thing*.

- **Device:** anything that produces data, such as a machine, meter, sensor,
  controller or edge node. Each device is registered once, with an owner group
  and a place in the device hierarchy.
- **Channel:** the stream a device publishes its data to. Each device normally
  has its own channel, and the industrial connections set this up
  automatically.
- **Profile:** a description of a device type. It holds the register or object
  map, units and decoder that every device of that type reuses.
- **Connection:** for industrial protocols, the link from the platform to a
  controller or gateway. One connection serves every device behind that
  gateway.

Every reading is stored in the same standard measurement format, SenML. Each
reading carries a name, a value, a unit and a timestamp.

## Industrial equipment

### Modbus TCP

The platform connects to a Modbus TCP device or gateway. It reads the
configured registers at a set rate and publishes each value under the right
device.

- **One connection, many devices:** a gateway serves many devices through
  their Modbus unit IDs. The unit ID is set on each register binding, so one
  connection can feed a whole line or enclosure.
- **Register map:** each value is defined by register type (coil, discrete
  input, holding or input register) and address. It also has a data type:
  16, 32 and 64-bit integers, 32 and 64-bit floating point, boolean or
  string.
- **Word order:** all four word orders are supported (ABCD, CDAB, DCBA,
  BADC), so 32 and 64-bit values from any vendor read correctly.
- **Scaling:** scale factor, offset and engineering unit per value.
- **Poll rate:** set per connection, and changeable per value. A "Read now"
  button reads all values on demand.
- **Writes:** coils and holding registers can be written from the register
  map, for example a setpoint or a start/stop command. Scaling is applied in
  reverse, so the user enters the engineering value.
- **From a profile:** the register map can be generated from a device
  profile, so devices of the same type share one definition.
- **Health:** each connection shows whether the device is reachable, with the
  last error. A reachability signal per device can drive an alert.

![A Modbus connection serving nine devices](images/01-device-connectivity/modbus-gateway.png)
*One Modbus connection serving the nine devices of a production line. The connection shows its poll interval, timeouts and reachability, and each device can be switched off on its own.*

![Modbus register map](images/01-device-connectivity/modbus-register-map.png)
*The register map of a battery inverter. Each row shows the register, data type, word order, unit, poll rate and last value. Holding registers and coils have a Write box.*

![Modbus connections](images/01-device-connectivity/modbus-connections.png)
*Three Modbus connections, each serving a different system: an assembly line, a production line and a battery enclosure.*

### BACnet/IP

The platform joins the BACnet/IP network as a BACnet device. It finds the
controllers on the network and reads their objects at a set rate.

- **Device discovery:** a Who-Is broadcast finds the BACnet devices on the
  network, optionally limited to a range of device instances. The user picks
  which devices to add, and each one becomes its own device on the platform.
  It publishes to a shared channel or to a channel of its own.
- **Object discovery:** the platform reads a device's object list, with object
  names and present values if wanted. Objects can then be bound one at a
  time, or many at once.
- **Objects:** analog, binary and multi-state inputs, outputs and values. The
  platform reads the present value, status flags and units.
- **Poll rate:** set per object, with optional scaling.
- **Writes:** the present value of analog objects, for example a cooling
  setpoint.
- **From a profile:** object bindings can be generated from a device profile.

![BACnet device discovery](images/01-device-connectivity/bacnet-device-discovery.png)
*Step 1 of adding BACnet devices. A Who-Is broadcast has found one controller, and the user picks a channel strategy and a name for it.*

![BACnet object discovery](images/01-device-connectivity/bacnet-object-discovery.png)
*Objects discovered on an HVAC controller, with names and live values. Selected objects can be bound in bulk, with a poll rate and optional publish-on-change.*

### OPC UA

The platform connects to an OPC UA server as a client. It subscribes to the
variables a user selects, and the server reports each change.

- **Security:** security mode None, Sign, or Sign and Encrypt, with the
  Basic256 and Basic256Sha256 policies. Sign-in is anonymous or with user name
  and password. Certificate sign-in is available through the API.
- **Browse:** the user browses the server's address space and subscribes to
  the variables they need, one at a time or in batches.
- **Subscriptions:** publishing interval, sampling interval and queue size are
  set per connection and per variable.
- **Change filter:** an absolute or percentage deadband filters out small
  changes at the server, before they reach the network.
- **Data quality:** only readings the server marks as good are stored.
- **Writes and method calls:** available through the API.
- **Channels:** variables publish to a shared channel or to one channel per
  device.

![Adding an OPC UA connection](images/01-device-connectivity/opcua-connection.png)
*Adding an OPC UA connection: server address, publishing interval, security mode, security policy and sign-in method.*

### SNMP traps

The platform runs SNMP trap receivers. Network switches, UPS units, enclosure
controllers and other equipment send their traps and informs to it.

- **Versions:** SNMP v1 and v2c traps, v2c informs, and v3 traps and informs.
- **SNMP v3 security:** user-based security with authentication (MD5, SHA,
  SHA-224, SHA-256, SHA-384, SHA-512) and privacy (DES, AES-128, AES-192,
  AES-256). Informs are confirmed only after the sender has been
  authenticated.
- **Source allowlist:** a receiver accepts traps only from the listed address
  ranges.
- **Learn mode:** traps from unknown senders are kept for 72 hours. A sender
  can then be added as a device in one click. Each sender becomes its own
  device with its own channel.
- **Status:** each receiver and each device shows its trap count and the last
  trap received.

![SNMP trap receivers](images/01-device-connectivity/snmp-receivers.png)
*Five trap receivers covering SNMP v1, v2c and v3, with their security setting, learn mode, trap count and last trap.*

![SNMP v3 receiver settings](images/01-device-connectivity/snmp-v3-receiver.png)
*An SNMP v3 receiver with SHA-256 authentication and AES privacy, a source allowlist and learn mode. Keys can be set, but they are never shown again.*

## IoT devices and gateways

### MQTT

Devices publish to the platform's MQTT endpoint. Each device signs in with its
device ID and device key. It can publish only to the channels it is connected
to. The topic is the channel, optionally followed by a subtopic, such as
`<channel>/temperature`.

- **Broker:** the platform's own MQTT broker, behind an authentication layer.
  Messages of up to 1 MB are accepted.
- **Encryption:** MQTT over TLS can be enabled on port 8883 for each
  installation.
- **Typical senders:** sensors, gateways, and the platform's own edge nodes.

### HTTP

Devices and applications post readings over HTTPS to the channel's address.
The device key goes in the request header.

### WebSocket

A device or a web application opens a WebSocket to a channel and signs in with
its device key. It can publish readings and subscribe to the channel's live
data on the same link.

### CoAP (pilot)

CoAP suits small, battery-powered devices. Devices post readings and can
observe a channel to receive updates, signing in with their device key. Plain
CoAP and DTLS-secured CoAP are available as a pilot.

### LoRaWAN (pilot)

Long-range, low-power sensors connect through a ChirpStack LoRaWAN network
server that runs alongside the platform. The platform maps each LoRaWAN device
to a platform device, and each LoRaWAN application to a channel. It then
decodes the payloads. The EU868 band is configured by default. The LoRa Network
pages list LoRaWAN devices, channels, gateways and network servers.

## Examples: sending and receiving data

These examples send readings to the platform over HTTP and MQTT, and
subscribe to a channel over MQTT. They use `curl` and the Mosquitto command
line clients on Ubuntu and on Windows.

### What you need

| Value | Where to find it | Used as |
| --- | --- | --- |
| Platform address | From the platform administrator, for example `platform.example.com` | Host name |
| Device ID | Device page → **Details** → *Thing ID* | MQTT user name |
| Device key | Device page → **Details** → *Thing Key* | HTTP `Authorization` header, MQTT password |
| Channel ID | Channel page → **Details** → *ID* | HTTP path, MQTT topic |

The device must be connected to the channel (device page → **Connections**).
A device can publish and subscribe only on channels it is connected to.

![Device ID and key on the device page](images/01-device-connectivity/device-id-and-key.png)
*The device page, Details tab. The Thing ID is the MQTT user name, and the Thing Key is the HTTP and MQTT password.*

![Channel ID on the channel page](images/01-device-connectivity/channel-id.png)
*The channel page, Details tab. The ID is used in the HTTP address and as the MQTT topic.*

**Tools:**

- **Ubuntu:** `sudo apt install curl mosquitto-clients`
- **Windows 10 and 11:** `curl.exe` is built in. For MQTT, install Mosquitto
  from [mosquitto.org](https://mosquitto.org/download/). The clients
  `mosquitto_pub.exe` and `mosquitto_sub.exe` are in
  `C:\Program Files\mosquitto`. Add that folder to `PATH`, or call the
  clients by their full path.

### Message format

Readings are sent as a JSON array in the SenML format. Each reading has a
name (`n`), a unit (`u`) and a value (`v`):

```json
[
  {"n": "temperature", "u": "Cel", "v": 21.5},
  {"n": "battery", "u": "V", "v": 3.6}
]
```

- **Other value types:** use `vs` for text and `vb` for true/false instead of `v`.
- **Timestamp:** `t` sets the time of a reading in Unix seconds. Without it,
  the platform uses the time the message arrives.
- **Units:** the SenML unit names, for example `Cel`, `V`, `A`, `W`, `Pa`
  and `%RH`.
- **Subtopic:** a message can carry an optional subtopic, such as `room1`.
  It is stored with every reading and can be used to filter data.

A device that cannot send SenML needs a [payload decoder](#payload-decoders)
in its profile.

### Publish over HTTP

**Ubuntu (bash):**

```bash
PLATFORM="platform.example.com"
CHANNEL_ID="<channel-id>"
DEVICE_KEY="<device-key>"

curl -i -X POST "https://$PLATFORM/http/$CHANNEL_ID" \
  -H "Authorization: $DEVICE_KEY" \
  -H "Content-Type: application/senml+json" \
  -d '[{"n":"temperature","u":"Cel","v":21.5},{"n":"battery","u":"V","v":3.6}]'
```

To add a subtopic, append it to the address:
`https://$PLATFORM/http/$CHANNEL_ID/room1`.

**Windows PowerShell:**

```powershell
$Platform  = "platform.example.com"
$ChannelId = "<channel-id>"
$DeviceKey = "<device-key>"

Set-Content reading.json '[{"n":"temperature","u":"Cel","v":21.5},{"n":"battery","u":"V","v":3.6}]' -Encoding ascii

curl.exe -i -X POST "https://$Platform/http/$ChannelId" `
  -H "Authorization: $DeviceKey" `
  -H "Content-Type: application/senml+json" `
  --data-binary "@reading.json"
```

- **`curl.exe`, not `curl`:** in Windows PowerShell, `curl` is another name
  for `Invoke-WebRequest`.
- **Keep the JSON in a file:** Windows PowerShell 5.1 removes the double
  quotes from JSON written inline on the command line. The platform still
  answers `202`, but it cannot read the message, so nothing is stored.

**Windows Command Prompt (cmd.exe):**

```bat
set "PLATFORM=platform.example.com"
set "CHANNEL_ID=<channel-id>"
set "DEVICE_KEY=<device-key>"

curl.exe -i -X POST "https://%PLATFORM%/http/%CHANNEL_ID%" -H "Authorization: %DEVICE_KEY%" -H "Content-Type: application/senml+json" -d "[{\"n\":\"temperature\",\"u\":\"Cel\",\"v\":21.5},{\"n\":\"battery\",\"u\":\"V\",\"v\":3.6}]"
```

**Responses:**

- `202 Accepted`: the platform has received the message.
- `403 Forbidden`: the device key is wrong, or the device is not connected
  to the channel.

**Private certificates:** these steps apply when the installation uses a
certificate from the customer's own certificate authority, not a public one.

- **Ubuntu:** add `--cacert ca.crt`.
- **Windows:** first install the CA certificate under *Trusted Root
  Certification Authorities*, then add `--ssl-no-revoke`. Windows curl
  cannot check revocation for a private CA and otherwise stops with error 60.

### Subscribe and publish over MQTT

The MQTT topic is the channel ID, optionally followed by a subtopic. The user
name is the device ID and the password is the device key. Subscribing to
`<channel-id>/#` receives every message on the channel, whichever protocol it
was sent with.

**Ubuntu (bash):**

```bash
PLATFORM="platform.example.com"
DEVICE_ID="<device-id>"
DEVICE_KEY="<device-key>"
CHANNEL_ID="<channel-id>"

# Terminal 1: subscribe to everything on the channel
mosquitto_sub -h "$PLATFORM" -p 1883 -u "$DEVICE_ID" -P "$DEVICE_KEY" -t "$CHANNEL_ID/#" -v

# Terminal 2: publish a message, then one with a subtopic
mosquitto_pub -h "$PLATFORM" -p 1883 -u "$DEVICE_ID" -P "$DEVICE_KEY" -t "$CHANNEL_ID" \
  -m '[{"n":"temperature","u":"Cel","v":21.5},{"n":"battery","u":"V","v":3.6}]'

mosquitto_pub -h "$PLATFORM" -p 1883 -u "$DEVICE_ID" -P "$DEVICE_KEY" -t "$CHANNEL_ID/room1" \
  -m '[{"n":"temperature","u":"Cel","v":22.0}]'
```

Terminal 1 prints each message with its topic:

```text
<channel-id> [{"n":"temperature","u":"Cel","v":21.5},{"n":"battery","u":"V","v":3.6}]
<channel-id>/room1 [{"n":"temperature","u":"Cel","v":22.0}]
```

**Windows PowerShell:**

```powershell
$Platform  = "platform.example.com"
$DeviceId  = "<device-id>"
$DeviceKey = "<device-key>"
$ChannelId = "<channel-id>"
$env:Path += ";C:\Program Files\mosquitto"

# Window 1: subscribe to everything on the channel
mosquitto_sub -h $Platform -p 1883 -u $DeviceId -P $DeviceKey -t "$ChannelId/#" -v

# Window 2: publish the message stored in a file
Set-Content reading.json '[{"n":"temperature","u":"Cel","v":21.5},{"n":"battery","u":"V","v":3.6}]' -Encoding ascii
mosquitto_pub -h $Platform -p 1883 -u $DeviceId -P $DeviceKey -t $ChannelId -f reading.json
```

`-f` sends the content of the file as the message. This avoids the JSON
quoting problem of Windows PowerShell 5.1.

**Windows Command Prompt (cmd.exe):**

```bat
set "PLATFORM=platform.example.com"
set "DEVICE_ID=<device-id>"
set "DEVICE_KEY=<device-key>"
set "CHANNEL_ID=<channel-id>"
set "PATH=%PATH%;C:\Program Files\mosquitto"

mosquitto_sub -h %PLATFORM% -p 1883 -u %DEVICE_ID% -P %DEVICE_KEY% -t "%CHANNEL_ID%/#" -v

mosquitto_pub -h %PLATFORM% -p 1883 -u %DEVICE_ID% -P %DEVICE_KEY% -t "%CHANNEL_ID%/room1" -m "[{\"n\":\"temperature\",\"u\":\"Cel\",\"v\":22.0}]"
```

**Notes:**

- **Delivery guarantee:** add `-q 1` for at-least-once delivery.
- **Wrong credentials:** the platform closes the connection, and Mosquitto
  reports `The connection was lost`.
- **Encryption:** port 1883 is not encrypted. Use it only inside a trusted
  network. When the installation enables MQTT over TLS, use port 8883 and
  add `--cafile ca.crt` for a private certificate authority, or
  `--tls-use-os-certs` for a public one.

### Check that the data arrived

Open the device page, go to **Real-time Messages**, select the channel and
click **Connect**. New messages appear as they arrive, with their subtopic.
Stored readings appear on the **Device Data** tab and on the channel page.

![Real-time messages on the device page](images/01-device-connectivity/realtime-messages.png)
*Messages published with mosquitto_pub arriving on the Real-time Messages tab. Each one shows its subtopic (room1, room2) and its readings.*

## Payload decoders

Many devices send data in their own format, such as a binary frame, a vendor
JSON structure or a LoRaWAN payload. A **decoder** turns that payload into
standard readings.

- **Where it lives:** the decoder is a short script stored in the device
  profile. Every device of that type uses it automatically.
- **Templates:** ready-made decoders for generic LoRaWAN payloads,
  temperature and humidity sensors, GPS trackers, energy meters and plain
  JSON.
- **Test before use:** a sample payload in raw, Base64 or hex form can be
  pasted into the profile. The result shows at once, with a warning for
  non-standard units.
- **Routing:** one message can be split into readings for several channels or
  devices.
- **Failed messages:** a message that cannot be decoded goes to a separate
  dead-letter stream. It is not mixed into the data.
- **Versions:** profile versions keep their decoder. Devices on an old
  profile version keep working while a new version is introduced.

## Data from edge nodes

Edge nodes running EdgeX Foundry sit next to the equipment and read it through
EdgeX device services. Each node forwards the readings to the platform over
MQTT, on the node's own channel.
The platform decodes them into standard readings named after the EdgeX device
and resource, with the original timestamp. EdgeX releases 2.3, 3.1 and 4.0 are
supported.

Edge nodes, EdgeX devices and their software are managed from the platform.
See [Edge management](FEATURES.md#7-edge-management).

## Common to all connections

- **Report by exception:** Modbus and BACnet values can be sent only when they
  change by more than a set deadband, with a maximum interval as a heartbeat.
  OPC UA applies its deadband at the server. This keeps network traffic and
  storage low, and it is off unless switched on. It can be set per value or
  inherited from the device profile.
- **Switch on and off:** every Modbus, BACnet and OPC UA connection, every
  SNMP receiver, and every device behind them can be disabled and enabled
  without deleting its configuration.
- **Live status:** polled values show their status and last value. Modbus
  connections show reachability, and SNMP receivers show trap counts.
- **Credentials:** connection passwords and SNMP keys are stored encrypted
  (AES-256-GCM). After entry they can be replaced, but they are not shown
  again.
- **Access by group:** every connection and device belongs to an owner group.
  Users see and change only what their groups own.

## Current scope

This list gives sales engineers the current boundaries, so a proposal matches
what the platform delivers today.

- **Modbus:** Modbus TCP only. Serial Modbus RTU devices connect through a
  Modbus TCP gateway. Unit IDs are configured, not discovered.
- **BACnet:**
  - Objects are polled; COV subscriptions are not supported yet.
  - Writes use a fixed priority and cover analog objects.
  - Foreign-device registration and devices behind BACnet routers are not
    supported yet.
- **OPC UA:**
  - Writes, method calls and certificate sign-in are available through the
    API only, with no screens yet.
  - Server certificates are accepted without checking them against a trust
    list.
- **SNMP:** traps and informs only. The platform does not poll devices over
  SNMP. Trap variables are shown with their numeric OIDs.
- **MQTT:** devices sign in with a device key; device certificates (mutual
  TLS) are not supported. Sparkplug B payloads from third-party devices are
  not decoded yet.
- **CoAP and LoRaWAN:** pilot status.
  - CoAP is not part of the standard deployment.
  - LoRaWAN downlink is not supported, and gateways are registered in the
    network server, not from the platform.

## Questions to ask the customer

- Which protocols do the sites use, and roughly how many devices and values
  are there per site?
- How often does each value need to be read, and which values change rarely
  enough for report by exception?
- Are there serial (RS-485) Modbus devices, and are Modbus TCP gateways
  already in place?
- Are the BACnet controllers on the same IP subnet as the platform or edge
  node, or behind BACnet routers?
- Which values must the platform write back, such as setpoints, start/stop or
  modes?
- Which security requirements apply to device connections, such as TLS, SNMP
  v3 or OPC UA Sign and Encrypt?
- Should data be collected centrally, or on an edge node at each site that
  keeps working when the link drops?
