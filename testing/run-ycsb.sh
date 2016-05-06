#!/bin/bash

if [ $# -lt 4 ] ; then
	echo >&2 "Usage: $0 <node-count> <workload> <record-count> <operation-count>"
	exit 1
fi

node_count="$1"
workload="$2"
recordcount="$3"
operationcount="$4"

hosts=""
for n in `seq $node_count`; do
	hosts="$hosts$sep"10.1.1.$(( n + 1 ))
	sep=","
done

cqlsh -f setup-ycsb.cql `/proj/comp150/cassandra/ip-addr -private`
ycsb/bin/ycsb load cassandra2-cql -p distribution=uniform -p measurementtype=raw -p hosts=$hosts -P $workload -p recordcount=$recordcount -p operationcount=$operationcount -s
ycsb/bin/ycsb run  cassandra2-cql -p distribution=uniform -p measurementtype=raw -p hosts=$hosts -P $workload -p recordcount=$recordcount -p operationcount=$operationcount -s

