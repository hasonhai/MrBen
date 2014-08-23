#!/bin/bash
# To test the script for disk test

HOSTLIST=$( cat hosts.lst )
KEY="testdir/hasonhai.cer"
USER="ubuntu"
CONF="testdir/random-read-test.fio"

chmod a+x disktest.sh
for HOST in $HOSTLIST; do
    ./disktest.sh $CONF $USER $KEY $HOST setup-host
done

for HOST in $HOSTLIST; do
    ./disktest.sh $CONF $USER $KEY $HOST setup-test
done

for HOST in $HOSTLIST; do
    ./disktest.sh $CONF $USER $KEY $HOST run
done

for HOST in $HOSTLIST; do
    ./disktest.sh $CONF $USER $KEY $HOST collect-data
done

for HOST in $HOSTLIST; do
    ./disktest.sh $CONF $USER $KEY $HOST clean
done