# 5. Process Simulator

*Nova Vector Platform · feature document 5 of 13 · October 2026 · for clients and sales engineers*

[← Feature overview](FEATURES.md)

The Process Simulator is an operational digital twin. It models a process,
such as a bottling line, a battery enclosure or an assembly line, as a set of
machines. Each machine moves through states such as running, blocked,
starved, down or changeover. Rules link the machines to each other and to the
state of the whole process.

The model then works in two ways:

- **Live mode:** the model follows the real device data and shows, at any
  moment, which state each machine is in and why.
- **Simulation mode:** recorded data is replayed through a copy of the model,
  faster than real time, to investigate an incident or to compare runs.

Every state change is logged with the version of the model that made it.

## Contents

- [What a model is made of](#what-a-model-is-made-of)
- [Live mode](#live-mode)
- [Versions and lifecycle](#versions-and-lifecycle)
- [Execution log and snapshots](#execution-log-and-snapshots)
- [Simulations](#simulations)
- [Comparing runs and versions](#comparing-runs-and-versions)
- [Current scope](#current-scope)
- [Questions to ask the customer](#questions-to-ask-the-customer)

---

## What a model is made of

A model is built step by step in forms, from the following building blocks.

| Building block | What it is | Example from the bottling line |
| --- | --- | --- |
| **Process** | The line, system or site being modelled | *Production line* |
| **Process thing** | One machine or element of the process, linked to a real device | *m1 – Filler*, linked to the filler's PLC |
| **Machine states** | The states a machine can be in, each with a state type | idle, running, blocked, starved, down, changeover, no data |
| **State transitions** | The rules that move a machine from one state to another | *running → down* when the PLC reports `state == "down"` |
| **Data sources** | The device readings a machine's rules read | The filler's `state` reading on its channel |
| **Linking rules** | Rules between machines | When a conveyor jams, the next machine is starved |
| **Process states** | The state of the whole process, derived from its machines | Running, Degraded, Breakdown |
| **Actions** | What happens when a rule fires | Open a maintenance task, send a command to a device |

### Process things

A process thing stands for a machine, conveyor, sensor or other element. It
is linked to one real device in the device registry and has a role, such as
*Filler* or *Buffer M1 → M2*. The same device can take part in several
processes.

![Process things](images/05-process-simulator/process-things.png)
*The eleven process things of the bottling line: four machines, three conveyors, an energy meter, the hall climate, the andon board and the line itself, each linked to its device.*

### Machine states and state types

Each machine has its own list of states. Each state has a **state type**,
which gives it a colour, an icon and a meaning that is the same across all
processes.

State types are grouped into categories, and a catalogue aligned with
ISA-88 and PackML can be imported. It has categories for lifecycle,
operational condition, maintenance mode, safety state and administrative
state, with types such as Idle, Execute, Held, Suspended, Fault and
Emergency Stop. A running machine is therefore always shown the same way,
whichever line it is on.

![Machine states](images/05-process-simulator/machine-states.png)
*The seven states of the filler, each with its state type: Idle, Execute, Suspended, Fault or Held.*

![State type categories](images/05-process-simulator/state-type-categories.png)
*State type categories aligned with ISA-88 and PackML, with colours, icons and descriptions.*

### State transitions

A transition moves a machine from one state to another. It has one of four
triggers:

| Trigger | When it fires |
| --- | --- |
| **Condition** | When an expression over the machine's readings becomes true, for example `state == "down"` or `temperature > 32` |
| **Time** | After the machine has spent a given time in the state |
| **Event** | When a matching message or reading arrives, or when the machine's data stops for longer than its no-data time |
| **Manual** | When a user fires it from the screen |

- **Priority:** when several transitions could fire, the one with the
  highest priority (the lowest number) wins.
- **Editing expressions:** the editor shows the machine's variables as chips
  to click.
- **Checking:** expressions are checked when the model is published, so a
  broken rule is caught before it goes live.

![State transitions](images/05-process-simulator/state-transitions.png)
*Some of the filler's 42 transitions, with their from-state, to-state, trigger type and priority.*

![Editing a transition](images/05-process-simulator/transition-edit.png)
*Editing the transition from running to down: a condition trigger with the guard `state == "down"`, a priority, and the data source it reads.*

### Data sources and variables

A data source tells a machine which readings to listen to: a channel, an
optional subtopic, a reading name and a unit. It also sets a no-data time.
Each data source gives its readings a **variable** name for use in
expressions. Built-in variables, such as the channel and subtopic of the last
message, are also available.

![Data sources](images/05-process-simulator/data-sources.png)
*The filler's data source: the `state` reading on the filler's channel, with a no-data time of 60 seconds.*

### Linking rules between machines

A linking rule sets one machine's state when another machine enters a state.
For example, when the labeller goes down, the packer is starved. A rule can
have its own condition, and it can apply to any state of the source machine.
Chains of rules are followed automatically, and loops are detected and
stopped.

### Process states

The process itself has states, such as Running, Degraded or Breakdown. Its
transitions read the states of its machines, for example "Degraded when any
conveyor is jammed". The current process state is shown at the top of the
diagram, and its history in the timeline strip.

### Actions

A transition can trigger actions when it fires in live mode:

- **Open a task:** for example, a maintenance task when a machine goes down,
  with a description built from the event (see
  [Alerts, Notifications and Tasks](04-alerts-notifications-and-tasks.md#tasks)).
- **Send a command** to a device.
- **Start or stop a heartbeat.**

## Live mode

In live mode, the Process Simulator listens to the devices' channels.

- **Rules on every reading:** each reading updates the machine's variables,
  and the platform evaluates its transitions straight away.
- **On a firing transition:** the new state is stored, the change is
  logged, the actions run, and the linking rules and process rules follow.
- **Restarts:** the current state of every machine is kept, and it survives
  a restart of the service.

The **Diagram** tab shows the model at work:

- **Cards:** one per machine, with its role, its current state in the
  colour of its state type, and its latest readings, or *No data*.
- **Linking rules:** lines between the cards, which flash when a rule fires.
- **Process state:** shown at the top.
- **Timeline:** a strip with the history of the process state, from 1 minute
  to 30 days.
- **Layout:** cards can be moved and folded, and the layout is saved.

![The bottling line in live mode](images/05-process-simulator/production-line.png)
*The bottling line in live mode. The top strip shows the process moving between Running and Degraded. Each card shows a machine, conveyor or sensor with its current state and its latest readings.*

## Versions and lifecycle

- **Machine definitions:** publishing a machine freezes its states and
  transitions as a numbered, unchangeable version. The version in use is
  shown on the machine, and every log entry records it.
- **Process lifecycle:** draft → validated → active → archived.
  - **Validation:** checks that every machine is enabled and linked to a
    device, and that the machines are published.
  - **Changing an active process:** it cannot be edited in place. *Create new
    version* (or *Clone*) makes a copy to work on. When the copy is ready, it
    is activated and the original is archived.
- **Process definitions:** the process itself is published with a version
  number, such as 1.0.0.

![Process details](images/05-process-simulator/process-details.png)
*The process details: lifecycle status and buttons (reactivate, archive, clone, add simulation), the current process state, and the published process definitions.*

![Processes](images/05-process-simulator/processes.png)
*The process list: three processes, each with its status, current process state and active definition version.*

## Execution log and snapshots

Every state change is written to the **execution log**. Each entry holds:

- the time
- the from-state and to-state
- the trigger
- the version that made the change
- whether it happened live or in a simulation

An entry can be opened to show the data that triggered it. For a process
change, that is the state of every machine at that moment, so the log
explains each change as well as recording it.

The **Snapshot Inspector** on the same tab shows the state of a machine at
any chosen past time.

![Execution log](images/05-process-simulator/execution-log.png)
*The execution log of the bottling line. The open entry shows why the line returned to Running: every machine's state at that moment.*

## Simulations

A simulation **replays recorded data** through a copy of the model. It is
used to investigate an incident, to check how the model behaves on a known
day, or to compare two periods.

**Setting up a simulation:**

- name and speed factor, for example 60 times real time
- the time window to replay, up to 90 days
- the machines to include, up to 100 devices
- the batch size, the maximum gap between messages, and whether to loop

**Preflight check:** before the run, it confirms that:

- the process exists
- every device has a data source
- there is recorded data in the window, with the number of records and the
  first and last time for each device

**Running:**

- Start, pause, resume and stop.
- The Diagram tab shows two timelines, the recorded process state (*source*)
  and the simulated one, so differences stand out.
- While the run is going, a status tab shows each device's progress.

**Kept apart from real data:**

- The replayed data is stored separately, labelled with the simulation.
- Actions are switched off during a simulation, so no tasks are opened and
  no commands are sent.

![A running simulation](images/05-process-simulator/simulation-running.png)
*A replay of the last hour of the bottling line at 60 times real time. The source timeline (top) and the simulated timeline (bottom) are shown together, above the live machine cards.*

![Preflight check](images/05-process-simulator/simulation-preflight.png)
*The preflight check before a replay: all checks passed, with the number of records and the time range for each of the nine devices.*

![A finished simulation](images/05-process-simulator/simulation-finished.png)
*A replay of the hour before. The simulated timeline shows a short period of lost contact, as well as Running and Degraded.*

## Comparing runs and versions

- **Compare runs:** select two or more simulations of a process to compare
  them side by side. The comparison shows each run's times, its number of
  transitions and its number of state entries.
- **Compare versions:** two published versions of a process can be compared
  over a date range, with transitions and time in state for each machine.

![Comparing runs](images/05-process-simulator/compare-runs.png)
*Two replays of the bottling line compared: the hour before had 304 transitions and 214 state entries, the last hour 238 and 166.*

## Current scope

This list gives sales engineers the current boundaries, so a proposal matches
what the platform delivers today.

- **Modelling:** models are built in forms, not drawn. The diagram arranges
  and shows the model, but is not an editor. Models cannot yet be exported
  or imported between installations.
- **States, not material flow:** machines are linked by state rules. Buffer
  levels, work in progress, cycle times and throughput are not modelled, and
  KPIs such as OEE are not calculated by the Process Simulator.
- **Actions:**
  - Notification actions, webhooks and setting values on devices are not
    available yet.
  - Event triggers on task status, and the alert action set up in the
    screens, do not work yet.
- **Simulations:**
  - **Replay only:** simulations replay recorded data. A simulation without
    replay moves only time-based transitions.
  - **No what-if editing yet:** editing a simulation's copy of the model,
    promoting a simulation's model to the live process, and running a replay
    against a chosen older version are not available from the screens yet.
  - **Timing:** times in a simulation's log are real (sped-up) run times, not
    the original times. A run starts from the live state, not from the state
    at the start of the window.
  - **Statistics:** guard statistics in the comparison and the diagnostics
    view are not filled in yet.
- **Sizing:** no published benchmark figures exist yet. Sizing is done for
  each project.

## Questions to ask the customer

- Which lines, systems or sites should be modelled first, and which machines
  do they contain?
- Which states does the customer use today for each machine (for example,
  PackML states), and how are they read from the machine: a state code, a
  set of signals, or alarms?
- Which states of the whole line matter to management: running, degraded,
  breakdown, changeover?
- Which events should open a task automatically, and for which team?
- Which past incidents or periods should be replayed first?
- Is the main goal live visibility, root-cause analysis of incidents, or
  testing changes before making them?
