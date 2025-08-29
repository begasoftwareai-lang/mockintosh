FROM python:3.9-slim AS runtime

# Evita prompts y reduce tamaño
ENV DEBIAN_FRONTEND=noninteractive \
    PIP_NO_CACHE_DIR=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Dependencias de build y librerías nativas
RUN apt-get update && apt-get install -y --no-install-recommends \
      build-essential gcc curl ca-certificates \
      librdkafka-dev \
    && rm -rf /var/lib/apt/lists/*


WORKDIR /usr/src/mockintosh

COPY requirements.txt .
RUN pip3 install -r requirements.txt

COPY setup.cfg .
COPY setup.py .
COPY README.md .
COPY mockintosh/ ./mockintosh/

RUN pip3 install .

WORKDIR /tmp
RUN mockintosh --help

ENTRYPOINT ["mockintosh"]
