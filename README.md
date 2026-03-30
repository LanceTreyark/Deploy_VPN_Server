Date: 1/16/2025 

Author: Lance Pierson 

 

Purpose: 

A VPN is used to link the pilot to the drone from anywhere in the world.  

 

This document is intended to outline the process of:  

spinning up a new VPS cloud server  

Running an initialization script that sets up security standards 

Running an OpenVPN installation script 

Deploying connection profiles for the drone and the pilot’s device 

Installing OpenVPN on the Raspberry Pi via the CLI 

 

Our script is hosted here: 

https://raw.githubusercontent.com/LanceTreyark/Deploy_VPN_Server/refs/heads/main/serverInit.sh 

 

 

Let’s get started! 

I use UpCloud to host my Virtual Private Server aka VPS. 

Standard setup as usual Debian 12 or newer instance with pre installed keys for “Battery” which is the laptop I use that has a good battery. 

Root into the server ie root@ipAddressHere use the password to unlock ssh-key access 

Once in create a script:  

“nano serverInit.sh” 

Paste the contents of this into it: https://raw.githubusercontent.com/LanceTreyark/Deploy_VPN_Server/refs/heads/main/serverInit.sh then ctrl + x and save 

Make the script executable with: 

 “sudo chmod +x serverInit.sh” 

Run the script with  

“./serverInit.shleon” 

This script will set up your standard security and UFW firewall (i think) then it preinstalls and sets up alias commands for “deploy” which launches your VPN installer in your non-root sudo user account. 

Once the script is installed you are good to go with a VPN that does not allow peer-to-peer traffic, it’s for ip protection only. 

If you want to set this up as a peer-to-peer server, you need to do the following: 

 Open the open-ssh server config file: 

 “sudo nano /etc/openvpn/server.conf” 

Add this line to the bottom:  

“client-to-client"  

save and exit, ctrl + o, y, enter, ctrl + x, enter. 

 Set up new firewall rules:  

“sudo ufw allow in on tun0” 

“sudo ufw allow out on tun0” 

“sudo ufw allow from 10.8.0.0/24” 

“sudo ufw allow 1194/udp” 

“sudo ufw allow 1194/tcp” 

 "sudo ufw status” 

"sudo ufw reload” 

Set up IP table rules: 

"sudo iptables -A FORWARD -i tun0 -j ACCEPT” 

"sudo iptables -A FORWARD -o tun0 -j ACCEPT” 

Reload OpenVPN: 

“sudo systemctl restart openvpn” 

Check the status of the server: 

"ping 8.8.8.8” 

"curl ifconfig.me” 

sudo apt install net-tools -y 

 ip a (replaces "ifconfig” on new LINUX Versions!) 

Create a connection profile by running the installer again, it will detect that the system is already installed and ask what you would like to do. Select Option 1 and create a connection profile. Follow the steps the defaults are fine. 

One the profile is created use cat to print it in the CLI so you can copy and paste it into a local file.ovpn 

To connect to the VPN install openvpn client and import the .ovpn file 

To install the client on the Raspberry Pi running Linux follow these steps: 

“sudo apt update && sudo apt upgrade –y" 

“sudo apt install openvpn –y" 

“sudo nano /etc/openvpn/client/ myvpn.ovpn” 

paste in connection profile and save 

Ensure the file has the correct permissions: 

“sudo chmod 600 /etc/openvpn/client/myvpn.ovpn” 

Start with: 

“sudo openvpn --config /etc/openvpn/client/myvpn.ovpn” 

Thats it! 

Now that the Raspberry Pi is running OpenVPN you can connect to it from other devices in the same VPN. 
