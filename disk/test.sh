#!/bin/bash
# To test the script for disk test

HOSTLIST=$( cat testdir/hosts.lst )
KEY="testdir/hasonhai.cer"
USER="ubuntu"
CONF="testdir/random-read-test.fio"

chmod a+x disktest.sh
echo "Setup the host"
for HOST in $HOSTLIST; do
    ./disktest.sh $CONF $USER $KEY $HOST setup-host
done

echo "Setup the test"
for HOST in $HOSTLIST; do
    ./disktest.sh $CONF $USER $KEY $HOST setup-test
done

# Run measurement in parallel on host
echo "Running the test"
for HOST in $HOSTLIST; do
    ./disktest.sh $CONF $USER $KEY $HOST run &
done

# Wait for all hosts to complete
FAIL=0
for job in `jobs -p`
do
    echo $job
    wait $job || let "FAIL+=1"
done

if [ "$FAIL" == "0" ];
then
    echo "Tests ran well"
else
    echo "There is/are ($FAIL) test/s"
fi

echo "Collecting test output"
for HOST in $HOSTLIST; do
    ./disktest.sh $CONF $USER $KEY $HOST collect-data
done

echo "Clean the host"
for HOST in $HOSTLIST; do
    ./disktest.sh $CONF $USER $KEY $HOST clean
done
