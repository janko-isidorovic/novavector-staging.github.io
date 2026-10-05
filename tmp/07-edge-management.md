# 7. Edge Management

*Nova Vector Platform · feature document 7 of 13 · October 2026 · for clients and sales engineers*

[← Feature overview](FEATURES.md)

Edge nodes are small computers next to the equipment. They read field devices
through EdgeX Foundry, run local services such as AI models, and send their
data to the platform.

Edge management installs, configures and updates whole fleets of these nodes
from the platform:

- **Onboarding:** the nodes are listed in one file, imported, and installed
  in one step over SSH.
- **Software:** each kind of node gets a defined set of approved software.
- **Rollouts:** updates are rolled out to groups of nodes.
- **Devices:** the devices on each node are visible on the platform and can
  be copied to other nodes.
- **On-site access:** every node has a local console, and remote sessions to
  on-site machines run in the browser.

## Contents

- [How onboarding works](#how-onboarding-works)
- [Importing a fleet](#importing-a-fleet)
- [Node types and the software catalog](#node-types-and-the-software-catalog)
- [Installing nodes: Block Deployment](#installing-nodes-block-deployment)
- [Rollouts and updates](#rollouts-and-updates)
- [Node status](#node-status)
- [Edge devices](#edge-devices)
- [Site registry](#site-registry)
- [Local console and remote access](#local-console-and-remote-access)
- [Security of edge nodes](#security-of-edge-nodes)
- [Current scope](#current-scope)
- [Questions to ask the customer](#questions-to-ask-the-customer)

---

## How onboarding works

The screenshots in this document come from one run on three lab nodes. In
that run, three bare Ubuntu machines were turned into running edge nodes with
EdgeX 4.0, the Edge AI runtime and the local console:

| Step | Where in the platform | In the lab run |
| --- | --- | --- |
| **1. Import the fleet** | Edge Computing → Fleet Import | A CSV with three nodes: name, group, IP address, SSH user, architecture |
| **2. Choose what they run** | Node Types | Node type *edge-ai-4-0*: EdgeX 4.0, the Edge AI runtime and the local console |
| **3. Install** | Block Deployment | The agent is installed over SSH on all three nodes at once |
| **4. Deploy** | Rollouts | Each node gets its software as soon as its agent connects |
| **5. Connect devices** | Edge Device Replication | Four battery-system devices set up on one node and copied to the other two |

All three nodes were installed, connected and running within about
15 minutes, without anyone logging in to them.

## Importing a fleet

The fleet is described in a CSV file, one row per node:

| Column | Content |
| --- | --- |
| `name` | Node name, for example `nv-edgex-01` |
| `group` | The customer, site or business unit the node belongs to |
| `node_type` | The kind of node (see below) |
| `mgmt_ip`, `ssh_user`, `ssh_port` | How the platform reaches the node for the installation |
| `arch` | `amd64` or `arm64` |
| `location` | Free text, for example a rack or cabinet position |
| `profile` | The device profile of the node itself (optional) |

**Validation:** the platform checks the whole file before anything is
created:

- names and IP addresses must be valid, and unique across the fleet
- groups and node types must exist
- the architecture must be supported

Rows with errors are listed with a code and a message, and the import can
only be applied when no error remains. Importing a node again, for example
after a hardware swap, needs an explicit confirmation.

**Applying the import** creates, for each node:

- the node in the device registry
- its operations and telemetry channels

![Fleet import validation](images/07-edge-management/fleet-import-validation.png)
*A fleet file with mistakes: a bad node name, an unknown group, a duplicate and an invalid IP address, a bad port, an unsupported architecture and a missing SSH user. Each error is listed, and the import stays blocked until they are fixed.*

## Node types and the software catalog

### Node types

A **node type** defines what a kind of node runs:

- **Bundles:** the software it runs, each one either pinned to a version or
  set to "latest approved".
- **Agent preset:** the agent configuration, which also decides which
  software the agent may deploy at all.

Examples from the demo installation:

| Node type | Runs |
| --- | --- |
| `std` | EdgeX 3.1 and the local console |
| `edgex-2-3`, `edgex-4-0` | EdgeX 2.3 or 4.0 and the local console |
| `edge-ai`, `edge-ai-2-3`, `edge-ai-4-0` | EdgeX, the Edge AI runtime and the local console |
| `sim-*` | A simulator system, for demos and tests (see [Simulators](FEATURES.md#10-simulators)) |

![Node types](images/07-edge-management/node-types.png)
*Node types of the demo installation, each with its bundles and agent preset.*

### The software catalog

Everything a node installs comes from the platform's own catalog:

- **Service bundles:** a packaged set of containers with its configuration
  and parameters. Examples are an EdgeX release, the Edge AI runtime, the
  local console or a simulator system.
- **Agent packages:** the edge agent itself, for each operating system and
  processor architecture.
- **AI models:** see [Edge AI](FEATURES.md#8-edge-ai).

**Versions and approval:**

- Each version moves through draft → candidate → approved, and later to
  deprecated and retired.
- Only approved versions can be deployed.
- Approvals, deprecations and retirements are recorded.

**Integrity:** each version carries a SHA-256 checksum, which the node checks
before it installs anything.

**Reference bundles in the catalog:**

| Bundle | Contents |
| --- | --- |
| `edgex-2-3-nviot`, `edgex-3-1-nviot`, `edgex-4-0-nviot` | EdgeX Foundry 2.3, 3.1 or 4.0: core services, the Modbus device service (and REST on 3.1 and 4.0), rules engine, EdgeX console, and the export of readings to the platform |
| `nv-edge-ai` | The Edge AI inference runtime and its EdgeX bridge |
| `nv-edge-agent-ui` | The local operator console |
| `sim-bess-enclosure`, `sim-production-line`, `sim-assembly-line` | The simulator systems |

![Bundle catalog](images/07-edge-management/bundle-catalog.png)
*The bundle catalog. The EdgeX 4.0 bundle is open, with its approved version 4.0.8, its checksum and the lifecycle actions.*

## Installing nodes: Block Deployment

**Block Deployment** installs whole groups of nodes in one step. A group is a
block, for example one site or one production area. The wizard has five
steps:

1. **Target blocks:** one or more groups, with their number of nodes.
2. **Agent:** the agent preset. It is taken over from the node type
   automatically.
3. **Bundle set:** the node type, showing the bundles and how each version
   is chosen.
4. **SSH and policy:**
   - **Access:** the SSH password or private key for the nodes.
   - **Pace:** how many nodes are installed in parallel, and a stop threshold
     (for example, stop when 10 % of the nodes fail).
   - **Hardening:** optionally turns off SSH password login after the
     install.
   - **Pin the platform's address:** for sites without DNS for the
     platform's name.
   - **Trust the site registry:** lets Docker on the nodes pull from the
     platform's container registry.
5. **Summary and deploy.**

**Handling of credentials:** the SSH credentials are kept in memory for this
batch only. They are never stored or logged, and they are cleared when the
batch ends.

![Choosing the node type](images/07-edge-management/block-deployment-bundles.png)
*Step 3: node type edge-ai-4-0, with three bundles that each take the latest approved version at deploy time.*

![SSH and policy](images/07-edge-management/block-deployment-options.png)
*Step 4: SSH password (or key), parallel installs, stop threshold, hardening, and the two site options: pinning the platform's address and trusting the site registry.*

### What happens on each node

The platform connects over SSH and runs a short bootstrap. It:

1. installs the platform's certificate authority
2. detects the operating system
3. downloads the approved agent for that system and checks its checksum
4. enrolls the node with a one-time token
5. prepares the host (the platform's address, trust for the site registry)
6. installs and starts the agent with its preset
7. optionally hardens SSH
8. reports back

The **push board** follows the batch node by node, with the status, the
number of attempts and the last output. Failed nodes can be retried. For a
node the platform cannot reach over SSH, a one-time command line can be
generated and run on the node by hand.

![Push board](images/07-edge-management/push-board.png)
*The push board of the lab install: all three nodes bootstrapped.*

## Rollouts and updates

A **rollout** brings the software of a node type to the nodes of one or more
groups.

- **Deploy on first connect:** a node gets its software as soon as its agent
  connects. A new node is therefore installed and deployed in one pass.
- **Pace and safety:** nodes are updated a set number at a time, and the
  rollout stops when the stop threshold is reached.
- **Retries:** each bundle is tried up to three times on a node. A rollout
  can be retried from its board, for example after a network problem has
  been fixed.
- **Health checks on the node:** after a deployment, the node checks that the
  new containers come up healthy. If an update is not healthy, the node
  restores the version it ran before.
- **Release switches:** when a node type changes, for example from EdgeX 3.1
  to 4.0, the bundles that are no longer part of it are removed first.

The **rollout board** shows every node and bundle with its phase: requested,
in progress, running, failed or rolled back.

![Rollout board](images/07-edge-management/rollout-board.png)
*The rollout of edge-ai-4-0 to the lab group: nine bundles on three nodes, all running.*

## Node status

Each node has a status page:

- **Runtime:** status, IP address, architecture, agent version and the time
  of its last report.
- **Edge AI runtime:** the active model, health, memory, storage and
  accelerators (see [Edge AI](FEATURES.md#8-edge-ai)).
- **Desired state:** the bundles and versions the node should run.
- **Reported state:** what the node actually runs, with the health of each
  bundle.
- **Deployment baselines:** the last good version of each bundle, with its
  checksum and time.
- **Enrollment tokens:** their status and expiry.

![Node status](images/07-edge-management/node-state.png)
*Node nv-edgex-01: online with agent 1.0.12, the Edge AI runtime ready and waiting for a model, and the three bundles of its node type running.*

![Edge instances](images/07-edge-management/edge-instances.png)
*The edge instances of the lab, with their IP addresses and groups.*

## Edge devices

The field devices connected to a node, such as PLCs, meters and sensors, are
set up in EdgeX on that node. The platform works with them as follows:

- **Device list per node:** the *EdgeX Config* tab of a node lists its
  devices and device profiles, with the device service each one uses and the
  platform device it is linked to.
- **EdgeX console:** EdgeX's own console for the node opens inside the
  platform.
- **Readings on the platform:** the node exports its devices' readings to the
  platform, where they are stored under the node with the device and reading
  name, for example `sim-bess-bms/cell_temp_max`. Dashboards, alerts and
  tasks use them like any other data.
- **EdgeX releases:** 2.3, 3.1 and 4.0 are supported.

![EdgeX devices on a node](images/07-edge-management/edgex-devices.png)
*The EdgeX devices on nv-edgex-01: a camera input that comes with the bundle, and four devices of a battery system (BMS, inverter and two climate sensors), each linked to a platform device.*

![Readings from an edge node](images/07-edge-management/edge-device-data.png)
*Readings of the battery system on nv-edgex-01, read by EdgeX on the node and charted on the platform over the last hour: cell temperatures and enclosure temperatures, from the moment the devices were added to the node.*

![EdgeX console](images/07-edge-management/edgex-ui.png)
*EdgeX's own console for the node, opened inside the platform.*

### Copying devices to other nodes

**Edge Device Replication** copies device configurations from one node to
others in five steps: source node, devices, target nodes, preview and
results.

- **Profiles come along:** any device profiles the targets are missing are
  created first.
- **Platform records:** each device is also registered on the platform under
  its new node.
- **Existing devices:** devices that already exist on a target are skipped.
- **Offline source:** the copy can be made from the platform's saved copy of
  the devices when the source node is offline.

In the lab run, the four battery-system devices were set up on nv-edgex-01
and then copied to nv-edgex-02 and nv-edgex-03 in one pass. Each node then
read the battery simulator within seconds.

![Replication preview](images/07-edge-management/replication-preview.png)
*The preview before copying four devices from nv-edgex-01 to two other nodes: profiles to create, the device service on each target, and the action per device.*

## Site registry

Nodes do not pull their containers from the internet. They pull them from a
**site registry**: a container registry that runs with the platform.

- **Filling it:** images are copied into the registry once, for example
  while preparing an installation.
- **Using it:** nodes are configured to trust it during the Block
  Deployment.
- **In the console:** the *Site Registry* page lists its repositories and
  tags, with their platforms and sizes, and gives ready-to-copy pull and push
  commands.

![Site registry](images/07-edge-management/site-registry.png)
*The site registry with the EdgeX, Edge AI, console and simulator images the nodes use.*

## Local console and remote access

### Local console

Every node runs a **local console**, a web page on the node itself:

- **Dashboard:** the node, its connection to the platform, CPU, memory and
  disk.
- **Services and Docker:** system services, containers and compose projects,
  with start, stop and restart for the ones the node's preset allows.
- **Logs:** container logs and the system journal.
- **Edge Agent Events:** the node's audit journal (see below).
- **Configuration:** the agent's settings, read only, with secrets hidden.

**Logging in:** users log in with their platform account. When the platform
cannot be reached, the console offers a local login instead. Inside the
platform, the console of each node opens on the node's *Edge* tab, already
logged in.

![Local console](images/07-edge-management/local-console.png)
*The local console of nv-edgex-01, inside the platform: the containers of EdgeX 4.0, the Edge AI runtime and the console itself, all running from the site registry.*

### Remote access

Remote sessions to a node or to another on-site machine run in the browser
over SSH, RDP or VNC, with no VPN client on the user's computer. The
connection details are set on the device in the platform.

![Remote session](images/07-edge-management/remote-ssh.png)
*An SSH session to nv-edgex-01 in the browser, from the node's Edge tab.*

## Security of edge nodes

- **Signed commands:**
  - Every command from the platform to a node carries a token signed by the
    platform's identity service and issued for that node only.
  - The node checks the signature, the node name, the expiry and the role
    each command needs, and it refuses a command it has already seen.
- **Audit journal:** each node records every command it receives, authorizes,
  rejects, executes or fails. The journal is shown in the local console.
- **Approved software only:** a node installs only approved catalog versions,
  and checks each checksum before installing.
- **Credentials:** SSH credentials for installation are never stored.
- **Agent permissions:** the preset limits which software the agent may
  deploy. Anything outside it is refused on the node.

![Audit journal](images/07-edge-management/audit-events.png)
*The audit journal of nv-edgex-01: deployment commands received, authorized and executed, with the target and actor of each one.*

## Current scope

This list gives sales engineers the current boundaries, so a proposal matches
what the platform delivers today.

- **Supported nodes:**
  - **Operating system:** Ubuntu on amd64 or arm64 (for example, a Raspberry
    Pi 5).
  - **Docker:** it must be installed on the node beforehand.
  - **Other systems:** RHEL and Debian nodes are not supported yet.
- **EdgeX on arm64:** EdgeX 2.3 and 4.0 run on amd64 only. EdgeX 3.1, the
  Edge AI runtime and the console also run on arm64.
- **Offline sites:**
  - Containers come from the site registry.
  - The agent install still needs the Ubuntu package repositories, or a
    local mirror of them.
- **One node type per deployment:** a Block Deployment applies one node type
  to the groups it targets. The node type column of the fleet file is
  checked, but not yet used for deployment.
- **Rollouts:**
  - They are started from Block Deployment. A software update therefore
    reuses the SSH credentials step.
  - There are no waves, canary nodes or pause.
  - Health means that the containers are healthy. Application-level checks
    are not yet used.
  - The previous version is restored by the node itself. Rolling a whole
    group back to an earlier version is done with a new rollout.
- **Node status:** a node that goes silent is not yet shown as offline on
  its status page.
- **Data during an outage:** EdgeX keeps reading the devices while the link
  to the platform is down, but those readings are not stored for later
  delivery. The platform has a gap for that period.
- **Devices:**
  - **From the platform:** devices are copied and deleted.
  - **Creating and editing:** done in EdgeX's own console, which opens inside
    the platform.
  - **Device services:** they come with the bundles and are not copied
    between nodes.
- **Remote access and the local console:**
  - Remote sessions are not recorded.
  - Access control for remote sessions and for the node's local control API
    is being strengthened. Check the current status with the product team
    before offering remote access to a customer.
- **Approval and signing:**
  - Catalog approval is a role, with no second approver.
  - Signature checking of bundles on the node is available but switched off
    by default. The checksum is always checked.
- **History:** the push board of an installation is opened from the
  wizard. There is no list of past installations yet.
- **Standard installation:** edge management is set up for each project. It
  is not yet part of the standard production deployment template.

## Questions to ask the customer

- How many edge nodes, at how many sites, and which hardware: industrial PCs,
  gateways, or Raspberry Pi?
- Which devices and protocols must the nodes read (Modbus, REST, cameras,
  other EdgeX device services)?
- Can the platform reach the nodes over SSH for the first install, or must
  the install be started on site?
- Do the sites have internet access, a package mirror, or neither?
- How should updates be rolled out: per site, per line, at night, and who
  approves new versions?
- Does on-site staff need a local console, and is remote access to on-site
  machines needed?
- Are there security rules for edge devices, for example hardening, no SSH
  passwords, or audit requirements?
