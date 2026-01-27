## Started: May 31, 2025
## Temperature sensor added: Dec 25, 2025
## Automation scripts added: Dec 28, 2025

Beginning of work on IoT 'wing' of Vesper. Will remain a side-priority for the immediate future.

ESP32 + :
- ST7789V-controller LCD display
- DS18B20 temperature probe (with 4.7k Ohm pull-up resistor)

## Quick Reference

Each time we open the project:
```bash
source ./dev.sh     # Attaches USB device for passthrough (windows), then activates environment in current shell, & runs setup export.sh script/sets PATH stuff.
```
**Note:** Don't use `./dev.sh` alone. It runs in a subshell, so the venv activates there but disappears when the subshell exits.

## Hardware

**Temperature Sensor:** DS18B20 waterproof probe
- Protocol: 1-Wire (multiple devices on single data line)
- **Requires external 4.7kΩ pull-up resistor** between data line and 3.3V
- Wiring: Red (3.3V), Black (GND), Data (GPIO 4)

**Display:** ST7789V controller, 240x320 resolution (Seengreat)
- Interface: SPI
- No pull-up resistors needed

## Development Workflow

```bash
source ./dev.sh       # Activate environment
idf.py build          # Compile
idf.py flash monitor  # Flash to ESP32 & view serial output (in terminal)
```

## Dec 28, 2025: Added dev.sh to spare us the pain of some "every time we open the project to work" setup.
So each time we boot things up to work, we'll have to run the below:
```bash
source ./dev.sh

# Note: Running just this below instead doesn't work. It runs in subshell so the venv becomes active there, but when we exit the subshell, venv goes too.
./dev.sh
```

## Temperature sensor setup Dec 25, 2025 :D

Reminders:
- The compiler used is determined by file extension? So we're rolling with C but could switch to C++
- CMakeLists.txt in root is boilerplate required for ESP-IDF. Basically never touch this.
- CMakeLists.txt in main/ is where we specify what code to compile
    - SRCS: our source files (main.c, hello_world.c, etc)
    - REQUIRES: extern libs we need (esp_driver_spi & esp_driver_gpio for our display)

## Notes on install stuff/steps to get ESP-IDF working in WSL:

1. Install ESP-IDF Requirements for Linux
```bash
sudo apt-get install git wget flex bison gperf python3-pip python3-venv python3-setuptools cmake ninja-build ccache libffi-dev libssl-dev dfu-util
```
2. Install `usbipd` in Powershell command prompt & follow their instructions at: TODO-ADD-LINK
```bash
winget install usbipd
```

3. Set up ESP-IDF stuff in WSL
```bash

```


## Temperature sensor notes:
Using a DS18B20 temperature probe, which requires both the db18b20 drivers as well as the OneWire protocol, which is a comm protocol that lets multiple devices share a single data wire. The DS18B20 temp sensor uses this protocol.


## Project Structure notes

`CMakeLists.txt` in `main/` tells ESP-IDF build sys how to compile our "component" (the "main" component). Invoking the idf_component_register function looks as follows:

```c
idf_component_register(SRCS "main.c" "my_helper_file.c"             // source files to compile
                    PRIV_REQUIRES spi_flash espressif__onewire_bus  // private deps (components we use internally)
                    INCLUDE_DIRS ""                                 // add'l header search paths, usually empty unless we have custom headers to expose
                    REQUIRES esp_driver_gpio)                       // public deps (components we expose to others)
```


## Notes

- Compiler determined by file extension (.c = C, .cpp = C++)
- `dev.sh` handles USB passthrough + ESP-IDF environment setup
- Internal pull-up resistors insufficient for DS18B20 with long cable - external 4.7kΩ required
