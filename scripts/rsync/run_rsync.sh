#!/bin/bash

cur_dir=`readlink -f ./`
src_dir=`readlink -f ../../`
pmem_dir=/mnt/pmem_emul
setup_dir=$src_dir/scripts/configs
pmem_dev=$1

if [ -z "$pmem_dev" ] ; then
	pmem_dev="/dev/pmem0"
fi

run_rsync()
{
    fs=$1
    for run in 1 2 3
    do
        sudo rm -rf $pmem_dir/*
        sudo taskset -c 0-7 ./run_fs.sh $fs $run
        sleep 5
    done
}

sudo $setup_dir/dax_config.sh "$pmem_dev"
run_rsync dax

sudo $setup_dir/xfs_config.sh "$pmem_dev"
run_rsync xfs

sudo $setup_dir/nova_config.sh "$pmem_dev"
run_rsync nova

sudo $setup_dir/nova_relaxed_config.sh "$pmem_dev"
run_rsync relaxed_nova

sudo $setup_dir/pmfs_config.sh "$pmem_dev"
run_rsync pmfs

sudo $setup_dir/dax_config.sh "$pmem_dev"
run_rsync boost

:'
sudo $setup_dir/dax_config.sh
run_rsync sync_boost

sudo $setup_dir/dax_config.sh
run_rsync posix_boost
'
