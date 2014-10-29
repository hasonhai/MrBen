#!/bin/bash
# Remove all comments in scenario file
sed '/#/!b;s/^/\n/;ta;:a;s/\n$//;t;s/\n\(\("[^"]*"\)\|\('\''[^'\'']*'\''\)\)/\1\n/;ta;s/\n\([^#]\)/\1\n/;ta;s/\n.*//' $1 | sed '/^$/d' > $1.clean

NODE_POSITION="$( grep -n "[NODES]" $1.clean | cut -d':' -f1 )"
NEXT_NODE_POSITION="$( tail -n +$NODE_POSITION $1.clean | grep -m 1 -n -e '\[.*\]' | cut -d':' -f1)"
LIST_OF_NODE=$( head -n -$NODE_POSITION $1.clean | tail -n +$NEXT_NODE_POSITION | grep -e '\[.*\]' -v )