FROM debian:12.6-slim AS base

FROM base AS main
RUN set -o nounset -o errexit -o xtrace; \
    apt-get -qq update; \
    apt-get -qq --yes dist-upgrade; \
    apt-get -qq --yes --no-install-recommends install meson pkg-config cmake libusb-1.0-0-dev zlib1g-dev flex git wget ca-certificates usbutils gcc gcc-multilib libudev1 libusb-1.0-0 libccid libacsccid1 pcscd pcsc-tools libpcsclite-dev python3 python3-dev python3-venv python3-setuptools python3-pycryptodome python3-pyscard python3-pip; \
    mkdir -p "/opt/tmp"; \
    cd "/opt/tmp"; \
    wget -O pysim.tar.gz "https://github.com/osmocom/pysim/archive/12902730bf4ff216ada3b237a6658071625fb92d.tar.gz"; \
    sha256sum pysim.tar.gz; \
    echo "4a7ba43ec23c88fb3c89e8617ce011a006b9ae841e3a61368f2af36330cf8e89 pysim.tar.gz" | sha256sum --check --status; \
    mkdir -p /opt/pysim; \
    tar -xzf pysim.tar.gz --strip-components=1 -C /opt/pysim; \
    cd /opt/pysim; \
    python3 -m venv /opt/venv; \
    /opt/venv/bin/pip3 install -r requirements.txt; \
    cd "/opt/tmp"; \
    wget -O ccid.tar.gz "https://github.com/LudovicRousseau/CCID/archive/7baac62d9ee4f6f74e7f91a249b40045f396239d.tar.gz"; \
    sha256sum ccid.tar.gz; \
    echo "91d90d86b9c39342f18d8109aad1f30c7a58b4719600aaea9d45aa1cc0f37ca3 ccid.tar.gz" | sha256sum --check --status; \
    mkdir "/opt/ccid"; \
    tar -xzf ccid.tar.gz --strip-components=1 -C /opt/ccid; \
    cd "/opt/ccid"; \
    meson setup builddir; \
    cd "/opt/ccid/builddir"; \
    meson compile; \
    meson install;

COPY ./entrypoint.sh /opt/entrypoint.sh
ENTRYPOINT [ "/opt/entrypoint.sh" ]
