#!/bin/bash
set -o nounset -o errexit -o xtrace;

readonly reader_index=${1:?Argument 1 missing: Reader index.};

pcscd;
sleep 1;

cd "/opt/pysim";
if [ ! -f "/opt/startup.pysim" ]; then
    touch "/opt/startup.pysim";
fi
/opt/venv/bin/python3 ./pySim-shell.py --script /opt/startup.pysim --pcsc-device "${reader_index}";
