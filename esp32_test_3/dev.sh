#!/bin/bash
# ESP32 dev environment bootstrap
# Handles USB passthrough & ESP-IDF toolchain setup/init

BUSID=2-2

# 1. Windows side: Attach USB device for ESP32 flashing (passthrough from Windows)
echo "Attaching ESP32 via USB/IP (busid: $BUSID)"
powershell.exe -Command "usbipd attach --wsl --busid $BUSID"
echo "USB device attached"

# 2. Manually activate venv (WORKAROUND: export.sh fails to activate its own venv)
# export.sh needs PyYAML from this venv but doesn't activate it first#
# This path is of course brittle/version-specific
source ~/.espressif/python_env/idf5.4_py3.13_env/bin/activate

# 3. Source ESP-IDF environment (sets IDF_PATH, adds tools to PATH)
source ~/esp/esp-idf/export.sh