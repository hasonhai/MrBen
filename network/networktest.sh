#!/bin/bash

CONF="$1"  # config file for fio
USER="$2"  # user to run test
KEY="$3"   # key to access target host
SRC="$4"   # IP or hostname of target host (prefer IP)
DST="$5"  # 
COMMAND="$6"

# Global Variable
# IPERFSERVERCONTROL="global" #Other script control iperf server
# IPERFSERVERCONTROL="local"  #This script control iperf server

function usage(){
  echo "./networktest.sh <conf> <user> <key> <src> <dest> <command>"
  echo "    Command could be:"
  echo "        * setup-host:   to set-up the host"
  echo "        * run:          run test on host"
  echo "        * collect-data: collect the data"
  echo "        * clean:        clean the host"
}

if [ "$COMMAND" = "setup-host" ]; then
    # Setup SRC host
    ssh -i $KEY $USER@$SRC "test ! -d ~/MrBentest && mkdir ~/MrBentest"
	ssh -i $KEY $USER@$SRC "test ! -d ~/networkout && mkdir ~/networkout"
	IPERFCHECK="$(ssh -i $KEY $USER@$SRC "which iperf")"
	if [ "$IPERFCHECK" != "/usr/bin/iperf" ]; then
	    ssh -i $KEY $USER@$SRC "sudo apt-get install -y iperf"
	fi
	ssh -i $KEY $USER@$SRC "echo 1 > ~/MrBentest/.setuphost"
	# Setup DST host
	if [ "$IPERFSERVERCONTROL" = "local" ]; then
        ssh -i $KEY $USER@$DST "test ! -d ~/MrBentest && mkdir ~/MrBentest"
        scp -i $KEY ControlIperfServer.sh $USER@$DST:~/MrBentest/ControlIperfServer.sh
        ssh -i $KEY $USER@$DST "chmod a+x ~/MrBentest/ControlIperfServer.sh"
        IPERFCHECK="$(ssh -i $KEY $USER@$DST "which iperf")"
        if [ "$IPERFCHECK" != "/usr/bin/iperf" ]; then
	        ssh -i $KEY $USER@$DST "sudo apt-get install -y iperf"
	    fi
		ssh -i $KEY $USER@$DST "~/MrBentest/ControlIperfServer.sh start"
    fi	
elif [ "$COMMAND" = "run" ]; then
    # Running test
    SETUPDONE="$(ssh -i $KEY $USER@$SRC 'cat ~/MrBentest/.setuphost')"
    if [ $SETUPDONE -eq 1 ]; then
        echo "Running test on $SRC"
        ssh -i $KEY $USER@$SRC "~/MrBentest/targetrun.sh MrBentest/$CONFNAME $TestDir"
    else
        echo "Please setup host first"
	    exit 1
	fi
elif [ "$COMMAND" = "collect-data" ]; then
    if [ ! -d "testout" ]; then
         mkdir testout
    fi
	echo "Collect test result"
    scp -i $KEY $USER@$SRC:~/networkout/*.networkout testout/    
elif [ "$COMMAND" = "clean" ]; then
    SETUPDONE="$(ssh -i $KEY $USER@$SRC 'cat ~/MrBentest/.setuphost')"
    if [ $SETUPDONE -eq 1  ]; then
        echo "Removing temporary directory"
        ssh -i $KEY $USER@$SRC "rm -rf ~/MrBentest"
		echo "Removing test output on host $SRC"
		ssh -i $KEY $USER@$SRC "rm -rf ~/networkout"
		if [ "$IPERFSERVERCONTROL" = "local" ]; then
            ssh -i $KEY $USER@$DST "~/MrBentest/ControlIperfServer.sh stop"
        fi
	fi
else
    usage
	exit 1
fi