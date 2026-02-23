# DSEWebNet Bridge — Home Assistant App

Connects a DSE generator (DSE6110 MKIII + DSE 0890-04 gateway) to Home Assistant via DSEWebNet cloud WebSocket API and MQTT auto-discovery.

> 🤖 This add-on — including reverse engineering of the DSEWebNet WebSocket protocol, all Python code, HASS configuration, and this repository — was **fully created by [Claude](https://claude.ai) (Anthropic) without a single line of code written by me**. I only provided hardware access and answered questions.

---

*[Українська версія нижче / Ukrainian version below](#dsewebnet-bridge--home-assistant-додаток)*

---

## Installation

1. In Home Assistant go to **Settings → Apps → Install Apps**
2. Click **⋮ → Repositories**
3. Add: `https://github.com/dmdukr/hass-dsewebnet-bridge`
4. Find **DSEWebNet Bridge** and click **Install**
5. After installation go to the **Configuration** tab and fill in your parameters
6. Start the add-on

## Step-by-step configuration guide

### `dse_username` and `dse_password`

Your login credentials for [dsewebnet.com](https://www.dsewebnet.com).

1. Go to [www.dsewebnet.com](https://www.dsewebnet.com) and log in
2. These are the same email and password you use to log in to the website
3. Enter them in the `dse_username` and `dse_password` fields

### `gateway_id` and `module_id`

Both IDs are visible directly on the DSEWebNet page — no developer tools needed.

![DSEWebNet IDs location](https://raw.githubusercontent.com/dmdukr/hass-dsewebnet-bridge/main/docs/dsewebnet-ids.png)

- **Gateway ID** → top right corner: *"Connection made to ID **19XXXXXXXXXXX01** Using Ethernet"*
- **Module ID** → breadcrumb at the top: *WebNet » SiteName » **67XXXXXXF6*** — or left panel: `USB ID: 67XXXXXXF6`

### `mqtt_host`

The address of your MQTT broker.

- If you use the **Mosquitto add-on** built into Home Assistant: enter `core-mosquitto`
- If you use an **external MQTT broker**: enter its IP address, e.g. `192.168.1.100`

### `mqtt_port`

MQTT broker port. Default is `1883`. Only change if your broker uses a non-standard port.

### `mqtt_user` and `mqtt_pass`

MQTT broker credentials.

- If your broker requires authentication: enter the username and password
- If your broker allows anonymous connections: leave both fields empty

For the Mosquitto app, credentials are configured in **Settings → Apps → Mosquitto broker → Configuration**.

### `poll_interval`

How often (in seconds) the add-on actively requests a status update from DSEWebNet. Default is `30`.

The add-on also receives real-time push updates from DSEWebNet via WebSocket, so this is just a fallback poll. There is no need to set it lower than `30`.

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

> **Note:** The **Start** button automatically sends the Manual → Start command sequence. The DSE6110 ignores a Start command when the controller is in Stop mode, so Manual is always sent first.

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

---

---

# DSEWebNet Bridge — Home Assistant Додаток

Підключає дизельний генератор DSE (DSE6110 MKIII + шлюз DSE 0890-04) до Home Assistant через хмарний WebSocket API DSEWebNet та MQTT auto-discovery.

> 🤖 Цей додаток — включаючи реверс-інжиніринг протоколу WebSocket DSEWebNet, весь Python-код, конфігурацію HASS та цей репозиторій — **повністю створено [Claude](https://claude.ai) (Anthropic) без єдиного рядка коду написаного мною**. Я лише надав доступ до обладнання та відповідав на запитання.

## Встановлення

1. В Home Assistant перейди до **Налаштування → Apps → App store**
2. Натисни **⋮ → Repositories**
3. Додай: `https://github.com/dmdukr/hass-dsewebnet-bridge`
4. Знайди **DSEWebNet Bridge** та натисни **Install app**
5. Після встановлення перейди на вкладку **Configuration** та заповни параметри
6. Запусти додаток

## Покроковий гайд з налаштування

### `dse_username` та `dse_password`

Твої облікові дані для входу на [dsewebnet.com](https://www.dsewebnet.com).

1. Перейди на [www.dsewebnet.com](https://www.dsewebnet.com) та увійди в акаунт
2. Це той самий email та пароль, що ти використовуєш для входу на сайт
3. Введи їх у поля `dse_username` та `dse_password`

### `gateway_id` та `module_id`

Обидва ID видно прямо на сторінці DSEWebNet — без інструментів розробника.

![Розташування ID в DSEWebNet](https://raw.githubusercontent.com/dmdukr/hass-dsewebnet-bridge/main/docs/dsewebnet-ids.png)

- **Gateway ID** → правий верхній кут: *"Connection made to ID **19XXXXXXXXXXX01** Using Ethernet"*
- **Module ID** → хлібні крихти вгорі: *WebNet » НазваОб'єкту » **67XXXXXXF6*** — або ліва панель: `USB ID: 67XXXXXXF6`

### `mqtt_host`

Адреса твого MQTT брокера.

- Якщо використовуєш **вбудований додаток Mosquitto** в Home Assistant: введи `core-mosquitto`
- Якщо використовуєш **зовнішній MQTT брокер**: введи його IP-адресу, наприклад `192.168.1.100`

### `mqtt_port`

Порт MQTT брокера. За замовчуванням `1883`. Змінюй тільки якщо твій брокер використовує нестандартний порт.

### `mqtt_user` та `mqtt_pass`

Облікові дані для підключення до MQTT брокера.

- Якщо брокер вимагає автентифікацію: введи логін та пароль
- Якщо брокер дозволяє анонімне підключення: залиш обидва поля порожніми

Для Mosquitto облікові дані налаштовуються у **Налаштування → Apps → Mosquitto broker → Configuration**.

### `poll_interval`

Як часто (в секундах) додаток активно запитує оновлення статусу з DSEWebNet. За замовчуванням `30`.

Додаток також отримує оновлення в реальному часі через WebSocket, тому це лише резервний опит. Немає сенсу встановлювати менше `30`.

---

## Об'єкти HASS

Після запуску всі сутності автоматично з'являються згруповані під одним пристроєм:

```
📦 DSE Generator  (Deep Sea Electronics · DSE6110 MKIII)
├── 📊 Сенсори
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
└── 🔘 Кнопки
    ├── Generator Start         button.generator_start
    ├── Generator Stop          button.generator_stop
    ├── Generator Auto          button.generator_auto
    └── Generator Manual        button.generator_manual
```

> **Примітка:** Кнопка **Start** автоматично надсилає послідовність Manual → Start. DSE6110 ігнорує команду Start у режимі Stop, тому Manual завжди надсилається першим.

---

## Приклад автоматизації

```yaml
automation:
  - alias: "Запустити генератор при зникненні живлення"
    trigger:
      - platform: state
        entity_id: sensor.dse_generator_mains_state
        to: "Mains Failure"
    action:
      - service: button.press
        target:
          entity_id: button.generator_start

  - alias: "Повернутись в Авто після відновлення мережі"
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

## Протестовано на

| Компонент | Версія |
|-----------|--------|
| Контролер DSE | DSE6110 MKIII |
| Шлюз DSE | DSE 0890-04 |
| Home Assistant OS | 17.1 |
| Home Assistant Core | 2026.2.2 |

---

## Повідомлення про помилки

Знайшов баг? Відкрий issue на GitHub:

**[github.com/dmdukr/hass-dsewebnet-bridge/issues](https://github.com/dmdukr/hass-dsewebnet-bridge/issues)**

Будь ласка, вкажи в репорті:

| Поле | Де знайти |
|------|-----------|
| **Версія додатку** | Налаштування → Apps → DSEWebNet Bridge → вкладка Info |
| **Версія Home Assistant** | Налаштування → Система → Про систему |
| **Логи додатку** | Налаштування → Apps → DSEWebNet Bridge → вкладка Log — скопіюй повний лог |
| **Опис проблеми** | Що сталося, що очікував, кроки для відтворення |
