#!/usr/bin/env bash

echo "Enter URL you'd like the browser to open at boot:"
read pageURL
printf -v pageURL "%q\n" "$pageURL"
echo "How often (in minutes) do you want the page to refresh? (0 to disable)"
read refreshRate
read -r -p "Hide cursor? (Good for non-interactive displays) [y/N] " hideCursor

while ! [[ $refreshRate =~ ^-?[0-9]+$ ]]
do
    echo "Error: please enter an integer."
    echo "How often (in minutes) do you want the page to refresh? (0 to disable)"
    read refreshRate
done

HOMEDIR=~

echo "export DISPLAY=:0" > ~/rpi-webpage-display-atBoot.sh
echo "chromium-browser --no-first-run --disable --disable-translate --disable-infobars ----disable-session-crashed-bubble --disable-suggestions-service --disable-save-password-bubble --start-maximized --kiosk \"${pageURL}\" &" >> ~/rpi-webpage-display-atBoot.sh
echo "xset s off && xset -dpms && xset s noblank"
sudo chmod +x "${HOMEDIR}/rpi-webpage-display-atBoot.sh"
(crontab -l 2>/dev/null; echo "@reboot ${HOMEDIR}/rpi-webpage-display-atBoot.sh") | crontab -

if [[ "$hideCursor" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
    sudo apt-get install unclutter -y
    echo "unclutter -idle 0.01 -root" >> ~/rpi-webpage-display-atBoot.sh
fi

if [ $refreshRate -gt 0 ]
then
    sudo apt-get install xdotool -y
    echo "export DISPLAY=:0" > ~/rpi-webpage-display-Refresh.sh
    echo "xdotool search --onlyvisible --class \"Chromium\" windowfocus key 'ctrl+r'" >> ~/rpi-webpage-display-Refresh.sh
    sudo chmod +x "${HOMEDIR}/rpi-webpage-display-Refresh.sh"
    (crontab -l 2>/dev/null; echo "*/${refreshRate} * * * * ${HOMEDIR}/rpi-webpage-display-Refresh.sh") | crontab -
fi

echo "Done! Rebooting now..."
sudo reboot
