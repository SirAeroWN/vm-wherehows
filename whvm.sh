#!/bin/bash

# saves snapshot with given name and current date
save() {
	DATE=`date +%Y_%m_%d-%H-%M`	
	NAME="${1}_${DATE}"
	vagrant snapshot save $NAME
}

# restores to specified snapshot
restore() {
	vagrant snapshot restore $1 --no-provision
}

# prints list of snapshots
list() {
	vagrant snapshot list
}

# stops vm, boots, and opens
restart() {
	vagrant halt
	vagrant up
	vagrant ssh
}

# reboots vm with specified provision
reconfig() {
	vagrant halt
	vagrant up --provision-with $1
}

# first setup of WhereHows VM
init() {
	vagrant halt
	vagrant --force delete
	source ./startvm_v2.sh
}

start() {
	vagrant up
	vagrant ssh
}

case $1 in
	save)
		save $2
		;;
	restore)
		restore $2
		;;
	list)
		list
		;;
	restart)
		restart
		;;
	reconfig)
		reconfig $2
		;;
	init)
		init
		;;
	start)
		start
		;;
	*)
		echo "Usage: whvm.sh {save|restore|list|restart|reconfig|init} {snapshot-name|provison-name}"
		exit 1
		;;
esac