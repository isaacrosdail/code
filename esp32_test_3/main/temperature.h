// Remember, .h files say "Hey, here are the functions we're using from this. I promise these exist"
// These are called forward declarations

/**
 * @brief Initialize DS18B20 temperature sensor on GPIO 4
 * 
 * Searches 1-Wire bus for sensors and stores handles.
 * Logs warning if no sensors found but doesn't crash.
 * 
 * @note Requires external 4.7kΩ pull-up resistor on data line
 */
void temperature_init(void);

/**
 * @brief Read temperature from DS18B20
 * 
 * Triggers conversion, waits 800ms, retrieves measurement from ds18b20s[0].
 * 
 * @return Temperature in Celsius, or -999.0f if no sensor available
 * @warning Blocking - sleeps during conversion
 */
float temperature_read(void);