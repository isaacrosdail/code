idf_component_register(SRCS "hello_world_main.c" "temperature.c"
                    PRIV_REQUIRES spi_flash espressif__onewire_bus
                    INCLUDE_DIRS ""
                    REQUIRES esp_driver_gpio)
