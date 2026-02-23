# Changelog

## 1.0.1
- Fixed Auto command ID (35701, verified from browser traffic)
- Start button now sends Manual → Start sequence automatically
- Fixed command thread-safety (paho callback → asyncio queue)
- Cleaned up logs: status updates, commands, connection events only
- Logs cleared on each restart

## 1.0.0

Initial release.

- DSEWebNet cloud WebSocket → MQTT bridge for Home Assistant
- HASS auto-discovery: 13 sensors + 4 control buttons grouped under one device
- Sensors: Engine State, Mains State, Load State, Generator Mode, Supervisor State, Oil Pressure, Frequency, Voltage L1-N/L2-N/L3-N/L1-L2/L2-L3/L3-L1
- Buttons: Start (auto-sends Manual → Start sequence), Stop, Auto, Manual
- Real-time push updates via WebSocket + configurable polling interval
- Reverse-engineered DSEWebNet WebSocket protocol: CSRF login, subscription, push data, commands
