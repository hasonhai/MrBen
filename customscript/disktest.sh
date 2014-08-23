#!/bin/bash
# Run disk test on a single machine

CONF="$1"  # config file for fio
USER="$2"  # user to run test
KEY="$3"   # key to access target host
TARGET="$4" # IP or hostname of target host (prefer IP)
COMMAND="$5"

function usage(){
  echo "./disktest.sh <conf> <user> <key> <host> <command>"
}

CONFNAME="$( basename $CONF )"
TestDir="$(grep 'directory=' $CONF | awk -F"=" '{print $2}')"

if [ "$COMMAND" = "setup" ]; then
    ssh -i $KEY $USER@$TARGET "mkdir ~/disktest"
	ssh -i $KEY $USER@$TARGET "sudo apt-get install -y fio"
    scp -i $KEY $CONF $USER@$TARGET:~/disktest/$CONFNAME
	scp -i $KEY targetrun.sh $USER@$TARGET:~/disktest/targetrun.sh
	ssh -i $KEY $USER@$TARGET "chmod a+x ~/disktest/targetrun.sh"
	ssh -i $KEY $USER@$TARGET "cat 1 > ~/disktest/.setup"
elif [ "$COMMAND" = "run" ]; then
    SETUPDONE="$(ssh -i $KEY $USER@$TARGET 'cat ~/disktest/.setup')"
    if [ $SETUPDONE -eq 1 ]; then
        ssh -i $KEY $USER@$TARGET "./targetrun.sh $CONFNAME $TestDir"
    else
        echo "Please setup host first"
	    exit 1
	fi
elif [ "$COMMAND" = "clean" ]; then
    SETUPDONE="$(ssh -i $KEY $USER@$TARGET 'cat ~/disktest/.setup')"
    if [ $SETUPDONE -eq 1 ]; then
        ssh -i $KEY $USER@$TARGET "rm -rf ~/disktest"
	fi
else
    usage
	exit 1
fi
