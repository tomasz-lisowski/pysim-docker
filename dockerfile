# docker build --progress=plain . -t tomasz-lisowski/pysim:1.0.0 2>&1 | tee docker.log;
# docker run --device=/dev/bus/usb/<usb_reader_path> --tty --interactive --rm tomasz-lisowski/pysim:1.0.0;

FROM debian:12.6-slim AS base

FROM base AS main
RUN set -o nounset -o errexit -o xtrace; \
    apt-get -qq update; \
    apt-get -qq --yes dist-upgrade; \
    apt-get -qq --yes --no-install-recommends install git wget ca-certificates usbutils gcc gcc-multilib libudev1 libusb-1.0-0 libccid libacsccid1 pcscd pcsc-tools libpcsclite-dev python3 python3-dev python3-venv python3-setuptools python3-pycryptodome python3-pyscard python3-pip; \
    mkdir -p "/opt/tmp"; \
    cd "/opt/tmp"; \
    wget -O pysim.tar.gz "https://github.com/osmocom/pysim/archive/12902730bf4ff216ada3b237a6658071625fb92d.tar.gz"; \
    sha256sum pysim.tar.gz; \
    echo "4a7ba43ec23c88fb3c89e8617ce011a006b9ae841e3a61368f2af36330cf8e89 pysim.tar.gz" | sha256sum --check --status; \
    mkdir -p /opt/pysim; \
    tar -xzf pysim.tar.gz --strip-components=1 -C /opt/pysim; \
    cd /opt/pysim; \
    python3 -m venv /opt/venv; \
    /opt/venv/bin/pip3 install -r requirements.txt;

COPY ./entrypoint.sh /opt/entrypoint.sh
ENTRYPOINT [ "/opt/entrypoint.sh" ]
