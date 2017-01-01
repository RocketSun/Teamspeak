#!/bin/bash
ESC_SEQ="\x1b["
COL_RESET=$ESC_SEQ"39;49;00m"
COL_RED=$ESC_SEQ"31;11m"
COL_GREEN=$ESC_SEQ"32;11m"
COL_BLUE=$ESC_SEQ"34;01m"
COL_MAGENTA=$ESC_SEQ"35;01m"
COL_YELLOW=$ESC_SEQ"33;11m"

function greenMessage {
    echo -e "\\033[32;1m${@}\033[0m"
}

function magentaMessage {
    echo -e "\\033[35;1m${@}\033[0m"
}

function cyanMessage {
    echo -e "\\033[36;1m${@}\033[0m"
}

function redMessage {
    echo -e "\\033[31;1m${@}\033[0m"
}

function yellowMessage {
	echo -e "\\033[33;1m${@}\033[0m"
}


clear
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' =
echo -e "Teamspeak Script"
echo -e "By Nexus "
echo -e "Viel Spass"
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' =
sleep 5
clear
greenMessage "Erst werden die Programme Installiert "
sleep 6
sed -i '1ideb http://httpredir.debian.org/debian sid main contrib non-free' /etc/apt/sources.list
sed -i '1ideb-src http://httpredir.debian.org/debian sid main contrib non-free' /etc/apt/sources.list
apt-get update
apt-get install -t sid libc6
apt-get install screen --force-yes
apt-get install screen curl htop sudo
apt-get install x11vnc xvfb libxcursor1 ca-certificates bzip2 libglib2.0-0 -y
update-ca-certificates
clear
sleep 3
greenMessage "Teamspeak Order Wird Erstellt"
sleep 6
cd /home/
mkdir teamspeak
clear
sleep 3
greenMessage "Installiere Teamspeak "
sleep 6
cd /home/teamspeak
wget http://dl.4players.de/ts/releases/3.0.13.6/teamspeak3-server_linux_amd64-3.0.13.6.tar.bz2
tar xvfj teamspeak3-server_linux_amd64-3.0.13.6.tar.bz2
rm teamspeak3-server_linux_amd64-3.0.13.6.tar.bz2
clear
sleep 3
greenMessage "Setzte Rechte"
sleep 6
chmod 777 teamspeak3-server_linux_amd64
clear
sleep 3
greenMessage "Teamspeak wird gestartet bitte die query login daten aufschreiben danke !!!!!"
sleep 6
cd /home/teamspeak
cd teamspeak3-server_linux_amd64
su root -c "./ts3server_startscript.sh start"
rm teamspeak.sh

