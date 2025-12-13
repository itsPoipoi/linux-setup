# Color
GREEN=$'\e[0;32m'
RED=$'\e[0;31m'

# Install Kanata using Brew
brew install kanata

# Setup input access
sudo groupdel uinput
sudo groupadd --system uinput
sudo usermod -aG input $USER
sudo usermod -aG uinput $USER
sudo touch /etc/udev/rules.d/99-input.rules
sudo chmod a+w /etc/udev/rules.d/99-input.rules
sudo echo 'KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"' >> /etc/udev/rules.d/99-input.rules
sudo udevadm control --reload-rules && sudo udevadm trigger
sudo modprobe uinput

# Import config
sudo curl -sL https://raw.githubusercontent.com/itsPoipoi/linux-setup/refs/heads/main/kanata/config.kbd --create-dirs -o /etc/kanata/config.kbd
sudo chmod -R a+rx /etc/kanata

# Setup systemd daemon service
curl -sL https://raw.githubusercontent.com/itsPoipoi/linux-setup/refs/heads/main/kanata/kanata.service --create-dirs -o ~/.config/systemd/user/kanata.service
systemctl --user daemon-reload
systemctl --user enable kanata.service
systemctl --user start kanata.service

echo "${GREEN}Kanata setup complete. A reboot is required. ${RED}Reboot now?"
echo "${RED}(Y)es, (N)o:"
read -n 1 -r user_input  # -n 1 reads a single character, -r treats backslashes literally
echo 
case $user_input in
  [yY])
    echo "${GREEN}Rebooting in a few seconds..."
    sleep 4
    sudo shutdown -r now
    ;;
  [nN])
    echo "${GREEN}Kanata will be active after next reboot."
    ;;
  *)
    echo "Invalid choice."
    ;;
esac
