#!/bin/bash

# Remove all comments in scenario file #########################
sed '/#/!b;s/^/\n/;ta;:a;s/\n$//;t;s/\n\(\("[^"]*"\)\|\('\''[^'\'']*'\''\)\)/\1\n/;ta;s/\n\([^#]\)/\1\n/;ta;s/\n.*//' $1 | sed '/^$/d' > $1.clean
# Read globale variable ########################################



# Generate list of nodes will attend the test ##################
NODE_POSITION="$( grep -n -e '\[NODES\]' $1.clean | cut -d':' -f1 )"
NEXT_NODE_POSITION="$( tail -n +$NODE_POSITION $1.clean | grep -m 2 -n -e '\[.*\]' | tail -n 1 | cut -d':' -f1)"
if [ "$NEXT_NODE_POSITION" = "" ]; then
    # [NODES] info was put at the end or scen doesn't have network test plan and disk test plan
    LIST_OF_NODES=$( tail -n +$NODE_POSITION $1.clean | grep -e '\[.*\]' -v )
else
    LIST_OF_NODES=$( tail -n +$NODE_POSITION $1.clean | head -n $NEXT_NODE_POSITION | grep -e '\[.*\]' -v )
fi
DEFAULT_USER=$( grep "config.user" $1.clean | cut -d"=" -f2 | sed 's/\"//g' )
DEFAULT_KEY=$( grep "config.key" $1.clean | cut -d"=" -f2 | sed 's/\"//g' )

echo "Default user: $DEFAULT_USER"
echo "Defaulr key:  $DEFAULT_KEY"

if [ -f $1.listofnodes ]; then
    rm -f $1.listofnodes
fi

if [ "$LIST_OF_NODES" != '' ]; then
    for NODE_CONF in $LIST_OF_NODES; do
        echo $NODE_CONF
        NODE=$( echo "$NODE_CONF" | cut -d':' -f1 )
        USER=$( echo "$NODE_CONF" | cut -d':' -f2 )
        if [ "$USER" = "" ]; then
            USER=$DEFAULT_USER
        fi
        KEY=$( echo "$NODE_CONF" | cut -d':' -f3 )
        if [ "$KEY" = "" ]; then
            KEY=$DEFAULT_KEY
        fi
        echo -e "$NODE\t$USER\t$KEY" >> $1.listofnodes
    done
fi

# Generate network test plan #####################################

NETWORK_POSITION="$( grep -n -e '\[DISK\]' $1.clean | cut -d':' -f1 )"
if [ "$NETWORK_POSITION" = "" ]; then
    NETWORKTEST_ENABLE="FALSE"
else
    NEXT_NETWORK_POSITION="$( tail -n +$DISK_POSITION $1.clean | grep -m 2 -n -e '\[.*\]' | tail -n 1 | cut -d':' -f1)"
    if [ "$NEXT_DISK_POSITION" = "" ]; then
        # [DISK] info was put at the end or scen doesn't have network test plan and disk test plan
        # TODO
    else
        # TODO
    fi
fi
# TODO

export $NETWORKTEST_ENABLE

# Generate disk test plan ########################################
# Find list of ignored nodes
DISK_POSITION="$( grep -n -e '\[DISK\]' $1.clean | cut -d':' -f1 )"
IGNORED_POSITION="$( tail -n +$DISK_POSITION $1.clean | grep -n -e '\[ignore\]' $1.clean | cut -d':' -f1 )"
if [ "$DISK_POSITION" = "" ]; then
    DISKTEST_ENABLE="FALSE"
else
    DISKTEST_ENABLE="TRUE"
    if [ "$IGNORED_POSITION" = "" ]; then
        cat $1.listofnodes > $1.disktestnodes
    else
        NEXT_DISK_POSITION="$(  tail -n +$DISK_POSITION $1.clean | tail -n +$IGNORED_POSITION | grep -m 2 -n -e '\[.*\]' | tail -n 1 | cut -d':' -f1)"
        if [ "$NEXT_DISK_POSITION" = "" ]; then
            # [DISK] info was put at the end or scen doesn't have network test plan and disk test plan
            DISKTEST_IGNORED_NODES=$( tail -n +$NODE_POSITION $1.clean |  tail -n +$IGNORED_POSITION | head -n $NEXT_DISK_POSITION | grep -e '\[.*\]' -v )
        else
            DISKTEST_IGNORED_NODES=$( tail -n +$NODE_POSITION $1.clean |  tail -n +$IGNORED_POSITION | grep -e '\[.*\]' -v )
        fi
        for NODE_CONF in $LIST_OF_NODES; do
            NODE=$( echo $NODE_CONF | cut -d':' -f1 )
            IGNORED=$( echo "$DISKTEST_IGNORED_NODES" | grep "$NODE" )
            if [ "$IGNORED" = "" ]
                grep "$NODE" $1.listofnodes >> $1.disktestnodes
            fi
        done
    fi
fi
# Find list of ignored nodes

DEFAULT_DISKTEST_OUTPUT="disktest.out"
DEFAULT_DISKTEST_MODE="concurrent"
DEFAULT_DISKTEST_CONFIG="sequenceread.fio"

DISKTEST_OUTPUT=$( grep "disk.output" $1.clean | cut -d"=" -f2 | sed 's/\"//g' )
DISKTEST_CONFIG=$( grep "disk.config" $1.clean | cut -d"=" -f2 | sed 's/\"//g' )
DISKTEST_MODE=$( grep "disk.mode" $1.clean | cut -d"=" -f2 | sed 's/\"//g' )

if [ "$DISKTEST_OUTPUT" = "" ]; then
    DISKTEST_OUTPUT=$DEFAULT_DISKTEST_OUTPUT
fi

if [ "$DISKTEST_MODE" = "" ]; then
    DISKTEST_MODE=$DEFAULT_DISKTEST_MODE
fi

if [ "$DISKTEST_CONFIG" = "" ]; then
    DISKTEST_CONFIG=$DEFAULT_DISKTEST_CONFIG
fi

export $DISKTEST_CONFIG
export $DISKTEST_OUTPUT
export $DISKTEST_MODE
export $DISKTEST_ENABLE


