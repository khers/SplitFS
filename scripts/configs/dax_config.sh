echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
sudo rm -rf /mnt/pmem_emul/*
sudo umount /mnt/pmem_emul
sudo mkfs.ext4 -F -b 4096 "$1"
sudo mount -o dax "$1" /mnt/pmem_emul
