#!/bin/bash
################################### Root Installer For building a OpenVPN Installer
################################### This is the demo program
# nano serverInit.sh
# sudo chmod +x serverInit.sh
# ./serverInit.sh
echo "The Script is Live"
sleep 1
echo "Updating the server..."
# Options for user specific time zones
sudo timedatectl set-timezone America/Los_Angeles
#sudo timedatectl set-timezone America/Chicago
#sudo timedatectl set-timezone America/New_York
#sudo timedatectl set-timezone Europe/London
#sudo timedatectl set-timezone Europe/Berlin
#sudo timedatectl set-timezone Asia/Tokyo
#sudo timedatectl set-timezone Australia/Sydney
sudo apt update && sudo apt upgrade -y
sudo apt install snapd -y
sudo snap install core
sudo snap install btop
# IP -In #
myIPv4=$(ip addr show | awk '{if (match($2,/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/)) {print $2}}' | head -2 | tail -1)
cat >/tmp/ipSort3r.txt <<EOF
$myIPv4
EOF
myIP=$(awk -F/ '{print $1}' /tmp/ipSort3r.txt) 
echo "The IP address for this server is: $myIP"
sudo rm -r /tmp/ipSort3r.txt
# IP -Out #
read -p "Creating a new user with root privilages aka 'sudo user'. What would you like to set as the new username?:  " sudoUser
#sudoUser="cornelius"
echo ""

echo ""
echo ""
echo "Creating new user, you will need to create password for this"
adduser $sudoUser
echo "Adding new user to sudo group"
usermod -aG sudo $sudoUser
sudoUserID=$(id -u $sudoUser)
mkdir /tmp/vArs
echo "$sudoUser" > /tmp/vArs/sudoUser.txt
echo "$sudoUserID" > /tmp/vArs/sudoUserID.txt
echo "$myIP" > /tmp/vArs/myIP.txt
echo "Installing dependencies"
echo "Installing Curl"
sudo apt install curl -y
echo "Installing Firewall"
apt install ufw -y
echo "Allow SSH through the firewall"
ufw allow OpenSSH
ufw enable
ufw status
echo "Copy authorized_keys over to $sudoUser"
echo "/home/$sudoUser/.ssh/"
adminPubKeyString=$(cat .ssh/authorized_keys)
mkdir -p /home/$sudoUser/.ssh
ls /home/$sudoUser/.ssh/
echo $adminPubKeyString >> /home/$sudoUser/.ssh/authorized_keys
ls /home/$sudoUser/.ssh/
echo "Create basic Alias commands to run updates in /home/$sudoUser/ directory"
cat >/home/$sudoUser/.bash_aliases <<EOF
alias hi="sudo apt update && sudo apt upgrade"
alias deploy="sudo sh ~/openvpn-install.sh"
alias bb="btop"
EOF
echo "Enable the Alias file"
sudo chmod +x /home/$sudoUser/.bash_aliases
sudo chown -R $sudoUserID:$sudoUserID /home/$sudoUser/.ssh/
sudo chown -R $sudoUserID:$sudoUserID /home/$sudoUser/.bash_aliases
echo "adding openVpnInstaller"
mkdir /tmp/VPN
curl -o /tmp/VPN/openvpn-install.sh "https://raw.githubusercontent.com/LanceTreyark/Deploy_VPN_Server/main/openvpn-install.sh"
mv /tmp/VPN/openvpn-install.sh /home/$sudoUser/openvpn-install.sh
sudo chmod +x /home/$sudoUser/openvpn-install.sh
cp -R /tmp/vArs /home/$sudoUser/
echo "This script has concluded"
echo "Switching to $sudoUser"
echo "Type the command 'deploy' to continue with the installation"
su $sudoUser