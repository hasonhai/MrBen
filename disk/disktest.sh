#!/bin/bash
# Run disk test on a single machine

CONF="$1"  # config file for fio
USER="$2"  # user to run test
KEY="$3"   # key to access target host
TARGET="$4" # IP or hostname of target host (prefer IP)
COMMAND="$5"

function usage(){
  echo "./disktest.sh <conf> <user> <key> <host> <command>"
  echo "    Command could be:"
  echo "        * setup-host:   to set-up the host"
  echo "        * setup-test:   to prepare the test"
  echo "        * run:          run test on host"
  echo "        * collect-data: collect the data"
  echo "        * clean:        clean the host"
}

CONFNAME="$( basename $CONF )"
TestDir="$(grep 'directory=' $CONF | awk -F"=" '{print $2}')"

if [ "$COMMAND" = "setup-host" ]; then
    # Setup host only
    ssh -i $KEY $USER@$TARGET "mkdir ~/MrBentest"
	ssh -i $KEY $USER@$TARGET "sudo apt-get install -y fio"
	scp -i $KEY targetrun.sh $USER@$TARGET:~/MrBentest/targetrun.sh
	ssh -i $KEY $USER@$TARGET "chmod a+x ~/MrBentest/targetrun.sh"
	ssh -i $KEY $USER@$TARGET "echo 1 > ~/MrBentest/.setuphost"
elif [ "$COMMAND" = "setup-test" ]; then
    # Setup host to for each test
	SETUPDONE="$(ssh -i $KEY $USER@$TARGET 'cat ~/MrBentest/.setuphost')"
	if [ $SETUPDONE -eq 1 ]; then
        scp -i $KEY $CONF $USER@$TARGET:~/MrBentest/$CONFNAME
	    ssh -i $KEY $USER@$TARGET "mkdir -p $TestDir"
		ssh -i $KEY $USER@$TARGET "echo 1 > ~/MrBentest/.setuptest"
	fi
elif [ "$COMMAND" = "run" ]; then
    # Running test
    SETUPDONE="$(ssh -i $KEY $USER@$TARGET 'cat ~/MrBentest/.setuptest')"
    if [ $SETUPDONE -eq 1 ]; then
        ssh -i $KEY $USER@$TARGET "~/MrBentest/targetrun.sh $CONFNAME $TestDir"
    else
        echo "Please setup host first"
	    exit 1
	fi
elif [ "$COMMAND" = "collect-data" ]; then
    mkdir testout
    scp -i $KEY $USER@$TARGET:~/MrBentest/*.diskout testout/    
elif [ "$COMMAND" = "clean" ]; then
    SETUPDONE="$(ssh -i $KEY $USER@$TARGET 'cat ~/MrBentest/.setup')"
    if [ "$SETUPDONE" = "$CONF"  ]; then
        ssh -i $KEY $USER@$TARGET "rm -rf ~/MrBentest"
	fi
else
    usage
	exit 1
fi
