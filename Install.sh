#!/usr/bin/env bash

echo "Enter URL you'd like the browser to open at boot:"
read pageURL
printf -v pageURL "%q\n" "$pageURL"
read -r -p "Hide cursor? (Good for non-interactive displays) [y/N] " hideCursor
read -r -p "Clear browser cache at boot? [y/N] " hideCursor
read -p "How often (in minutes) do you want the page to refresh? (0 to disable): " refreshRate
while ! [[ $refreshRate =~ ^-?[0-9]+$ ]]
do
    echo "Error: please enter an integer."
    read -p "How often (in minutes) do you want the page to refresh? (0 to disable): " refreshRate
done

read -p "How long to wait before launching browser (in seconds)? (0 to disable, 60-120 recommended so network has time to connect): " launchWait
while ! [[ $launchWait =~ ^-?[0-9]+$ ]]
do
    echo "Error: please enter an integer."
    read -p "How long to wait before launching browser (in seconds)? (0 to disable, 60-120 recommended so network has time to connect): " launchWait
done

clear
echo "Okay, configuring now..."

HOMEDIR=~

# Allow Pi time to boot
echo "export DISPLAY=:0" > ~/rpi-webpage-display-atBoot.sh
echo "sleep $launchWait" >> ~/rpi-webpage-display-atBoot.sh
if [[ "$clearCache" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
    echo "rm -rf ~/.cache/chromium/*" >> ~/rpi-webpage-display-atBoot.sh
fi
echo "sed -i 's/"exited_cleanly": false/"exited_cleanly": true/' ~/.config/chromium/Default/Preferences" >> ~/rpi-webpage-display-atBoot.sh
echo "chromium-browser --no-first-run --disable --disable-translate --disable-infobars --disable-session-crashed-bubble --disable-translate --disable-suggestions-service --disable-save-password-bubble --noerrdialogs --start-maximized --kiosk \"${pageURL}\" &" >> ~/rpi-webpage-display-atBoot.sh
sudo chmod +x "${HOMEDIR}/rpi-webpage-display-atBoot.sh"
(crontab -l 2>/dev/null; echo "@reboot ${HOMEDIR}/rpi-webpage-display-atBoot.sh") | crontab -

if [[ "$hideCursor" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
    sudo apt-get install unclutter -y
    echo "unclutter -idle 0.01 -root &" >> ~/rpi-webpage-display-atBoot.sh
fi

echo "xset s off && xset -dpms && xset s noblank" >> ~/rpi-webpage-display-atBoot.sh

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
