#!/bin/bash
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:$PATH
#set -x

# path like /swapfile
SW_FILE="$1"

# size like 1G
SW_SIZE="$2"

#========================================
# Handle errors
if [[ -z $SW_FILE || -z $SW_SIZE ]]
then
	echo "ERROR. Please write correct arguments for command, for ex: ./swap_add.sh /swapfile 1G"
	exit 0
fi

swapon -s | grep "$SW_FILE" > /dev/null 2>&1
if [ $? -eq 0 ]
then
	echo "ERROR. $SW_FILE is already created. Exit"
	exit 0
fi
#========================================
# Determine OS

OS_TYPE=$(uname -a | awk '{print $2}')

if [ "$OS_TYPE" = "ubuntu" ]
then 
	echo "UBUNTU"
	fallocate -l "$SW_SIZE" "$SW_FILE"
	chmod 600 "$SW_FILE"
	chown root:root "$SW_FILE"
	mkswap "$SW_FILE"
	swapon "$SW_FILE"

	grep -q "$SW_FILE" /etc/fstab
	if [ $? -ne 0 ]
	then
		echo "$SW_FILE  none  swap  sw 0  0" >> /etc/fstab
	fi

	grep -q "vm.swappiness" /etc/sysctl.conf
	if [ $? -ne 0 ]
	then
		sysctl vm.swappiness=5
		echo "vm.swappiness = 5" >> /etc/sysctl.conf
	fi

elif [ "$OS_TYPE" = "centos" ]
then
	echo "CENTOS"
	fallocate -l "$SW_SIZE" "$SW_FILE"
	chmod 600 "$SW_FILE"
	chown root:root "$SW_FILE"
	mkswap "$SW_FILE"
	swapon "$SW_FILE"

	grep -q "$SW_FILE" /etc/fstab
	if [ $? -ne 0 ]
	then
		echo "$SW_FILE  swap  swap  sw 0  0" >> /etc/fstab
	fi

	grep -q "vm.swappiness" /etc/sysctl.conf
	if [ $? -ne 0 ]
	then
		sysctl vm.swappiness=5
		echo "vm.swappiness = 5" >> /etc/sysctl.conf
	fi
else
	echo "ERROR. Unsupport system"
	exit 0
fi

#========================================
# Rezalt
swapon -s | grep "$SW_FILE" > /dev/null 2>&1
if [ $? -eq 0 ]
then
	echo "$SW_SIZE $SW_FILE is successfully created"
fi
