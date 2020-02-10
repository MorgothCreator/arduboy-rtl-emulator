# arduboy-rtl-emulator

 VHDL design to emulate the ArduBoy game console.

 This design is intended to create a FPGA platform to run ArduBoy compatible games.

 # Description:

 ```
 This design does not use a direct interface with HDMI module, instead use a SPI master to SPI slave display data transmission, this way let the developers to wire up a real OLED display.
 ```

 The core files can be cloned from https://github.com/MorgothCreator/atmega-xmega-soft-core

  # V00.02.10:

 ```
 Initial commit.
 
 Connected interfaces:
 All PIO with hibrid configuration (parametrized and soft controlled).
 SPI master, TIM0, TIM1, TIM3, TIM4, PLL, EEPROM ( All in limited configuration, to run ArduBoy compatible games )
 Some timmers and SPI master interface is connected as alternative pin function setup from software.
 ```

 If you like my work, you can help further development by donating as little as 1 EUR.

 [![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=CZM6JXDVMFXHS&source=url)

 Or you can send some crypto:

 BTC: 3CFRp6day6ZRgpXw8n1QGvXfmk5gf8XK3e

 LBRY: bbVdwfTsVkFhA3qcq2znyD7juuuDnUdMT1

 MONERO: 8ALzMJESPVrdCmrQuwssrZVvdg4wBvtt6DXigYxZ33ZuQVHQBXNpHpoCZVR4smKLHhYPsSgsH4BvYCXdBNdZzFH8AB5z8vs
