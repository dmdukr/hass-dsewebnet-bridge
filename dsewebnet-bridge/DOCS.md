# DSEWebNet Bridge

Connects a DSE generator (DSE6110 MKIII + DSE 0890-04 gateway) to Home Assistant via DSEWebNet cloud WebSocket API and MQTT auto-discovery.

> 🤖 This add-on — including reverse engineering of the DSEWebNet WebSocket protocol, all Python code, and HASS configuration — was **fully created by [Claude](https://claude.ai) (Anthropic) without a single line of code written by me**. I only provided hardware access and answered questions.

---

## Step-by-step configuration guide

### `dse_username` and `dse_password`

Your login credentials for [dsewebnet.com](https://www.dsewebnet.com).

1. Go to [www.dsewebnet.com](https://www.dsewebnet.com) and log in
2. These are the same email and password you use to log in to the website
3. Enter them in the `dse_username` and `dse_password` fields in the **Configuration** tab

### `gateway_id` and `module_id`

Both IDs are visible directly on the DSEWebNet page — no developer tools needed.

![DSEWebNet IDs location](https://raw.githubusercontent.com/dmdukr/hass-dsewebnet-bridge/main/docs/dsewebnet-ids.png)

- **Gateway ID** → top right corner: *"Connection made to ID **19XXXXXXXXXXX01** Using Ethernet"*
- **Module ID** → breadcrumb at the top: *WebNet » SiteName » **67XXXXXXF6*** — or left panel: `USB ID: 67XXXXXXF6`

### `mqtt_host`

- If you use the **Mosquitto broker** app built into Home Assistant: enter `core-mosquitto`
- If you use an **external MQTT broker**: enter its IP address, e.g. `192.168.1.100`

### `mqtt_port`

MQTT broker port. Default is `1883`.

### `mqtt_user` and `mqtt_pass`

MQTT credentials. Leave empty if your broker allows anonymous connections.

For the Mosquitto app, credentials are configured in **Settings → Apps → Mosquitto broker → Configuration**.

### `poll_interval`

How often (in seconds) the add-on actively requests a status update from DSEWebNet. Default is `30`. No need to set lower — the add-on also receives real-time push updates via WebSocket.

---

## HASS Entities

After start, all entities appear automatically grouped under one device:

```
📦 DSE Generator  (Deep Sea Electronics · DSE6110 MKIII)
├── 📊 Sensors
│   ├── Engine State            sensor.dse_generator_engine_state
│   ├── Mains State             sensor.dse_generator_mains_state
│   ├── Load State              sensor.dse_generator_load_state
│   ├── Generator Mode          sensor.dse_generator_mode_state
│   ├── Supervisor State        sensor.dse_generator_supervisor_state
│   ├── Oil Pressure            sensor.dse_generator_oil_pressure
│   ├── Frequency               sensor.dse_generator_frequency
│   ├── Voltage L1-N            sensor.dse_generator_voltage_l1_n
│   ├── Voltage L2-N            sensor.dse_generator_voltage_l2_n
│   ├── Voltage L3-N            sensor.dse_generator_voltage_l3_n
│   ├── Voltage L1-L2           sensor.dse_generator_voltage_l1_l2
│   ├── Voltage L2-L3           sensor.dse_generator_voltage_l2_l3
│   └── Voltage L3-L1           sensor.dse_generator_voltage_l3_l1
└── 🔘 Buttons
    ├── Generator Start         button.generator_start
    ├── Generator Stop          button.generator_stop
    ├── Generator Auto          button.generator_auto
    └── Generator Manual        button.generator_manual
```

> **Note:** The **Start** button automatically sends the Manual → Start command sequence. The DSE6110 ignores a Start command when in Stop mode, so Manual is always sent first.

---

## Automation example

```yaml
automation:
  - alias: "Start generator on power failure"
    trigger:
      - platform: state
        entity_id: sensor.dse_generator_mains_state
        to: "Mains Failure"
    action:
      - service: button.press
        target:
          entity_id: button.generator_start

  - alias: "Return to Auto after mains restore"
    trigger:
      - platform: state
        entity_id: sensor.dse_generator_mains_state
        to: "Mains Available"
        for:
          minutes: 2
    action:
      - service: button.press
        target:
          entity_id: button.generator_auto
```

---

## Tested on

| Component | Version |
|-----------|---------|
| DSE controller | DSE6110 MKIII |
| DSE gateway | DSE 0890-04 |
| Home Assistant OS | 17.1 |
| Home Assistant Core | 2026.2.2 |

---

## Bug reports

Found a bug? Open an issue on GitHub:

**[github.com/dmdukr/hass-dsewebnet-bridge/issues](https://github.com/dmdukr/hass-dsewebnet-bridge/issues)**

Please include the following in your report:

| Field | Where to find |
|-------|--------------|
| **Add-on version** | Settings → Apps → DSEWebNet Bridge → Info tab |
| **Home Assistant version** | Settings → System → About |
| **Add-on logs** | Settings → Apps → DSEWebNet Bridge → Log tab — copy the full log |
| **Description** | What happened, what you expected, steps to reproduce |
