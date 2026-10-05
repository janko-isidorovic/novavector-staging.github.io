# 6. Manufacturing Operations

*Nova Vector Platform · feature document 6 of 13 · October 2026 · for clients and sales engineers*

[← Feature overview](FEATURES.md)

Nova Vector includes a lightweight MES. Production planning and execution
run on the same live data as monitoring, so a work order can be followed from
the plan to the pieces counted at the end of the line, and to the material it
used.

- **Master data:** products, KPIs, materials, recipes and routings.
- **Work orders:** what to make, and how much.
- **Production plans:** which machine makes it, on which day and shift. They
  are built on a drag-and-drop planning board and approved by a supervisor.
- **Production tracking:** good, scrap and rework pieces are counted from the
  machine's own data.
- **Material consumption:** the material used is compared with the recipe.

## Contents

- [How the parts fit together](#how-the-parts-fit-together)
- [Products and KPIs](#products-and-kpis)
- [Materials, recipes and routings](#materials-recipes-and-routings)
- [Work orders](#work-orders)
- [Production plans and the planning board](#production-plans-and-the-planning-board)
- [Counting production from line data](#counting-production-from-line-data)
- [Material consumption](#material-consumption)
- [Shifts, people and attendance](#shifts-people-and-attendance)
- [Stoppages and production reasons](#stoppages-and-production-reasons)
- [Labels and shop-floor systems](#labels-and-shop-floor-systems)
- [Current scope](#current-scope)
- [Questions to ask the customer](#questions-to-ask-the-customer)

---

## How the parts fit together

The screenshots in this document follow one work order on the demo bottling
line through the whole chain:

| Step | Where in the platform | Example from the bottling line |
| --- | --- | --- |
| **Master data** | Production → Manufacturing, Product Definitions | Product C300, *Sparkling water 0.33 L PET*, with its recipe |
| **Work order** | Production → Documents | WO-1003: 2,000 bottles of C300 |
| **Plan** | Plans → Shift Planning Board | WO-1003 on the packer, 5 October, morning shift |
| **Approval** | Plans Supervisor → Approve Plans | The supervisor sets the plan to *Approved* |
| **Production** | Counted from the packer's data | 480 good bottles and 4 scrap: 24 % of the order |
| **Consumption** | Recorded on the plan, compared with the recipe | 492 preforms used, against a standard of 480 |

## Products and KPIs

### Products

Each product is registered once, with:

- its **product code**: the article code that the line's data and the
  customer's ERP use, with room for two more codes
- its **packaging**: quantity and barcode per item, commercial box, transport
  box and pallet
- its weight and an optional parent product

The product page shows the product's dashboard, codes and packaging, and the
alerts and KPIs that refer to it.

![Products](images/06-manufacturing-operations/products.png)
*The seven products of the demo: three bottle formats for the bottling line and four server models for the assembly line, each with its product code.*

### KPIs

A KPI links a product to a machine. Its main value is the **validated
speed**: the rate at which the machine is approved to run that product, in
pieces per minute. The planning board uses it to work out how much fits into
a shift.

A KPI can also hold warning and error limits (see
[Current scope](#current-scope)).

![A KPI](images/06-manufacturing-operations/kpi.png)
*The KPI for product A100 on the packer: its validated speed, and fields for warning and error limits.*

## Materials, recipes and routings

### Materials and services

- **Materials:** name, code (for example the ERP part number), unit,
  supplier, and whether the material is tracked by lot.
- **Services:** purchased or internal services, such as changeover labour,
  cleaning-in-place or quality sampling, with a code and a unit.

![Materials](images/06-manufacturing-operations/materials.png)
*The material catalogue: preforms, caps, labels and glue for the bottling line, CPUs and GPUs for the assembly line. The green tag marks lot-tracked materials.*

### Recipes (bills of materials)

A recipe lists what one unit of a product takes. Each line has a quantity per
unit, a unit and a scrap factor, and is one of four kinds:

| Line | Example for one bottle of C300 |
| --- | --- |
| **Material** | 1 preform, 1 cap, 1 label, 0.15 g glue, 0.33 L water, 0.004 kg CO₂ |
| **Service** | 0.001 h of quality sampling |
| **Time** | Labour time per position |
| **Energy** | 0.059 kWh, measured by the line's energy meter |

- **Versions:** draft → active → retired.
  - Only a draft can be edited.
  - *New version* copies the recipe into a new draft.
  - Activating a version retires the version it replaces.
- **Alternatives:** a product can have several active recipes, such as A and
  B, or a separate burn-in recipe, and one of them is the default.
  - A work order uses the default.
  - A planner can choose another alternative for a single work order.

![A recipe with its bill of materials](images/06-manufacturing-operations/recipe.png)
*A recipe (bill of materials) with materials, a service and energy per unit. It has versions, alternatives and a default.*

### Routings

A routing lists the operations that make the product. Each operation has:

- a number and a name
- a work centre (the machine)
- a set-up time and a run time per unit
- its preceding operations
- a flag that marks the count point, where finished pieces are counted

Routings have the same versions, alternatives and default as recipes.

![A routing](images/06-manufacturing-operations/routing.png)
*The routing for A100: fill, cap, label and pack, each on its machine, with the packer as the count point.*

## Work orders

A work order is a document of a work-order type.

- **Type settings:**
  - number prefix and automatic numbering
  - whether production and material consumption are tracked
  - the status a work order moves to when every item is produced
- **Work order fields:** number, status, priority, due date, assignee,
  machine and description.
- **Items:** the products to make, with quantities, and services such as
  changeover labour or cleaning.
- **Statuses:** each group keeps its own list, for example Draft, Approved,
  Released, In Progress, On Hold, Completed and Closed.
- **Creating work orders:** in the screens, or through the API from another
  system.
- **Printing:** each work order has a print view.

![Work orders](images/06-manufacturing-operations/work-orders.png)
*Five work orders across the two demo lines, with their type and status.*

## Production plans and the planning board

A **production plan** covers one machine or line for one shift on one day.
It lists:

- the products to make, each with its quantity and work order
- the planned stoppages, with their durations
- the people on the shift

Plans can be created one at a time, uploaded from an Excel template, or built
on the planning board. The template has columns for date, shift, line,
product code, quantity and stoppage minutes.

### The shift planning board

- **Layout:** each row is a machine enabled for planning, and each column is a
  shift plan in the chosen date range.
- **Backlog:** the left panel holds the approved work orders that are not yet
  planned, sorted by priority, and the catalogue of planned stoppages.
- **Drag and drop:**
  - a work order from the backlog onto a shift
  - from one shift to another, also onto another machine
  - back to the backlog
  - a planned stoppage, such as a changeover, onto a shift
- **Capacity:**
  - The board takes the product's validated speed on that machine and the
    shift time left after stoppages.
  - It shows how much fits, and moves the rest of a large order into the
    following shifts.
- **Saving:** changes are saved together with *Save*, or straight away with
  auto-save.
- **Settings for each organization:**
  - which work-order type and status feed the backlog
  - the maximum number of products per shift
  - whether a product needs a KPI before it can be planned
  - auto-save

![Shift planning board](images/06-manufacturing-operations/shift-planning-board.png)
*Work order WO-1003 (2,000 bottles of C300) dragged from the backlog onto the morning shift of 5 October on the packer.*

### Approval

Supervisors approve plans on the **Approve Plans** page, where the
approval is recorded with their name and time.

Only approved plans count production for a work order. A plan therefore
stays a draft until it is confirmed.

![Approve Plans](images/06-manufacturing-operations/approve-plans.png)
*The week's shift plans for the packer. The morning shift of 5 October has been approved, and the others are still drafts.*

![Plan details](images/06-manufacturing-operations/plan-details.png)
*The approved plan: status, date, line and shift, who approved it and when, and the product with its code and quantity.*

## Counting production from line data

For each approved plan linked to a work order, the platform adds up the
machine's readings within the shift. The readings are named after the
product code:

| Reading from the machine | Counted as |
| --- | --- |
| `C300` | Good pieces |
| `C300.scrap` | Scrap |
| `C300.rework` | Rework |

A numeric product code gets a `p` in front, so code 4711 becomes `p4711`.

- **Counts per piece or per batch:** each reading carries the pieces made
  since the last one. An edge node or a decoder can turn a machine's running
  counter into such readings.
- **Several work orders on one plan:** when they make the same product, the
  count is shared in proportion to their planned quantities.
- **Manual corrections:**
  - Production records on the plan (good, scrap or rework, with a reason and
    serial numbers) replace or add to the counted figures.
  - The final figure of an item can also be overridden by hand.
- **On the work order:**
  - produced, scrap, rework and final quantities, and progress against the
    ordered quantity
  - a breakdown per plan, with warnings, for example a plan that is not yet
    approved
  - *Recompute production* refreshes the figures
  - when every item is produced, the work order moves to its completed
    status on its own

![Production on a work order](images/06-manufacturing-operations/work-order-production.png)
*WO-1003 after the packer reported eight batches of 60 bottles and two scrap readings: 480 good, 4 scrap, 24 % of the 2,000 ordered.*

## Material consumption

When consumption tracking is switched on for the work-order type, each
work-order item is compared with its recipe.

- **The recipe in use:**
  - Each item is pinned to the recipe version it started with, so a later
    recipe change does not alter the figures of a running order.
  - *Re-pin recipe* moves it to the current default.
- **Figures for each recipe line:**

  | Figure | How it is worked out |
  | --- | --- |
  | **Planned** | Ordered quantity × quantity per unit × (1 + scrap factor) |
  | **Standard** | Produced quantity × quantity per unit × (1 + scrap factor) |
  | **Actual** | What was recorded or measured |
  | **Variance** | Actual − standard |

- **Where the actual figures come from:**
  - **Materials and services:** recorded on the plan's *Consumption* tab, with
    the work order, quantity and unit. Material records also hold lot numbers
    and quantities.
  - **Time:** worked out from the shift hours and the people assigned, and
    can be corrected.
  - **Energy:** read from the machine's energy meter over the shift.
- **On the work order:** the comparison is shown on the work order and in its
  print view.

![Consumption recorded on the plan](images/06-manufacturing-operations/plan-consumption.png)
*Material recorded on the shift plan for WO-1003: preforms (from two lots), caps and labels.*

![Consumption on the work order](images/06-manufacturing-operations/work-order-consumption.png)
*WO-1003 opened: the per-plan breakdown (480 counted on the morning shift) and the consumption table. Preforms used were 492 against a standard of 480 (+12), caps +6 and labels +4. Lines not yet recorded show an actual of 0.*

## Shifts, people and attendance

- **Shifts:** a name, a start hour and a length in hours, for example three
  8-hour shifts from 06:00.
- **Organizations:** plants and lines, each with the machines that belong to
  it and whether it is used for planning.
- **People:**
  - name, employee ID, start and end date, and RFID badge number
  - positions such as operator, line lead or maintenance
- **On the plan:**
  - the people on the shift and the shift leader
  - the *Employee tracking* tab places people on workstations
- **Attendance from RFID badges:**
  - Badge readers at the line are connected as devices and send the badge
    number.
  - The plan matches each badge to a person and shows check-in and check-out
    times.

## Stoppages and production reasons

- **Planned stoppages:** a catalogue, for example changeover, cleaning or
  lunch break, planned on a shift with a duration. They reduce the capacity
  that the board works with.
- **Stoppages during the shift:** recorded on the plan's *Shift production*
  tab, with:
  - a category, a start and an end
  - the solution

  Each one is also stored as a resolved task (see
  [Alerts, Notifications and Tasks](04-alerts-notifications-and-tasks.md#tasks)),
  so stoppages and maintenance work are reported together.
- **Production reasons:** the reasons for scrap and rework, used on
  production records.

Downtime reports per machine and line are built for each project from these
records (see [Dashboards and Reports](03-dashboards-and-reports.md)).

## Labels and shop-floor systems

- **Zebra label printing:**
  - **Templates:** label templates are written in ZPL, the language of
    Zebra printers. They fill in fields from the work order, the item and its
    properties, such as product, quantity, produced quantity and order number.
  - **Printers:** registered by their network address.
  - **Printing:** labels are printed from the work order. The number of copies
    is a fixed number, the item quantity, or a value from the work order.
- **ERP and MES systems:**
  - **Article codes:** product and material codes are meant to be the ERP's
    article codes, so data can be matched both ways.
  - **API:** work orders, plans and production figures are available through
    the platform's API (see [Automation and Integration](FEATURES.md#11-automation-and-integration)).
- **Scales:** connecting industrial scales is project work, done for each
  scale type.

## Current scope

This list gives sales engineers the current boundaries, so a proposal matches
what the platform delivers today.

- **Counting production:**
  - **Readings needed:** the line's readings must be named after the product
    code and carry pieces per reading, not a running total. Where a machine
    only offers a running counter, the conversion is set up at the edge or in
    a decoder, as part of the project.
  - **Refreshing the figures:** work-order figures are refreshed with
    *Recompute production*. Live updating during the shift is being fixed.
- **Consumption:**
  - **Manual records:** material and service use is recorded by people on
    the plan. It is not read from scales, ERP stock movements or
    backflushing.
  - **Lots:** lots are recorded but not traced. There is no genealogy search
    and no check that a lot-tracked material has a lot.
  - **Variance:** it is shown as a quantity, not as a percentage or a cost.
- **KPIs:** validated speed is used for planning. Warning and error limits on
  a KPI are stored but do not raise alerts yet, and OEE is not calculated.
- **Routings:** routings are reference data. Planning and counting do not use
  them yet: there is no scheduling by operation and no tracking per
  operation.
- **Planning board:**
  - **Existing plans only:** it plans into shift plans that already exist,
    created one at a time, uploaded, or seeded for the period. It does not
    generate shifts from a calendar.
  - **Capacity:** it uses an 8-hour shift and the product's validated speed.
    Breaks are entered as planned stoppages.
- **Approval:** approval is a status set by a supervisor. Approved plans are
  not locked against later edits.
- **Stoppages:** stoppages are entered by people. They are not detected from
  machine data or from the [Process Simulator](05-process-simulator.md) yet,
  and reason codes are names without a planned or unplanned type.
- **Shift report:** a PDF shift report in the plan page is being reworked.
  Do not offer it yet.
- **Set up for each project:**
  - **Label printing, and scrap and rework reasons:** switched on for each
    project.
  - **RFID:** reader integration is done for each project.
  - **Scales, ERP and MES:** integration is custom work. There are no
    ready-made connectors.
- **Time zone:** shift times are kept in one time zone for the installation,
  or for each work order.
- **Upload:** plans are uploaded from the platform's own Excel template.
  Work orders cannot be imported from a file yet.

## Questions to ask the customer

- Which lines and machines should be planned, and where on each line are
  finished pieces counted?
- Can the machine at the count point report pieces per product code, or only
  a running counter? Does it report scrap and rework?
- Where do work orders come from today: ERP, spreadsheets, or paper? Should
  the platform receive them through the API?
- Which shifts does the site run, and which planned stoppages (changeovers,
  cleaning, breaks) should the plan include?
- Which materials must be tracked by lot, and how is consumption recorded
  today: by hand, by scales, or by ERP backflushing?
- Are Zebra printers, badge readers or scales already in use on the line?
- Who approves the plans, and what should happen to a plan after approval?
