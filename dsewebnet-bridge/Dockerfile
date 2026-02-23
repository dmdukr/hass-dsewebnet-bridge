FROM python:3.11-alpine

RUN pip install --no-cache-dir aiohttp paho-mqtt

COPY run.sh /run.sh
COPY dsewebnet-bridge.py /dsewebnet-bridge.py

RUN chmod +x /run.sh

CMD ["/run.sh"]
