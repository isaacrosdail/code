#include <stdio.h>
#include "esp_log.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "onewire_bus.h"
#include "ds18b20.h"

#include "temperature.h"

#define ONEWIRE_BUS_GPIO    4
#define ONEWIRE_MAX_DS18B20 2

// static => "file-scope only"
static onewire_bus_handle_t bus = NULL;
static ds18b20_device_handle_t ds18b20s[ONEWIRE_MAX_DS18B20];
static int ds18b20_device_num = 0;

static const char *TAG = "test";

void temperature_init(void) {
    // install 1-wire bus
    onewire_bus_config_t bus_config = {
        .bus_gpio_num = ONEWIRE_BUS_GPIO,
        .flags = {
            .en_pull_up = true, // enable the internal pull-up resistor in case the extern device doesn't have one. TODO: Change this once we order a 4.7k ohm pull-up resistor :D
        }
    };
    onewire_bus_rmt_config_t rmt_config = {
        .max_rx_bytes = 10, // 1byte ROM command + 8byte ROM number + 1byte device command
    };

    ESP_ERROR_CHECK(onewire_new_bus_rmt(&bus_config, &rmt_config, &bus));
    ESP_LOGI(TAG, "1-Wire bus installed on GPIO%d", ONEWIRE_BUS_GPIO);

    // Test if bus is responsive at all
    onewire_bus_reset(bus);
    ESP_LOGI(TAG, "Bus reset attempted");

    onewire_device_iter_handle_t iter = NULL;
    onewire_device_t next_onewire_device;
    esp_err_t search_result = ESP_OK;

    // create 1-wire device iterator, which is used for device search
    ESP_ERROR_CHECK(onewire_new_device_iter(bus, &iter));
    ESP_LOGI(TAG, "Device iterator created, start searching...");
    do {
        search_result = onewire_device_iter_get_next(iter, &next_onewire_device);
        if (search_result == ESP_OK) { // found a new device, let's check if we can upgrade it to a DS18B20
            ds18b20_config_t ds_cfg = {};
            onewire_device_address_t address;
            // check if the device is a DS18B20, if so, return the ds18b20 handle
            if (ds18b20_new_device_from_enumeration(&next_onewire_device, &ds_cfg, &ds18b20s[ds18b20_device_num]) == ESP_OK) {
                ds18b20_get_device_address(ds18b20s[ds18b20_device_num], &address);
                ESP_LOGI(TAG, "Found a DS18B20[%d], address: %016llX", ds18b20_device_num, address);
                ds18b20_device_num++;
                if (ds18b20_device_num >= ONEWIRE_MAX_DS18B20) {
                    ESP_LOGI(TAG, "Max DS18B20 number reached, stop searching...");
                    break;
                }
            } else {
                ESP_LOGI(TAG, "Found an unknown device, address: %016llX", next_onewire_device.address);
            }
        }
    } while (search_result != ESP_ERR_NOT_FOUND);
    ESP_ERROR_CHECK(onewire_del_device_iter(iter));
    ESP_LOGI(TAG, "Searching done, %d DS18B20 device(s) found", ds18b20_device_num);
}

float temperature_read(void) {
    // We have our temp sensor connected via the 1-Wire protocol on GPIO pin 4.
    /* Sensor doesn't continuously broadcast temperature, we have to:
        1. Ask it to measure ("trigger conversion")
        2. Wait for it to finish
        3. Request the result
    */
    // Without this check, accessing ds18b20[0] when no sensor exists would crash due to null pointer dereference.
    if (ds18b20_device_num == 0) {
        ESP_LOGW(TAG, "No DS18B20 sensors found"); // ESP32 logging at the W warning level
        return -999.0f; // Error "sentinel"
    }

    float temperature;
    ESP_ERROR_CHECK(ds18b20_trigger_temperature_conversion(ds18b20s[0]));
    vTaskDelay(pdMS_TO_TICKS(800)); // Wait for conversion
    ESP_ERROR_CHECK(ds18b20_get_temperature(ds18b20s[0], &temperature));

    return temperature;
}
