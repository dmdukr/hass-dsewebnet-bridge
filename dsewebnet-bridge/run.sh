#!/bin/sh

CONFIG="/data/options.json"

export DSE_USERNAME=$(python3 -c "import json; print(json.load(open('$CONFIG'))['dse_username'])")
export DSE_PASSWORD=$(python3 -c "import json; print(json.load(open('$CONFIG'))['dse_password'])")
export GATEWAY_ID=$(python3 -c "import json; print(json.load(open('$CONFIG'))['gateway_id'])")
export MODULE_ID=$(python3 -c "import json; print(json.load(open('$CONFIG'))['module_id'])")
export MQTT_HOST=$(python3 -c "import json; print(json.load(open('$CONFIG'))['mqtt_host'])")
export MQTT_PORT=$(python3 -c "import json; print(json.load(open('$CONFIG'))['mqtt_port'])")
export MQTT_USER=$(python3 -c "import json; print(json.load(open('$CONFIG'))['mqtt_user'])")
export MQTT_PASS=$(python3 -c "import json; print(json.load(open('$CONFIG'))['mqtt_pass'])")
export POLL_INTERVAL=$(python3 -c "import json; print(json.load(open('$CONFIG'))['poll_interval'])")

echo "Starting DSEWebNet Bridge..."
echo "MQTT: ${MQTT_HOST}:${MQTT_PORT}"
echo "Gateway: ${GATEWAY_ID}, Module: ${MODULE_ID}"

exec python3 /dsewebnet-bridge.py
