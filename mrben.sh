!/bin/bash
#

usage = {
    echo "`basename` -f <path_to_conf_file>"   # choose conf file to run
    echo "`basename` -l"                       # list scenario
    echo "`basename` -h"                       # print this message
	exit
}

# GLOBAL VARIABLES *****************************************************
NETWORKTEST_ENABLE="FALSE"
DISKTEST_ENABLE="FALSE"
CUSTOM_SCRIPT="FALSE"
SETUP="FALSE"
if [ "$1" = "-f" ]; then
    CONF=$2;
elif [ "$1" = "-l" ]; then
    #TODO: print available scenarios
    echo "List of available scenario:"
    echo "Bla Bla Bla"
    exit
else
    usage
    exit
fi

# [Parsing configuration file] *****************************************

#TODO: Test conf file syntax

#TODO: Parsing conf file
# Step 1: Remove all comment in the .scen file
    #TODO: Remove line with 
# Step 2: Parsing GLOBAL VARIABLE
CONFNAME=#TODO
CONFUSER=#TODO
CONFKEY=#TODO
# Step 3: Parsing NODES attending the test
LIST_OF_NODES=#TODO
# Besides, in this step, we should make a temp file with 3 separated columns:
#template: <nodename>    <nodeuser>  <nodekey>
#example:   vm0001        ubuntu      "/home/ubuntu/ubuntu.key"
#example:   vm0002        centosuser  "/home/centosuser/my.key"
#example:   vm0003        ubuntu      "/home/ubuntu/your.key"
./generate_node_login_info > ./login_info.tmp #TODO

# Step 4: Parsing NETWORKTEST info
    #TODO
# Step 5: Parsing DISKTEST info
if [ $( grep -n '[DISK]' $CONF ) != "" ]; then
    DISKTEST_ENABLE="TRUE"
	LIST_OF_DISK_TEST_IGNORED_NODES= #TODO
    # In case DISKTEST is configured but all the nodes are ignored
    if [ "$LIST_OF_DISK_TEST_IGNORED_NODES" = '' ]; then
        LIST_OF_DISK_TEST_NODES="$LIST_OF_NODES"
	else
        LIST_OF_DISK_TEST_NODES="$LIST_OF_NODES" - "$LIST_OF_DISK_TEST_IGNORED_NODES" #TODO
	fi
    DISKCONF_FIO= #TODO
    DISKTEST_MODE= #TODO
    # DISKTEST is configured but list of joining test is empty
	if [ "$LIST_OF_DISK_TEST_NODES" = '' ]; then
        DISKTEST_ENABLE="FALSE"
    fi
fi

#TODO: Parsing custom script

# [Running custom script] *********************************************
if [ "$CUSTOM" = "TRUE" ]; then
    # Run custom scripts
fi
# [Setup nodes] *******************************************************
if [ "$SETUP" = "TRUE" ]; then
    #TODO: Setup nodes to launch the test
    
    #TODO: Setup for network test
    if [ "$DISKTEST_ENABLE" = "TRUE" ]; then
        #TODO:
    fi
    #TODO: Setup for disk test
    if [ "$DISKTEST_ENABLE" = "TRUE" ]; then
        HOSTLIST="$LIST_OF_DISK_TEST_NODES"
        CONF="$DISKCONF_FIO"

        chmod a+x ./disk/disktest.sh
        echo "Setup the host"
        for HOST in $HOSTLIST; do
            #TODO: Careful for the case with different user
            #We have to set the key and user again
            KEY="$( grep "$HOST" login_info.tmp | cut -f3)" 
            USER="$( grep "$HOST" login_info.tmp | cut -f2)"
            ./disk/disktest.sh $CONF $USER $KEY $HOST setup-host
        done

        echo "Setup the test"
        for HOST in $HOSTLIST; do
            KEY="$( grep "$HOST" login_info.tmp | cut -f3)" 
            USER="$( grep "$HOST" login_info.tmp | cut -f2)"
            ./disk/disktest.sh $CONF $USER $KEY $HOST setup-test
        done
    fi
fi

# [Running network test] **********************************************
if [ "$NETWORKTEST_ENABLE" = "TRUE" ]; then
    #TODO: running network test
fi
# [Running disk test ] ************************************************
if [ "$DISKTEST_ENABLE" = "TRUE" ]; then
    #TODO: running disk test

    # Run measurement in parallel on host
    echo "Running the disk test"
    if [ "$DISKTEST_MODE" = "CONCURRENT" ]
        for HOST in $HOSTLIST; do
            ./disk/disktest.sh $CONF $USER $KEY $HOST run &
        done

        # Wait for all hosts to complete
        FAIL=0
        for job in `jobs -p`
        do
            wait $job || let "FAIL+=1"
        done
    
        if [ "$FAIL" == "0" ]; then
            echo "Tests ran well"
        else
        echo "There is/are ($FAIL) test/s"
        fi
    else
    # Run measurement in continuous on host
        for HOST in $HOSTLIST; do
            KEY="$( grep "$HOST" login_info.tmp | cut -f3)" 
            USER="$( grep "$HOST" login_info.tmp | cut -f2)"
            ./disk/disktest.sh $CONF $USER $KEY $HOST run &
        done
    fi
    
    echo "Collecting test output"
    for HOST in $HOSTLIST; do
        KEY="$( grep "$HOST" login_info.tmp | cut -f3)" 
        USER="$( grep "$HOST" login_info.tmp | cut -f2)"
        ./disk/disktest.sh $CONF $USER $KEY $HOST collect-data
    done

    echo "Clean the host"
    for HOST in $HOSTLIST; do
        KEY="$( grep "$HOST" login_info.tmp | cut -f3)" 
        USER="$( grep "$HOST" login_info.tmp | cut -f2)"
        ./disk/disktest.sh $CONF $USER $KEY $HOST clean
    done
fi

#TODO: Removing intermediate files
rm -f login_info.tmp