#!/bin/sh
# Copyright (c) 2010 TeamSpeak Systems GmbH
# All rights reserved

COMMANDLINE_PARAMETERS="${2}" #add any command line parameters you want to pass here
D1=$(readlink -f "$0")
BINARYPATH="$(dirname "${D1}")"
cd "${BINARYPATH}"
LIBRARYPATH="$(pwd)"
BINARYNAME="ts3server"

case "$1" in
	start)
	clear
		if [ -e ts3server.pid ]; then
			if ( kill -0 $(cat ts3server.pid) 2> /dev/null ); then
				echo "The server is already running, try restart or stop"
				exit 1
			else
				echo "ts3server.pid found, but no server running. Possibly your previously started server crashed"
				echo "Please view the logfile for details."
				rm ts3server.pid
			fi
		fi
		if [ "${UID}" = "0" ]; then
			echo WARNING ! For security reasons we advise: DO NOT RUN THE SERVER AS ROOT
			c=1
			while [ "$c" -le 10 ]; do
				echo -n "!"
				sleep 1
				c=$(($c+1))
			done
			echo "!"
		fi
echo  "\033[34m=======================================================\033[0m"
echo "\033[32m                  TeamSpeak Wird gestartet"
echo  "\033[34m=======================================================\033[0m"
		if [ -e "$BINARYNAME" ]; then
			if [ ! -x "$BINARYNAME" ]; then
				echo "${BINARYNAME} is not executable, trying to set it"
				chmod u+x "${BINARYNAME}"
			fi
			if [ -x "$BINARYNAME" ]; then
				export LD_LIBRARY_PATH="${LIBRARYPATH}:${LD_LIBRARY_PATH}"					
				"./${BINARYNAME}" ${COMMANDLINE_PARAMETERS} > /dev/null &
 				PID=$!
				ps -p ${PID} > /dev/null 2>&1
				if [ "$?" -ne "0" ]; then
					echo "TeamSpeak 3 Server Konnte Nicht Starten "
				else
					echo $PID > ts3server.pid
echo  "                                                                       "
echo  "                                                                       "
echo  "\033[32mTeamSpeak Wurde Erfolgreich Gestartet"
echo  "                                                                       "
echo  "                                                                       "
echo  "\033[34m=======================================================\033[0m"
				fi
			else
				echo "${BINARNAME} is not exectuable, cannot start TeamSpeak 3 server"
			fi
		else
			echo "Could not find binary, aborting"
			exit 5
		fi
	;;
	stop)
	clear
		if [ -e ts3server.pid ]; then
echo  "\033[34m=======================================================\033[0m"
echo "\033[31m                  TeamSpeak wird gestoppt"
echo  "\033[34m=======================================================\033[0m"
			if ( kill -TERM $(cat ts3server.pid) 2> /dev/null ); then
				c=1
				while [ "$c" -le 300 ]; do
					if ( kill -0 $(cat ts3server.pid) 2> /dev/null ); then
						sleep 1
					else
						break
					fi
					c=$(($c+1)) 
				done
			fi
			if ( kill -0 $(cat ts3server.pid) 2> /dev/null ); then
				echo "Server is not shutting down cleanly - killing"
				kill -KILL $(cat ts3server.pid)
			else
echo  "                                                                       "
echo  "                                                                       "
echo  "\033[31mTeamSpeak Wurde Erfolgreich Gestoppt"
echo  "                                                                       "
echo  "                                                                       "
echo  "\033[34m=======================================================\033[0m"
			fi
			rm ts3server.pid
		else
			echo "No server running (ts3server.pid is missing)"
			exit 7
		fi
	;;
	restart)
		$0 stop && $0 start ${COMMANDLINE_PARAMETERS} || exit 1
	;;
	status)
	clear
		if [ -e ts3server.pid ]; then
			if ( kill -0 $(cat ts3server.pid) 2> /dev/null ); then
echo  "\033[34m=======================================================\033[0m"
echo "\033[32m            TeamSpeak Server Läuft Grade"
echo  "\033[34m=======================================================\033[0m"
			else
echo  "\033[34m=======================================================\033[0m"
echo "\033[31m            TeamSpeak Server Ist Tod"
echo  "\033[34m=======================================================\033[0m"
			fi
		else
echo  "\033[34m=======================================================\033[0m"
echo "\033[31m            TeamSpeak Server Läuft Nicht"
echo  "\033[34m=======================================================\033[0m"
		fi
	;;
	help)
	clear
echo  "\033[34m=======================================================\033[0m"
echo  "                  TeamSpeak Commands                                 "
echo  "\033[34m=======================================================\033[0m"
echo  "                                                                       "
echo  "\033[31m ./ts3.sh start\033[0m Um Den TeamSpeak Zu Starten"
echo  "                                                                       "
echo  "\033[31m ./ts3.sh stop\033[0m Um Den TeamSpeak Zu Stoppen"
echo  "                                                                       "
echo  "\033[31m ./ts3.sh restart\033[0m Um Den TeamSpeak Neuzustarten"
echo  "                      												  "
echo  "\033[31m ./ts3.sh help\033[0m Um alle Commands anzuzeigen"
echo  "                                                                       "
echo  "\033[34m=======================================================\033[0m"
;;
	*)
		echo "Usage: ${0} {start|stop|help|restart|status}"
		exit 2
;;
esac
exit 0

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


