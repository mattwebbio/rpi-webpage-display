# Raspberry Pi Webpage Display Script
I have Pi-powered Google Calendar displays all over the place - I wrote a script to make it easy to make more of them (or other similiar displays that just use a web browser).

The install script sets a cron job to launch a fullscreen Chromium window in kiosk mode at boot, disabling screen timeout. Configurables set during install:
* Hide cursor (good for non-interactive displays)
* Clear browser cache at boot
* Refresh page at specified minute interval
* Delay browser launch (allow extra time for boot and/or network connectivity)

*Do not use under any circumstances where not being able to leave the browser is a priority, as this is in no way prevented.* Built for and tested on Raspbian Stretch running on a Pi Zero.

# Install
If you haven't completed any initial setup (imaged your SD card, logged in and completed setup, connected to the internet) do that first. This script requires the desktop version of Raspbian (minimal won't work).

First, inspect the code located in the [Install.sh](https://github.com/mattwebbio/rpi-webpage-display/blob/master/Install.sh) file prior to running it - then, to setup, run the following command (will work on local terminal *or* SSH):
```
bash -c "$(curl -s https://raw.githubusercontent.com/mattwebbio/rpi-webpage-display/master/Install.sh)"
```
