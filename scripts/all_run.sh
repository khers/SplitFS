#!/bin/bash

cur_dir=`readlink -f ./`
pmem_dev=$1

if [ -z "$pmem_dev" ] ; then 
	pmem_dev="/dev/pmem0"
fi

# Run YCSB
cd ycsb
taskset -c 0-7 ./run_ycsb.sh "$pmem_dev"
cd $cur_dir

# Run TPCC
cd tpcc
taskset -c 0-7 ./run_tpcc.sh "$pmem_dev"
cd $cur_dir

# Run RSYNC
cd rsync
taskset -c 0-7 ./run_rsync.sh "$pmem_dev"
cd $cur_dir

