# add-swapfile
Create and mount SWAPFILE and add value "vm.swappiness=5".

Requirements
------------
Ubuntu or Centos system and some free space on the disk.

Distros tested
------------
Currently, this is only tested on ubuntu 14.04 and centos 6.7. It should theoretically work on older versions of Ubuntu or Debian based systems.

Usage
------------
```shell
./swap_add.sh /swapfile 1G
```
