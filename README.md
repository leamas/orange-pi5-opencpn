OpenCPN on Orange Pi 5.
=======================

Some notes on setting up opencpn [1] on a Orange Pi 5 (OrPi5).

Hardware:

  - Orange Pi 5. I have chosen the original version with an NVME
    port so I can add an SSD disk. The wifi then needs to be connected
    using USB.

  - A waveshare L76X Multi-GNSS hat whcih handles the GPS. It comes with
    an antenna whcih works for indoor testing, but for my yacht I use a 
    Garmin GPS antenna mounted on the pushpit.

  - A TP-Link Archer T3U Plus USB wifi module,
    https://www.amazon.se/dp/B0859M539M. Could be anything as long as its
    supported by the 6.1 kernel.

  - A 4A power USB-C Power supply

  - A HDMI dummy plug which replaces the monitor when running in "real"
    usage, for eaxample https://www.amazon.se/dp/B06XT1Z9TF/

  - An sd card, nothing fancy is required. 32GB is enough.

  - An nvme short SSD, I used https://www.amazon.se/dp/B0BTDPXWPC

For development

  - HDMI monitor
  - USB keyboard + mouse
  - wired ethernet connection
  
 
Cooling and case

These are related. I'm using a rather open solution which allows for free air
flow. Here my  passive cooling https://www.amazon.se/dp/B0C6LRYZ73
should be enough. A more closed box probably will need a fan (don't
want that).


Bootstrap OS into nvme ssd
--------------------------

Start with the Debian server image available at 
[Orange website](http://www.orangepi.org/html/hardWare/computerAndMicrocontrollers/service-and-support/Orange-pi-5.html)

Burn it to a sd card. Could be done on any tool, on my Linux PC:


    # dd if=Orangepi5plus_1.0.6_debian_bookworm_server_linux5.10.110.7 \
          of=/dev/mmcblk0 status=progress bs=1M conv=sync


This is just a bootstrap, no point to customise at this point. Insert card 
in the OrPi5 and boot it up. Once booted, transfer the same image to the Rpi
-- either from the host where it available ot from the website. 

Burn image to the NVME card using something like:


    # dd if=Orangepi5plus_1.0.6_debian_bookworm_server_linux5.10.110.7 \
          of=/dev/nvme0n1 status=progress bs=1M conv=sync

Remove the sd card and reboot into the server.

Customize the OS
----------------

Add a regular user:

    # adduser foo
    ... answer prompts ...

Change the orangepi default password

    # passwd orangepi
    ... answer prompts

Install the gnome desktop

    # apt install task-gnome-desktop

Set the hostname

    # hostnamectl hostname "silly-name"

Enable an UART.

We need some uart to receive data from the Waveshare GPS card. Start 
`orangepi-config`, got to _System_ | _Hardware_. Here, select the uart
x (I'm using uart1-m1), save and exit.

Reboot into desktop. When logging in, select "Gnome on X11" in gear 
bottom-right before entering password (Wayland logins fails).

Network setup
-------------

In a terminal, set up the fixed TP connection:

    # nmcli  conn modify "Wired connection 1" ipv4.addresses 192.168.2.143
    # nmcli  conn modify "Wired connection 1" ipv4.gateway 192.168.2.1
    # nmcli  conn modify "Wired connection 1" ipv4.dns 192.168.2.21 8.8.8.8

Set up the wlan, the OrPi5 is wlan AP:

    # nmcli con add type wifi ifname wlan0 con-name Hotspot autoconnect yes ssid equipage
    # nmcli con modify Hotspot 802-11-wireless.mode ap 802-11-wireless.band bg ipv4.method shared
    # nmcli con modify Hotspot wifi-sec.key-mgmt wpa-psk
    # nmcli con modify Hotspot wifi-sec.psk "veryveryhardpassword1234"
    # nmcli con up Hotspot

Two problems occurs:

1. The wlan0 device does not exist. Look in dmesg for wlan0, this reveals that
   the kernel has renamed it to wlx98254a3b1d48  (!). The device name is also
   visible in _/sys/class/net/_

2. The interface failed to activate due to using wrong wifi channels.
   Look in https://en.wikipedia.org/wiki/List_of_WLAN_channels and
   update Hotspot's 802-11-wireless.channel property to a sane channel.

Install OpenCPN
---------------

    # apt install flatpak
    # flatpak remote-add --if-not-exists \
        flathub https://flathub.org/repo/flathub.flatpak
    $ flatpak install --user org.opencpn.OpenCPN


Install these tools
-------------------

The tools here keeps a led port high while running (power-led) and
also listens to an input and makes a clean shutdown if it goes low
(power-btn). 

Look in .cpp source files for actual pins used.

To work, current user must be able to run `sudo` without any 
password prompt. Left as an exercise to the reader.

Install:

    $ make install

Initiate services:

    $ systemctl --user enable --now power-btn.service power-led.service

Remote desktop
--------------

Install the remote desktop package:

    # apt install gnome-remote-desktop
 
In Gnome Settings (the gear) got to _Sharing_  and enable _Remote Desktop_
This starts an RDP server on port 3389. This can be used by any RDP client,
I use Remmina.

This simple setup requires a monitor. When running headless, the monitor
is replaced by the HDMI dummy  plug.
