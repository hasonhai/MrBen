#!/bin/bash
# To test the script for disk test

HOSTLIST=$( cat testdir/hosts.lst )
KEY="testdir/hasonhai.cer"
USER="ubuntu"
CONF="testdir/four-threads-randio.fio"

chmod a+x disktest.sh
echo "Setup the host"
for HOST in $HOSTLIST; do
    ./disktest.sh $CONF $USER $KEY $HOST setup-host
done

echo "Setup the test"
for HOST in $HOSTLIST; do
    echo "Setup the test"
    ./disktest.sh $CONF $USER $KEY $HOST setup-test
done

echo "Running the test"
for HOST in $HOSTLIST; do
    ./disktest.sh $CONF $USER $KEY $HOST run
done

echo "Collecting test output"
for HOST in $HOSTLIST; do
    ./disktest.sh $CONF $USER $KEY $HOST collect-data
done

echo "Clean the host"
for HOST in $HOSTLIST; do
    ./disktest.sh $CONF $USER $KEY $HOST clean
done
