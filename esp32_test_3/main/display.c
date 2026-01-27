#include "hal/spi_types.h"
#include "driver/spi_master.h" // Main SPI header?
// #include "driver/spi_common.h" // for our SPI stuff
#include "driver/gpio.h"       // added for gpio functions?
// #include "hal/gpio_hal.h"       // or this for gpio functions?
// #include "esp_driver_gpio.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "esp_log.h"

// Your pin assignments
#define PIN_SCK  18
#define PIN_MOSI 23  
#define PIN_CS   5
#define PIN_DC   2
#define PIN_RST  4

static spi_device_handle_t spi; // Made this static and global?

void display_init(void) {
    // Configure SPI bus  <-- REMOVE this comment marker
    spi_bus_config_t buscfg = {
        .sclk_io_num = PIN_SCK,
        .mosi_io_num = PIN_MOSI,
        .miso_io_num = -1,
        .quadwp_io_num = -1,
        .quadhd_io_num = -1
    };
    spi_bus_initialize(SPI2_HOST, &buscfg, SPI_DMA_CH_AUTO);
   
    // Configure display device
    spi_device_interface_config_t devcfg = {
        .clock_speed_hz = 10*1000*1000,  // 10MHz
        .mode = 0,
        .spics_io_num = PIN_CS,
        .queue_size = 7
    };
   
    spi_bus_add_device(SPI2_HOST, &devcfg, &spi);


   
    //  <-- REMOVE this comment marker too
    
    // Reset display (keep this part)
    gpio_set_direction(PIN_RST, GPIO_MODE_OUTPUT);
    gpio_set_level(PIN_RST, 0);
    vTaskDelay(100 / portTICK_PERIOD_MS);
    gpio_set_level(PIN_RST, 1);
    
    ESP_LOGI("DISPLAY", "Display init called");
}

void send_one_spi_byte() {
    spi_transaction_t trans = {0};
    trans.length = 8;
    trans.tx_data[0] = 0x42;
    trans.flags = SPI_TRANS_USE_TXDATA;

    spi_device_transmit(spi, &trans);
    ESP_LOGI("SPI", "Sent one byte!");
}

void wake_up_display(){
    // Configure D/C pin as output first
    gpio_set_direction(PIN_DC, GPIO_MODE_OUTPUT);

    // Software reset - set D/C LOW for command
    gpio_set_level(PIN_DC, 0);  // Command mode
    spi_transaction_t trans = {0};
    trans.length = 8;
    trans.tx_data[0] = 0x01;  // Software reset command
    trans.flags = SPI_TRANS_USE_TXDATA;
    spi_device_transmit(spi, &trans);
    ESP_LOGI("DISPLAY", "Software reset sent");
    vTaskDelay(150 / portTICK_PERIOD_MS);
    
    // Sleep out - D/C still LOW for command
    gpio_set_level(PIN_DC, 0);  // Command mode  
    trans.tx_data[0] = 0x11;  // Exit sleep mode
    spi_device_transmit(spi, &trans);
    ESP_LOGI("DISPLAY", "Sleep out sent");
    vTaskDelay(120 / portTICK_PERIOD_MS);
    
    // Display on - D/C still LOW for command
    gpio_set_level(PIN_DC, 0);  // Command mode
    trans.tx_data[0] = 0x29;  // Display on
    spi_device_transmit(spi, &trans);
    ESP_LOGI("DISPLAY", "Display on sent");
}

void display_fill_red(void) {
    // TODO: Send red pixels
}