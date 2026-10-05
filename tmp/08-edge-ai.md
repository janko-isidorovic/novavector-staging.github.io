# 8. Edge AI

*Nova Vector Platform · feature document 8 of 13 · October 2026 · for clients and sales engineers*

[← Feature overview](FEATURES.md)

Edge AI runs machine-learning models on edge nodes, where the data is
produced. The platform keeps the models, checks that a node can run them,
deploys them, and collects their results:

- **Registry:** each model is stored with its versions and must be approved
  before use.
- **Deployment:** a model is deployed to selected edge nodes and linked to a
  device on each node, for example a battery management system or a camera.
- **Inference on the node:** the node runs the model on every new reading of
  that device, with no round trip to the cloud.
- **Results as data:** the results come back to the platform as ordinary
  data, where dashboards and reports can use them.

Edge AI builds on [Edge Management](07-edge-management.md): the nodes, the
EdgeX devices and the software catalog described there.

## Contents

- [How it works](#how-it-works)
- [The model registry](#the-model-registry)
- [Deploying a model](#deploying-a-model)
- [Results on the platform](#results-on-the-platform)
- [Updates and rollback](#updates-and-rollback)
- [Camera-based models](#camera-based-models)
- [Current scope](#current-scope)
- [Questions to ask the customer](#questions-to-ask-the-customer)

---

## How it works

| Step | Where | In the lab run |
| --- | --- | --- |
| **1. Register the model** | Edge AI → Models | Two models: a sample classifier for numeric readings, and a face model that estimates age bracket and sex |
| **2. Approve a version** | Edge AI → Models | Version 1.0.1 of the face model was uploaded, reviewed and approved with a note |
| **3. Deploy** | Edge AI → Deployments → New deployment | The classifier went to all three nodes, fed by the battery management system. The face model went to nv-edgex-03, fed by the node's camera input |
| **4. Run** | On each node | Each node loaded its model within about a minute and ran it on every new reading |
| **5. Use the results** | Devices, channels, dashboards | Classes, labels and confidence values arrived on the platform within seconds |

On each node, two services from the *nv-edge-ai* bundle do the work:

- **Inference runtime:** loads the model and runs it with ONNX Runtime on the
  node's CPU.
- **EdgeX bridge:** listens to the bound device's readings, turns them into
  model input, calls the runtime, and sends the results to the platform.

The node's agent downloads each model, checks its checksum, activates it,
checks that it is healthy, and reports its state to the platform.

## The model registry

Models are stored in the platform's own registry, next to the software
bundles of [Edge Management](07-edge-management.md#node-types-and-the-software-catalog).

**A model version** is one package. It contains:

- **The model:** in the standard ONNX format, as exported by PyTorch,
  TensorFlow, scikit-learn and most other training tools.
- **A manifest:** inputs and outputs with their shapes, the processor
  architectures it supports (amd64, arm64), and the minimum memory, storage
  and runtime version.
- **Pre-processing:** turns raw readings into model input: scaling, clipping,
  sliding windows, and JPEG decoding, resizing and normalizing for images.
- **Post-processing:** turns model output into results: probabilities,
  the most likely class, label names, thresholds, and aggregation over time.
- **Default input binding:** which kind of device data the model expects.
- **Checksums:** for every file in the package.

**Checks:** the platform checks a package when it is uploaded and again
before it is approved: format, checksums, files, shapes and the binding.

**Lifecycle:** each version moves draft → candidate → approved, and later to
deprecated and retired. Only approved versions can be deployed. Each version
can carry an evaluation summary and its lineage (for example, the training
data or the parent version), and approvals are recorded with a note.

![Model registry](images/08-edge-ai/models.png)
*The face model in the registry: version 1.0.1 approved next to 1.0.0, each with its size, checksum and the actions that its state allows.*

![Approving a model version](images/08-edge-ai/model-approval.png)
*Approving version 1.0.1 of the face model with a review note. The upload form below takes the package, an evaluation summary and the lineage.*

## Deploying a model

A deployment links one approved model version to a set of edge nodes and a
device on those nodes. The wizard has five steps.

**1. Model version:** the model, an approved version, the group and a name.

**2. Targets:** the edge nodes, with each node's architecture, EdgeX address
and capabilities (runtime version and memory).

**3. Runtime:** the execution tier and what to do if the preferred
accelerator is missing.

**4. Binding:** the device on the node whose readings feed the model.

- **Device:** chosen from the node's live EdgeX devices.
- **Readings:** ticked in order; the order sets their position in the model
  input. The wizard shows how many fields the model needs.
- **Value type:** numeric, or binary for images.
- **Output:**
  - *platform:* results go to the platform.
  - *EdgeX:* results are published back on the node as a virtual device, or
    sent as a command to a device on the node, so local logic can act on them
    without the platform.
  - *both*
- **Advanced:** the pre-processing and post-processing can be adjusted, for
  example the scaling of each reading.
- **Validate on the node:** checks that the device and its readings exist on
  the node.

**5. Review and deploy.**

![Choosing the target nodes](images/08-edge-ai/deploy-targets.png)
*Step 2: the three lab nodes, with their architecture, EdgeX address and runtime capabilities.*

![Binding a battery reading](images/08-edge-ai/deploy-binding-numeric.png)
*Step 4 for the classifier: two readings of the battery management system (maximum cell temperature and pack current) feed the model's two input fields. The pre-processing is adjusted to these readings, and the binding is validated on the node.*

**Before anything is sent**, the platform checks each target node:

- the node's architecture
- that the runtime is installed and new enough
- the execution tier
- the free memory and storage

A node that does not meet the model's requirements is rejected with a
reason. Nodes that pass get the model one after another, and each one reports
its progress: emitted, staged, activated, running.

![Review and verdicts](images/08-edge-ai/deploy-review.png)
*The deployment of the classifier: summary, and a compatibility verdict for each of the three nodes.*

![Deployment board](images/08-edge-ai/deployment-board.png)
*The deployment board: each node with its phase, the active version, the runtime placement (cpu) and health, and the events from emitted to running. All three nodes were running within about a minute.*

![Deployments](images/08-edge-ai/deployments.png)
*Three deployments: the classifier on three nodes, and two versions of the face model on one node.*

## Results on the platform

Each deployment gets its own **inference channel**. The node publishes its
results there as ordinary data, under the node:

| Result | Example from the classifier |
| --- | --- |
| Class label | `nvai-sample-numeric/sim-bess-bms/label` = `mid` |
| Class index | `…/class_index` = `1` |
| Confidence | `…/confidence` = `0.67` |

- **Volume:** the model runs on every reading of the bound device. In the
  lab, that was every 5 seconds on each node.
- **Using the results:** they are charted, exported and read through the API
  like any other data, and dashboards and reports can use them.
- **Node status:** the status page of each node shows the active model
  version, where it runs (CPU), its health and the node's free resources.

![Classifier results](images/08-edge-ai/numeric-results.png)
*The inference channel of the classifier: label, class index and confidence from nv-edgex-01 and nv-edgex-02, every 5 seconds.*

![Edge AI runtime on a node](images/08-edge-ai/node-runtime.png)
*The status page of nv-edgex-03: the Edge AI runtime with face model 1.0.1 active on the CPU and healthy, next to the node's bundles.*

## Updates and rollback

- **New version:** a new model version is uploaded, approved and deployed.
  The node downloads it, checks it, switches to it, and checks its health.
  If the new version does not come up healthy, the node goes back to the
  one it ran before.
- **What the node keeps:** the active version, the previous version and one
  staged version.
- **Rollback:** a deployment can be rolled back from its board. Every node of
  the deployment then switches back to the version it ran before.
- **Re-emit:** the deployment can be sent again, for example to a node that
  was offline.

In the lab run, nv-edgex-03 was updated from the classifier to version 1.0.1
of the face model in under a minute.

## Camera-based models

Image models use the same path as numeric ones. A camera on the node, or a
small capture program, posts each picture to the node's EdgeX REST device.
The bridge decodes the JPEG, resizes and normalizes it, and runs the model.

**Lab run:** the face model was deployed to nv-edgex-03, and four test
portraits were posted to the node's camera input. For each picture, the
platform received:

- the age bracket, for example `25-32`
- the sex
- a confidence value
- the two class indexes

![Binding the camera input](images/08-edge-ai/deploy-binding-camera.png)
*Step 4 for the face model: the node's camera device, value type binary, one image feeding the model's 224 × 224 colour input, validated on the node.*

![Face model results](images/08-edge-ai/camera-results.png)
*Results of the face model on nv-edgex-03 for the test portraits: age bracket, sex, confidence and indexes, each within a second of the picture being posted.*

**Privacy:** only the results are stored on the platform, not the pictures.

## Current scope

This list gives sales engineers the current boundaries, so a proposal matches
what the platform delivers today.

- **Hardware:**
  - Models run on the node's CPU. GPU acceleration is prepared but not yet
    available.
  - Nodes can be amd64 or arm64. arm64 has not yet been tested on real
    hardware.
- **One model per node:** a node runs one model at a time.
  - **Switching models:** until a fix ships, the two model versions must have
    different version numbers. Two models that are both 1.0.0, for example,
    collide on the node.
- **Model inputs:**
  - ONNX models with float32 inputs and fixed shapes.
  - Readings from one EdgeX device per deployment, taken from the same
    message or from a sliding window over that device's messages. Readings
    from several devices are not combined yet.
  - Images in JPEG only.
- **Camera models (pilot):**
  - The face model in the catalog is a public research model for
    demonstrations. Its age estimates are rough, and the accuracy for a
    customer case must be validated with the customer's own images.
  - The model expects a picture of the face. Finding the face in a camera
    frame is done by the capture program on the node.
  - Camera hardware on a node (for example, a Raspberry Pi camera) has not
    yet been tested end to end.
  - For camera projects, the node's data export is set up so that pictures
    stay on site.
- **Results:**
  - Each deployment has its own channel, under the edge node.
  - A new deployment of a new version means a new channel, so dashboards and
    alerts built on the old one must be re-pointed.
  - The results do not carry the model version.
  - The results carry no units, so an alert cannot yet tell one result (for
    example the confidence) from another on the same channel. Alerting on
    model results is set up for each project.
- **Control:**
  - Switching a deployment off does not yet stop the model on the nodes, and
    there is no undeploy.
  - Rollback goes back one version, for all nodes of the deployment
    together.
- **Execution tier:** the tier chosen in the wizard is not yet applied on the
  node. The node uses the tier of its runtime bundle.
- **Monitoring:** inference latency and throughput are measured on the node
  but not yet shown on the platform.
- **Governance:**
  - Approval is a role, with no second approver.
  - Model signing is available but switched off by default. Checksums are
    always checked.
- **Custom code steps:** custom pre- and post-processing code (WebAssembly)
  exists in the runtime but cannot yet be packaged through the platform.

## Questions to ask the customer

- What should the model detect or predict: a state, an anomaly, a quality
  class, a count?
- Which readings or images does it need, from which devices, and how often?
- Who trains the model, in which tool, and can it be exported to ONNX?
- What hardware will the nodes have, and is a GPU needed for the expected
  load?
- Should results only be reported, or should the node act on them locally,
  for example by sending a command to a device?
- How are new model versions reviewed and approved, and by whom?
- For cameras: where are they mounted, what must be recognized, and what are
  the privacy rules for the pictures?
