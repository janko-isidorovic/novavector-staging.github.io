# 13. Deployment options

*Nova Vector Platform · feature document 13 of 13 · October 2026 · for clients and sales engineers*

[← Feature overview](FEATURES.md)

This document describes where the platform runs, how it is installed, which
parts are optional, and how edge nodes connect to it:

- **Where:** on the customer's servers, or on a cloud server the customer
  controls, with edge nodes at the sites.
- **How:** the platform runs as containers. The standard installation is
  Docker Compose on one Linux server, installed by script.
- **Modules:** protocol adapters, edge fleet services and the AI model server
  are optional.
- **Edge nodes:** Ubuntu machines at the sites, installed from the platform.

## Contents

- [What gets installed](#what-gets-installed)
- [Where it runs](#where-it-runs)
- [Installing on a single server](#installing-on-a-single-server)
- [Choosing modules](#choosing-modules)
- [Kubernetes](#kubernetes)
- [Scaling and availability](#scaling-and-availability)
- [Edge nodes](#edge-nodes)
- [Versions and updates](#versions-and-updates)
- [Isolated networks](#isolated-networks)
- [Current scope](#current-scope)
- [Questions to ask the customer](#questions-to-ask-the-customer)

---

## What gets installed

The platform is a set of container images:

| Part | Contents |
| --- | --- |
| **Platform services** | About 36 Nova Vector services: devices and profiles, the protocol adapters, alerts and tasks, commands and schedules, the Process Simulator, the manufacturing services, edge management and Edge AI, data writers and readers, and the console |
| **Data** | TimescaleDB (PostgreSQL) for records and time-series data, Redis for caching, an S3-compatible object store for edge software and models |
| **Messaging** | NATS inside the platform; an MQTT broker for devices |
| **Identity and access** | Keycloak for single sign-on, nginx as the gateway |
| **Dashboards** | Grafana with a report renderer |
| **Monitoring** | OpenSearch and fluentd for logs, Prometheus for metrics, Jaeger for traces |
| **Tools** | Node-RED, the Nuclio function workspace, remote-desktop gateway, API documentation |
| **Optional** | ChirpStack for LoRaWAN, a local container registry for edge sites, Ollama for the AI Assistant |

The Nova Vector images are published on Docker Hub; the other components use
their official images.

## Where it runs

| Option | How it looks |
| --- | --- |
| **On premises** | The platform on the customer's server, next to the equipment or in the company data center |
| **Cloud** | The platform on a cloud server that the customer controls |
| **Hybrid** | The platform in the cloud or a data center, with [edge nodes](07-edge-management.md) at the sites that collect data locally |

**Connections in a hybrid setup:**

| From | To | Used for |
| --- | --- | --- |
| Edge node | Platform: HTTPS (443) | Installation, enrollment, single sign-on |
| Edge node | Platform: MQTT | Device data and commands |
| Edge node | Platform: object store and registry ports | Software and model downloads |
| Platform | Edge node: SSH (22) | Remote installation (Block Deployment) |
| Platform | Edge node: EdgeX port | Reading and copying the node's devices |
| Platform | Edge node: SSH, RDP, VNC | Remote access sessions |

Connections from the platform to the nodes need a route to the site, for
example a VPN.

## Installing on a single server

The standard installation is **Docker Compose on one Linux server**:

- **Server:** Linux (for example Ubuntu) on x86-64, with Docker Engine and
  the Compose plugin.
- **Names:** a DNS name for the platform, and names for the function
  workspace, LoRaWAN and edge sub-sites.
- **Certificates:** the customer's certificates, or a private certificate
  authority created at installation.

**The installation script:**

1. creates the configuration and generates a random password or secret for
   every service
2. creates the certificates and the encryption keys for stored adapter
   credentials
3. starts the platform
4. configures single sign-on, LoRaWAN and the edge object store
5. optionally sets up the [simulators](10-simulators.md) and the edge
   software catalog for a demonstration

After that, the platform starts and stops with Docker Compose.

**Size:** the demonstration installation, with all modules and the
simulators, uses about 11 GB of memory. The server is sized for each project
from the number of devices, the data rate and the history to keep.

## Choosing modules

Optional modules are switched on or off in the installation's settings:

| Module | Contents |
| --- | --- |
| LoRaWAN | ChirpStack and the LoRa adapter |
| OPC UA, Modbus, BACnet, SNMP | One adapter each |
| Edge | Provisioning, object store, software registry, deployment and site registry |
| Extras | Node-RED, remote desktop, API documentation |
| Monitoring | Prometheus |
| AI model server | Ollama, when the model runs next to the platform |

The core (devices, data, alerts, tasks, dashboards, manufacturing, Process
Simulator) is always installed.

## Kubernetes

Customers that run Kubernetes, for example with Rancher, get a Kubernetes
installation as a project service. Reference manifests exist for the edge
object store and the site registry; manifests for the whole platform are not
yet part of the product.

## Scaling and availability

- **Several instances:** the batch writer, the decoder, and the
  notifications and tasks services share work through NATS, and the
  industrial adapters (Modbus, BACnet, OPC UA) share their device
  connections through leases. They can run as several instances, for example
  on Kubernetes. The other services run as one instance each.
- **Single server:** the Docker Compose installation runs one instance of
  each service.
- **Infrastructure:** the database, Redis, NATS, Keycloak and the MQTT broker
  run as single instances. High availability is designed for each project.

## Edge nodes

- **Operating system:** Ubuntu 20.04 or newer, on amd64 or arm64 machines.
- **Installation:**
  - from the platform, over SSH, with the
    [Block Deployment](07-edge-management.md#installing-nodes-block-deployment) wizard
  - from a list of nodes (CSV import)
  - by hand, with one command line or the installer and a preset (minimal,
    Docker, EdgeX, Edge AI, lab)
- **Local images:** a site registry can keep container images at the site, so
  that nodes do not download them from the internet.

## Versions and updates

- **Database changes** are applied automatically when a service starts.
- **Images** are published on Docker Hub. The current images are development
  versions.
- **Backups** of the database and the object store are set up for each
  project.

## Isolated networks

Sites without internet access are prepared as a project service: the
container images, dashboard plugins and AI model are mirrored in advance, and
edge nodes take their images from the site registry.

## Current scope

This list gives sales engineers the current boundaries, so a proposal
matches what the platform delivers today.

- **Installation:**
  - The scripted installation is the development and demonstration
    installation. A production installation is prepared and hardened for
    each project: published ports, secrets, certificates, admin consoles
    (see [Security and administration](12-security-and-administration.md)).
  - The production installation template is being brought in line with the
    development installation.
  - The installation script needs internet access to download images and
    tools.
- **Server:** x86-64 Linux. The platform images are not built for ARM
  servers.
- **Kubernetes:** project service; no standard manifests for the whole
  platform yet.
- **Modules:** leaving out LoRaWAN, the extras, monitoring, the edge services
  or SNMP needs a change to the gateway configuration.
- **Scaling:** one instance per service on Docker Compose; no built-in high
  availability for the database, Redis, NATS, Keycloak or the MQTT broker.
- **Versions:** there are no formal release versions, upgrade notes or
  rollback procedure yet.
- **Backups and retention:** no backup tooling is included; device data and
  logs are kept until deleted.
- **Hybrid:** MQTT to the edge nodes is not encrypted by default, and the
  platform needs a route (for example a VPN) to reach the nodes for SSH,
  EdgeX and remote access.
- **Isolated networks:** no offline installation package yet; prepared per
  project.
- **Edge nodes:** Ubuntu with presets; RHEL-family and Debian nodes are not
  supported yet. arm64 has not yet been tested on real hardware.

## Questions to ask the customer

- Where should the platform run: on the customer's servers, in their cloud,
  or both? Who operates it?
- Is Kubernetes the standard in the customer's IT? Which distribution?
- How many devices and sites, how much data per second, and how long must
  data be kept?
- What availability is required, and is a second server or site needed?
- Do the sites have internet access? Is a VPN between the platform and the
  sites possible?
- What are the customer's rules for backups, updates and change windows?
- Which operating systems and hardware will the edge nodes have?
