#!/bin/bash

# # How Disks Are Found in CentOS 7
# # lsblk
# # ls /dev/sd*
# # fdisk -l
# # Use pvs command to list out your physical volumes
###############################################################################################
# # VBOXMANAGE :
# # 0 ) Check sd list :
# # ls -l /sys/class/block/sda
# vagrant ssh -c lsblk app1
# # # 1 ) VDI image hard disk creation
# # cd 'C:\Program Files\Oracle\VirtualBox\'
# # .\VBoxmanage list vms
# # .\VBoxManage createhd --filename C:\virtualdisk\backup.vdi --size 10000 --format VDI
# # # 2 ) Add the controller port 1
# # .\VBoxManage storagectl app1 --name "SATA Controller" --add sata --controller IntelAHCI --portcount 1 --bootable on
# # # 3 ) Attach the new hard drive
# # .\VBoxManage storageattach app1 --storagectl "SATA Controller" --type hdd --port 3 --device 0 --medium /virtualdisk/backup.vdi
# # 4 ) Back vagrant file location & reload
# cd 'C:\Projets\ProjetA\Joomla'
# vagrant reload app1
##############################################################################################


# 1 ) Verify Raw Hard Drive added in Vagranfile
# v.customize ['createhd', '--filename', 'app1-disk1.vmdk', '--size', "4124"]
# v.customize ['storageattach', :id, '--storagectl', 'IDE Controller', '--port', "1", '--device', "0", '--type', 'hdd', '--medium', 'app1-disk1.vmdk']
vagrant ssh -c lsblk app1
vagrant ssh app1


# 2 ) Identify new attached raw disk
# sudo dmesg | grep -i sd
sudo fdisk -l | grep -i /dev/sd

# 3 )  Intall lvm2 package and create PV (Physical Volume)
sudo yum install lvm2 -y
sudo pvcreate /dev/sdb

# To verify pv status run
sudo pvs /dev/sdb

# 4 ) Create VG (Volume Group)
sudo vgcreate volgrp01 /dev/sdb

# Commands to verify the status of vg (volgrp01)
# sudo vgdisplay volgrp01
sudo vgs volgrp01

# 5 ) Create LV (Logical Volume)
# sudo lvcreate -L <Size-of-LV> -n <LV-Name>   <VG-Name>
sudo lvcreate -L 1G -n lv01 volgrp01

# STATUS : Validate the status of lv
# sudo lvdisplay /dev/volgrp01/lv01
sudo lvs /dev/volgrp01/lv01


# 6 ) Format LVM Partition
# command to format LVM partition as ext4 file system.
sudo mkfs.ext4 /dev/volgrp01/lv01

# 7 ) To use above formatted partition, we must mount it on some folder. So, let’s create a folder /mnt/data
sudo mkdir /mnt/data
sudo chmod 777 /mnt/data

# 8 ) Run mount command to mount it on /mnt/data folder
sudo mount /dev/volgrp01/lv01 /mnt/data/

# 9 ) Command to check status
df -Th /mnt/data/

# 10 ) Dump MySQL backup in the new partition directory
# sudo chmod 766 /mnt/data/joomladb.sql
sudo mysqldump -u root -p --skip-password joomladb > /mnt/data/joomladb.sql 2>/dev/null 





# TO DO Add several read to select number of RAW HDDs and size to automate disks creation.
#
# VM=app1
# numDisks=1
# inum=1
# while [ $inum -le $numDisks ]
# do
#     i=`printf %02d $inum`
#     echo "VBoxManage createhd --filename /vm/${VM}/${VM}DISK${i}.vdi --size 1024"
#     echo "VBoxManage storageattach ${VM} --storagectl SATA --type hdd --port ${inum} --device 0 --medium /vm/${VM}/${VM}DISK${i}.vdi"
#     let "inum=inum+1"
# done