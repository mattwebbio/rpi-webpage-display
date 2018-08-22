# Raspberry Pi Webpage Display Script
I have Google Calendar displays all around my house - I wrote a script to make it easy to make more of them (or other similiar displays that just use a web browser).

The install script sets a cron job to launch a fullscreen Chromium window in kiosk mode at boot, disabling screen timeout. Configurables set during install:
* Hide cursor (good for non-interactive displays)
* Clear browser cache at boot
* Refresh page at specified minute interval
* Delay browser launch (allow extra time for boot and/or network connectivity)

*Do not use under any circumstances where not being able to leave the browser is a priority, as this is in no way prevented.* Built for and tested on Raspbian Stretch running on a Pi Zero.

# Install
First, view the code located in the [Install.sh](https://github.com/mattwebbio/rpi-webpage-display/blob/master/Install.sh) file prior to running it - then, to run, use the following command:
```
bash -c "$(curl -s https://raw.githubusercontent.com/mattwebbio/rpi-webpage-display/master/Install.sh)"
```
