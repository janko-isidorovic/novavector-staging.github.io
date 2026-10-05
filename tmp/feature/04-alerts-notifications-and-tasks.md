# 4. Alerts, Notifications and Tasks

*Nova Vector Platform · feature document 4 of 13 · October 2026 · for clients and sales engineers*

[← Feature overview](FEATURES.md)

Nova Vector watches the incoming data and reacts when something goes wrong.
An **alert** compares a device's readings with limits, and notices when the
device stops reporting. When its state changes, the platform:

- updates the device's status
- e-mails the right people
- can open a **task** for the maintenance or support team

When the reading is back in range, the platform resolves that task on its own.
Tasks can also be created by hand, from production stoppages, from process
rules or through the API. Every change is recorded.

## Contents

- [Alerts](#alerts)
- [Notifications](#notifications)
- [From alarm to task](#from-alarm-to-task)
- [Tasks](#tasks)
- [Current scope](#current-scope)
- [Questions to ask the customer](#questions-to-ask-the-customer)

---

## Alerts

### What an alert watches

An alert watches **one device**, on **one of its channels**, for the readings
with **one unit**, for example `Cel` for an enclosure temperature. Alerts have
an owner group like devices, and they are listed under
*Connectivity → Alerts*.

### Levels and limits

An alert has four levels besides Normal: **Notification**, **Warning**,
**Error** and **No Data**. Notification, Warning and Error each have a lower
and an upper limit. On every reading, the platform checks the levels from the
most severe down:

1. Outside the Error limits → **Error**
2. Otherwise outside the Warning limits → **Warning**
3. Otherwise outside the Notification limits → **Notification**
4. Otherwise → **Normal**

For example, an enclosure temperature alert with a Warning limit of 29 °C and
an Error limit of 32 °C is Normal up to 29 °C, Warning above 29 °C, and Error
above 32 °C.

**No Data:** the alert also has a no-data time in seconds. If the device sends
nothing for that long, the alert changes to No Data. The platform checks for
this every minute.

### What a state change does

- **Device status:** the device's status changes to the alert's state. The
  *Alerts* tab on the device page shows each linked alert, with the worst
  state on its badge.
- **Notification:** if the new level has an e-mail target and a template, the
  platform sends an e-mail (see [Notifications](#notifications)). A target on
  the Normal level sends a "back to normal" e-mail.
- **Task:** if the alert has a task template for this level, a task is opened
  (see [From alarm to task](#from-alarm-to-task)).

![Alerts](images/04-alerts-notifications-and-tasks/alerts.png)
*The alert list, with each alert's state, group and creator. It can be filtered by any column and exported to CSV.*

![Alert limits](images/04-alerts-notifications-and-tasks/alert-limits.png)
*An enclosure temperature alert: the device, channel and unit it watches, a 180-second no-data time, and Warning and Error limits of 29 °C and 32 °C. Each level can have its own e-mail target and template.*

## Notifications

Notifications are sent by **e-mail**. Two building blocks are set up once and
reused by many alerts:

- **Targets:** a named list of e-mail addresses, owned by a group, such as
  *Maintenance shift A* or *Energy managers*.
- **Templates:** the text of the message. A template is either plain text or
  a template with placeholders filled in at send time:

  | Placeholder | Filled with |
  | --- | --- |
  | `{{.Name}}` | The alert's name |
  | `{{.Value}}` | The reading that changed the state |
  | `{{.Unit}}` | The unit of the reading |
  | `{{.AlertID}}` | The alert's ID |

Each alert level has its own target and template. A Warning can go to the
shift lead and an Error to the maintenance team, each with its own wording.
The e-mail's subject is the alert's name. Each installation sends through its
own mail server.

![Notification target](images/04-alerts-notifications-and-tasks/notification-target.png)
*A notification target: a name, an owner group and the e-mail addresses to notify.*

![Notification template](images/04-alerts-notifications-and-tasks/notification-template.png)
*A notification template: plain text, or a template with placeholders for the alert name, value and unit.*

## From alarm to task

An alarm that only sends an e-mail can be missed. Nova Vector can turn it into
a **task** that is owned, tracked and closed.

### The task template

Each alert can carry a **task template** with:

- **Name:** the name of the task to open.
- **Alert level:** the level that opens it: Notification, Warning or Error.
- **Group:** the group that owns the task.
- **Open status and resolved status:** the status a new task gets, and the
  status it moves to when the problem clears.
- **Handle automatically on alert recovery:** resolves the task when the alert
  returns to Normal.
- **Category, device and assignee:** the person assigned must be a task
  technician (see [Tasks](#tasks)).
- **Tags and description:** for example, what to check first.

### The workflow

1. The reading crosses the limit, and the alert reaches the template's level.
2. The platform opens the task, named after the template and ending in
   *Limit Exceeded*, in the open status, for the chosen device and assignee.
   If the device stops reporting, it opens a *No Data* task instead.
3. The team works on the task.
4. When the reading returns to Normal, or the data comes back, the platform
   moves the task to the resolved status and sets its end date. The task
   duration is then the time the problem lasted.
5. A supervisor reviews the task and closes it.

Automatic resolution is skipped when the template switches it off, or when a
person has already edited the task. In that case the team resolves the task
by hand.

The screenshots below come from a run of the simulated "HVAC failure"
scenario on the battery enclosure. The enclosure temperature rose above
32 °C, the alert went to Error, and a task opened. Twenty seconds later the
temperature was back in range and the task was resolved, with no one touching
it.

![Alert task template](images/04-alerts-notifications-and-tasks/alert-task-template.png)
*The task template of the enclosure temperature alert. It opens a Maintenance task at Error level, for the temperature sensor, and resolves it automatically on recovery.*

![The task the alert raised](images/04-alerts-notifications-and-tasks/alert-raised-task.png)
*The alert's Tasks History tab lists the task it opened.*

![Task history](images/04-alerts-notifications-and-tasks/task-history-auto-resolved.png)
*The task's history: created by the alerts service at 14:16:46, and moved to the resolved status at 14:17:06, when the temperature was back in range.*

![Tasks raised by alerts](images/04-alerts-notifications-and-tasks/tasks-from-alerts.png)
*The task list after the scenario. The two enclosure temperature tasks, one per sensor, were created by the alerts service and are already resolved.*

## Tasks

Tasks track maintenance, quality, safety and other work, whether an alert
raised them or a person created them.

### Where tasks come from

- **By hand:** *Tasks → Add new*.
- **From alerts:** as described above.
- **From production stoppages:** when a stoppage is recorded on a production
  plan, a task is created with the stoppage's times, category, reason code and
  resolution (see [Manufacturing operations](FEATURES.md#6-manufacturing-operations)).
- **From process rules:** a Process Simulator rule can open a task when a
  machine reaches a given state (see [Process Simulator](FEATURES.md#5-process-simulator)).
- **Through the API:** for integration with other systems.

### What a task holds

| Field | Description |
| --- | --- |
| Name, group, device | What the task is about and who owns it. The group decides who can see it |
| Status | For example Open, In Progress, On Hold, Resolved, Closed |
| Category | For example Maintenance, Quality, Downtime, Energy, Safety, Inspection |
| Assigned to | A person marked as a task technician |
| Client, campaign, alert, tags | Optional links and labels |
| Start date and end date | The duration is calculated from them, live while the task is open |
| Reason code | Chosen from the category's list, or added on the spot |
| Description and resolution | Free text: what was found and what was done |

**Statuses and categories:** each group defines its own on the *Status* and
*Categories* pages, so every site can use its own vocabulary. Each category
has its own list of reason codes, such as *Replaced*, *Calibrated* or
*Serviced*.

### The task list and task page

- **Task list:** filters for line, category, group, reason code, status and
  date range, plus a filter and sort on every column. It exports to CSV.
- **Task page:**
  - The *Task data* tab shows the description, the resolution and all fields,
    with a count of the reason codes used in the same category.
  - The *Add resolution* button records how the task was resolved.
- **History:** every change is recorded: who changed which field, and when.
  It appears on the *Task history* tab.

![Task details](images/04-alerts-notifications-and-tasks/task-details.png)
*A resolved maintenance task: the resolution text, the reason-code counts for its category, and the task fields with status, resolution, device and duration.*

![Adding a task](images/04-alerts-notifications-and-tasks/task-add.png)
*Adding a task: group, device, status, category, assignee, campaign, start date, tags and description, with an optional resolution.*

![Task categories](images/04-alerts-notifications-and-tasks/task-categories.png)
*Task categories, defined separately for each group.*

## Current scope

This list gives sales engineers the current boundaries, so a proposal matches
what the platform delivers today.

- **Notification channels:** e-mail only, in plain text. SMS, push
  notifications, webhooks and chat tools such as Teams or Slack are not
  available yet. A failed e-mail is not retried.
- **Alarm handling:**
  - Acknowledging, escalating or shelving alarms, and maintenance windows that
    silence them, are not available yet.
  - A single reading changes the state; there is no delay or hysteresis.
  - A value that keeps crossing a limit sends an e-mail each time.
- **What an alert evaluates:**
  - Numeric readings only.
  - An alert selects readings by unit, so two values with the same unit on the
    same device share one alert.
  - Limits must be set for all three levels. A wide range keeps a level that
    is not needed from ever firing.
- **History:** the platform keeps the tasks and e-mails an alert produced,
  but not a timeline of its state changes.
- **KPIs:** KPI warning and error limits are stored, but do not raise alerts
  yet.
- **Tasks:**
  - There is no priority, due date, comments or attachments yet.
  - The assignee is one person. Teams and positions cannot be assigned, and
    the assignee is not notified.
  - A task can be linked to a campaign, but the campaign overview pages are
    not ready yet.
  - Closing a task after review is done by a person.
  - Statuses and categories are set up for each group; none ship by default.
- **Reliability metrics:** task durations and reason codes are recorded and
  exported. MTTR and MTBF reports are built for each project (see
  [Dashboards and Reports](03-dashboards-and-reports.md#reports-built-for-each-project)).

## Questions to ask the customer

- Which conditions must raise an alarm today, and which ones are only
  informational?
- Who must be told at each level, and how: e-mail, SMS, phone, chat tool?
- Which alarms should open a maintenance task, for which team, and in which
  category?
- How are maintenance tasks tracked today, and which statuses, categories and
  reason codes does the team use?
- Who reviews and closes a resolved task?
- Which reliability figures does management expect: MTTR, MTBF, downtime per
  reason?
