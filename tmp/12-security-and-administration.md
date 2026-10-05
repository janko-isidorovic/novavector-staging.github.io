# 12. Security and administration

*Nova Vector Platform · feature document 12 of 13 · October 2026 · for clients and sales engineers*

[← Feature overview](FEATURES.md)

This document describes how the platform controls who can do what, keeps
data apart, protects connections, and lets administrators watch the
platform:

- **Single sign-on:** one login for the console, the dashboards and the
  administration tools, with access to each module given per user.
- **Groups:** every device and record belongs to a group, and users see only
  the data of their groups.
- **Encryption:** HTTPS for the console, the APIs and device connections.
- **Monitoring:** consoles for logs, metrics and traces.
- **Edge nodes:** commands to edge nodes are signed for each node and
  recorded on the node.

## Contents

- [Single sign-on and roles](#single-sign-on-and-roles)
- [Groups](#groups)
- [Encryption and credentials](#encryption-and-credentials)
- [Monitoring and administration tools](#monitoring-and-administration-tools)
- [Edge nodes](#edge-nodes)
- [Personal data](#personal-data)
- [Current scope](#current-scope)
- [Questions to ask the customer](#questions-to-ask-the-customer)

---

## Single sign-on and roles

The platform uses Keycloak, a widely used open-source identity server, for
all logins.

**One login** opens the console, the dashboards (Grafana), the database
administration tool and the other administration consoles.

**Two kinds of permission:**

- **Module access:** 35 roles, one for each module or page group of the
  console, for example devices, edge, Modbus, BACnet, reporting, plans,
  documents, Process Simulator, AI Assistant and system administration. A
  user sees only the menus and pages of their roles.
- **Write permissions:** create, update and delete, given per user. A user
  with read access only can look but not change.

The **administrator** role includes all module roles, all write permissions,
the dashboard administrator role and user administration.

**Sign-in protection:**

- **Two-factor login:** each user can add an authenticator app (a one-time
  code) in *My Account*.
- **Lockout:** repeated wrong passwords lock the account for a while.
- **Idle logout:** the console warns after 30 minutes without activity and
  then logs the user out. A login session ends after 10 hours.

**Company directories:** Keycloak can connect to LDAP or Active Directory, or
hand logins to another identity provider (SAML or OpenID Connect). This is
set up for each project.

**User administration:** *Administration → Admin → User Admin* opens the
Keycloak console inside the platform: users, groups, roles, sessions and
login settings.

![Module roles](images/12-security-and-administration/module-roles.png)
*The console's roles in User Admin: one role for each module or page group, given to users or to groups of users.*

![Two-factor login](images/12-security-and-administration/two-factor.png)
*My Account: a user adds an authenticator app for two-factor login.*

## Groups

Every device, channel, profile, alert, task, plan, work order, document and
other record belongs to a **group**.

- **Visibility:** a user sees and changes only the records of the groups
  they are a member of.
- **Creation:** a new record is created in one of the user's groups.
- **Use:** groups separate plants, lines, sites or business units on one
  installation, for example a battery site and a production line.
- **Same for systems:** an external system that uses the APIs is also a
  member of groups, and sees only their data.

![Groups](images/12-security-and-administration/groups.png)
*The groups of the demo installation: one per simulated site, plus groups for edge nodes and tests.*

## Encryption and credentials

- **Console and APIs:** HTTPS (TLS 1.2), with the installation's certificate.
  Plain HTTP is redirected to HTTPS.
- **Devices:** devices and applications can connect over HTTPS and secure
  WebSocket. MQTT over TLS and CoAP over DTLS are available where the
  installation publishes them. Each device authenticates with its own key.
- **Industrial adapters:** stored passwords and keys for OPC UA, Modbus and
  SNMP connections are encrypted (AES-256), with a key kept outside the
  database.
- **OPC UA:** client certificates can be uploaded for each OPC UA connection.
- **Certificates:** the installation's certificates come from the customer's
  certificate authority, or from a private authority created at
  installation.

## Monitoring and administration tools

Under *Administration → System*, for users with the system role:

| Tool | What it shows |
| --- | --- |
| **Logs** (OpenSearch) | The logs of every platform service, searchable |
| **Metrics** (Prometheus) | Technical metrics of every service, kept 15 days |
| **Tracing** (Jaeger) | The path of a request through the services, for troubleshooting |
| **Database Admin** (pgAdmin) | The platform database |
| **Cache Admin** | The platform's cache |
| **Open API** | The interactive API documentation |

These tools open with the same single sign-on.

## Edge nodes

Commands from the platform to an edge node are checked on the node:

- **Signed for one node:** every command carries a five-minute token signed
  by the platform's identity server and addressed to that node. The node
  rejects tokens addressed to any other node.
- **Role checked:** the node checks that the token carries the role needed
  for the kind of command, for example deploying software.
- **Used once:** the node rejects a token it has already seen.
- **Recorded:** each node keeps a local journal of the commands it received.

See [Edge management](07-edge-management.md#security-of-edge-nodes) for details.

## Personal data

The platform stores some personal data:

- **Users:** name and e-mail address, in Keycloak. Records show who created
  them and who changed them last.
- **People in manufacturing:** names, employee numbers and RFID badge
  numbers, for shifts and attendance. People can be deleted.
- **Edge AI camera models:** the results of a camera model (for example an
  age bracket) are stored, not the pictures. See
  [Edge AI](08-edge-ai.md#camera-based-models).

## Current scope

This list gives sales engineers the current boundaries, so a proposal
matches what the platform delivers today.

- **Roles:**
  - Module roles control the console: its menus and pages.
  - In the services, changes are controlled by the write permissions and the
    group. A user with write permissions can use a module's interface
    without that module's console role.
- **Separating customers:**
  - Groups separate plants and business units well.
  - Dashboards, Node-RED, the function workspace, logs, metrics and traces
    are shared by the whole installation, and user administration covers the
    whole installation. Several different customers on one installation need
    a design for that project.
  - Known gaps in group separation are being fixed.
- **Administration tools:** the logs, metrics, traces, Node-RED and cache
  consoles are hidden from users without the right role, but the platform
  does not yet block a signed-in user who opens them directly. They are
  restricted for each installation.
- **Sign-in:**
  - Two-factor login is available but not enforced.
  - There is no password policy by default.
  - No company directory is connected by default.
  - Login and administration events are not recorded by default.
- **Audit:** there is no log of user actions yet; each record shows who
  created it and who changed it last.
- **Certificates:** there is no certificate management in the platform. The
  *Cert Admin* page is not connected yet. Devices authenticate with keys,
  not with device certificates.
- **MQTT over TLS:** available, but not published by default.
- **Backups and retention:** backups are not included and are set up for
  each project. Device data and logs are kept until they are deleted.
- **Personal data:** no export or erasure function for a person's data yet.
- **Hardening:** a production installation is hardened as part of the
  project: published ports, secrets, certificates and consoles (see
  [Deployment options](13-deployment-options.md)).

## Questions to ask the customer

- Which company directory should users log in with (Active Directory, Azure
  AD/Entra ID, another identity provider)? Is two-factor login required?
- Which roles do the users have: operators, engineers, supervisors,
  administrators? Who may change what?
- How should data be separated: by plant, line, business unit, or customer?
- Are there security standards to meet, for example IEC 62443, ISO 27001 or
  a company security policy?
- Which audit and retention rules apply: how long must data and logs be
  kept, and who must be able to see who changed what?
- Is personal data involved (badges, cameras)? Who is the data protection
  contact?
- Does the customer provide the certificates, and is there a security review
  before go-live?
