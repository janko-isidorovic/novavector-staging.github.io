# 9. AI Assistant (preview)

*Nova Vector Platform · feature document 9 of 13 · October 2026 · for clients and sales engineers*

[← Feature overview](FEATURES.md)

> **Preview.** The AI Assistant is offered as a preview. It is suited to
> demonstrations and pilots with direct questions and requests. See
> [Current scope](#current-scope) before it is offered in a proposal.

The AI Assistant is a chat page in the platform. Users type a question or a
request in plain language, and the assistant answers from the platform's
live data:

- **Questions:** devices, channels and their latest readings, organizations,
  people, shifts, tasks, production plans, schedules, notifications and
  process simulations.
- **Changes:** it creates, changes and deletes devices and channels, and
  connects them, after the user confirms. It can also run device commands
  and control simulations.
- **Answers:** tables and cards, with a short written answer.
- **Private model:** the language model runs on a server in the customer's
  own environment. Questions and data do not go to an outside AI service.

The assistant works through the platform's own interfaces with the user's
own login, so it sees and changes only what the user is allowed to.

## Contents

- [How it works](#how-it-works)
- [What it covers](#what-it-covers)
- [Making changes](#making-changes)
- [Answers](#answers)
- [Languages](#languages)
- [The language model](#the-language-model)
- [Access and permissions](#access-and-permissions)
- [Current scope](#current-scope)
- [Questions to ask the customer](#questions-to-ask-the-customer)

---

## How it works

| Step | What happens |
| --- | --- |
| **1. Question** | The user types a question or a request, for example "List the channels". |
| **2. Choosing functions** | The assistant picks the platform functions that fit the question, from 69 available ones. |
| **3. Reading the platform** | It calls those functions on the platform, with the user's login. |
| **4. Further steps** | It reads the results and can take more steps, for example find a device by name and then read its data. A question can take up to five steps. |
| **5. Answer** | The results appear as a table or a card, with a short written answer. |

The language model decides which functions to call and writes the answer.
The platform does the work, and its usual permission checks apply to every
call.

## What it covers

| Area | Example request | What the assistant can do |
| --- | --- | --- |
| **Devices and channels** | "List the channels" | List and show; create, change and delete; connect a device to a channel |
| **Device data** | "Show the latest messages of device sim-assembly-line-a1" | Read a device's latest readings |
| **Profiles** | "Show the device profiles" | List and show |
| **Organizations and people** | "List the organizations" | Organizations, people and positions |
| **Calendars and shifts** | "Which shifts are defined?" | List and show |
| **Tasks** | "Show me the open tasks" | Tasks, task categories and statuses |
| **Production plans** | "List the production plans" | Plans, plan statuses and stoppages |
| **Device commands** | "Which commands exist?" | List the commands, and run one on a device |
| **Schedules** | "List the schedules" | Schedules, jobs and steps |
| **Notifications** | "List the notification targets" | Targets and templates |
| **Process Simulator** | "List the processes" | Processes, machine states and simulations; start, stop, pause and resume simulations and replays |

**Not covered yet:**

- dashboards and reports
- alerts and alert rules
- edge nodes and Edge AI
- work orders and documents
- protocol connections (Modbus, BACnet, OPC UA, SNMP, LoRa)
- the rules engine
- users and administration

## Making changes

**Device and channel changes are confirmed.** Before the assistant creates,
changes or deletes a device or a channel, or connects one to the other, a
dialog shows:

- what the assistant wants to do
- the details it will send, for example the name, type and group

The user clicks **Execute** (or **Delete** for a deletion) or **Cancel**.

- **Cancel:** nothing is changed, and the assistant says so.
- **Several changes in one step:** shown in one dialog and confirmed
  together.
- **Group:** a new device is created in one of the user's own groups.

**Lab run:** the assistant was asked to create a device named
*ai-demo-sensor* in the *bess-enclosure* group, and then to delete it. Both
requests opened a confirmation dialog, and both changes were made only after
the confirmation.

![Confirming a new device](images/09-ai-assistant/confirm-create.png)
*"Create a device named ai-demo-sensor in the bess-enclosure group": the assistant shows the device it will create, with its name, type and group, and waits for the user.*

![Result of the change](images/09-ai-assistant/create-result.png)
*After the confirmation, the new device as a card, and the assistant's summary.*

![Confirming a deletion](images/09-ai-assistant/confirm-delete.png)
*"Delete the device ai-demo-sensor": a red confirmation dialog. In this preview it names the device by its ID only.*

**Device commands and simulations** run without a confirmation dialog in
this preview (see [Current scope](#current-scope)).

## Answers

- **Tables:** for lists, for example channels, tasks or organizations. A
  table shows up to six columns and scrolls.
- **Cards:** for one record, for example a device that was just created.
- **Charts:** a chart view for device readings is prepared, but not yet
  shown reliably in this preview.
- **Written answer:** a short summary under the results, for example the
  outcome of a change. For a simple list question ("List the channels"),
  the table is the answer.

## Languages

- **Questions:** in English or in Serbian (Latin script).
- **Page:** the title, buttons and status follow the user's language
  setting.
- **Answers:** the written part comes from the language model, and its
  language depends on the model. Some of the assistant's own messages, and
  the confirmation dialog, are in English only.

![A question in Serbian](images/09-ai-assistant/serbian-question.png)
*"Prikaži listu kanala" (show the list of channels): a question in Serbian, answered with the channel table.*

## The language model

- **Where it runs:** on Ollama, an open-source model server, with a GPU, in
  the customer's environment: on the platform server or on a separate GPU
  server.
- **Which model:** an open-weight model that supports function calling. The
  model is a setting of the installation; the demo uses Qwen 3.8 with 27
  billion parameters. It needs about 18 GB of GPU memory, so a GPU with
  24 GB or more is recommended.
- **Response time:**
  - In the lab, on a laptop GPU, a list question took about one minute.
    Questions with several steps take a few minutes, and up to ten.
  - The model answers one question at a time. Questions from several users
    wait in line.
  - A larger GPU, or a smaller model, answers faster.
- **Privacy:** the question, the platform data the assistant reads, and the
  answer go only to this model server. No outside AI service is used.
- **No history kept:** the conversation lives only in the open browser page.
  It is gone when the page is closed or reloaded, or when the user starts a
  new chat. Nothing is stored on the platform.

## Access and permissions

- **Menu:** *AI Assistant* in the main menu, for users with the AI Assistant
  role. The administrator role includes it.
- **The user's own login:** every call goes to the platform with the user's
  login, and the platform checks it. A user sees and changes only the
  devices and records of their own groups.
- **Status:** the page shows whether the model server is online.

## Current scope

This list gives sales engineers the current boundaries, so a proposal
matches what the platform delivers today.

- **Preview:** the assistant handles direct questions and requests about one
  kind of record best, for example "List the channels" or "Create a device
  named X in group Y".
- **Finding records:**
  - It cannot yet filter devices by group or by name. "List the devices in
    group X" or "How many devices does group X have?" shows all devices
    instead of the answer.
  - A device is found by name only among the first 100 devices.
  - For a simple list question, the table is the answer: the assistant does
    not count or filter it.
- **Large results:** very large lists can exceed what the model can read at
  once. The question then ends without a written answer.
- **Tables:**
  - They show the fields as they are stored, including IDs, and some
    columns stay empty.
  - When an answer starts with a table, the written part after it is not
    shown yet.
  - Device tables show each device's key, so the role should be given only
    to users who may see device keys.
- **Device data:** the latest 10 readings of one device. When the device is
  looked up by name, the answer currently stops at the device table (see
  *Tables*), and charts are not shown yet.
- **Confirmation:** device and channel changes are confirmed. Device
  commands and simulation controls run without a dialog, so the role should
  be given only to users who may run them.
- **Links:** the links from the answers to the platform pages do not open
  the page yet.
- **Languages:** English and Serbian in Latin script. Some texts are in
  English only.
- **No saved conversations,** and no export.
- **Response time and capacity:** one question at a time per model server;
  answers take from about a minute to several minutes on a laptop GPU.
- **Installation:** the model server is set up for each project. It is part
  of the platform's development and demo installation, not yet of the
  standard production installation.

## Questions to ask the customer

- Who would use the assistant: operators, engineers, managers? Which
  questions would they ask most often?
- Should it only answer questions, or also make changes?
- Is there a server with a suitable GPU on site, or should one be included?
- Are there rules for AI use: must the model run on site, be open source, or
  come from a specific vendor?
- Which languages are needed?
- How many people would use it at the same time, and what response time is
  acceptable?
