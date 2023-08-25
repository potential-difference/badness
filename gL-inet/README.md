Using Uboot to Debrick Your Router

firmware for the router can be downloaded at https://dl.gl-inet.com/?model=ar300m16

Note: The Uboot operation will remove your router's settings and installed plugins.

Please follow the procedures below to access the Uboot Web UI and re-install the firmware.

    Remove the power of router. 
    Connect your computer to the Ethernet port (either LAN or WAN) of the router BEFORE powering up. 

    Manually set the IP address of your computer to 192.168.1.2. 
    Enter the IPv4 Address to 192.168.1.2, Subnet Mask to 255.255.255.0, Router to 192.168.1.1

        You MUST leave all the other ports unconnected.

    Press and hold the Reset button firmly, and then power up the router. 

    Then you will see a LED flashing in a regular sequence a few times, please release your finger after the sequence changes.

      the LED falshes 6 times then stays on.

 
    Use browser to visit http://192.168.1.1, this is the Uboot Web UI.

    UPLOAD NOR FIRMWARE
        Click Choose file button to find the firmware file. 
        openwrt-ar300m16-3.216-0321-1679391734.bin
        Then click Update firmware button.

    Wait for around 3 minutes. Don’t power off your device when updating. The router is ready when both power and Wi-Fi LED are on or you can find its SSID on your device.

    GL-AR300M is the SSID for these routers
    goodlife is the password for the wifi network

    Revert the IP setting you did in step 4 and connect your device to the LAN or Wi-Fi of the router. You will be able to access the router via 192.168.8.1 again.
