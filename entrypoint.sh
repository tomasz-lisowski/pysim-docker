#!/bin/bash
set -o nounset -o errexit -o xtrace;

pcscd;

cd "/opt/pysim";

lsusb;
/opt/venv/bin/python3 ./pySim-shell.py --pcsc-device 0;
