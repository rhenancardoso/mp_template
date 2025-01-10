"""Boot application file."""

import machine
import network

import secret
from config import config

CONFIG = config()
CPU_FREQUENCY = 80_000


def access_point_config():
    print("Configuring access point")
    ap_manager = network.WLAN(network.AP_IF)
    ap_manager.active(True)
    ap_manager.config(
        essid=secret.AP_SSID,
        password=secret.AP_PASS,
        channel=1,
        authmode=network.AUTH_WPA_WPA2_PSK,
    )

    while ap_manager.active() is False:
        pass

    print("Configuration successful")
    print(ap_manager.ifconfig())


if __name__ == "__main__":
    machine.freq(CPU_FREQUENCY)
    print(f"CPU Freq {machine.freq()/1_000_000} MHz")
    access_point_config()
