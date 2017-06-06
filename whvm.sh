#!/bin/bash

# saves snapshot with given name and current date
save() {
	DATE=`date +%Y_%m_%d-%H:%M`	
	NAME="${1}_${DATE}"
	vagrant snapshot save $NAME
}

# restores to specified snapshot
restore() {
	if [ -z "$1" ]; then
		snaps=( $(vagrant snapshot list) )
		num_snaps=${#snaps[@]}
		echo $num_snaps
		for i in `seq 0 $(($num_snaps-1))`; do
			echo $i : ${snaps[$i]}
		done
		echo "pick a snapshot#: "
		read snap
		vagrant snapshot restore ${snaps[$snap]} --no-provision
	else
		vagrant snapshot restore $1 --no-provision
	fi
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
	vagrant --force destroy
	vagrant up --provision-with prebuild
	vagrant halt
	DATE=`date +%Y_%m_%d-%H-%M`
	NAME="prebuild_${DATE}"
	vagrant snapshot save $NAME
	osascript -e 'display notification "prebuild done" with title "It done" sound name "Ping"'

	vagrant up --provision-with build
	vagrant halt
	DATE=`date +%Y_%m_%d-%H-%M`
	NAME="built_${DATE}"
	vagrant snapshot save $NAME
	osascript -e 'display notification "built done" with title "It done" sound name "Ping"'

	vagrant up --provision-with sed_script
	vagrant up --provision-with sql
	vagrant halt
	DATE=`date +%Y_%m_%d-%H-%M`
	NAME="sql_${DATE}"
	vagrant snapshot save $NAME
	osascript -e 'display notification "sql done" with title "It done" sound name "Ping"'

	vagrant up --provision-with extra_installs
	vagrant up --provision-with bashrc
	vagrant up --provision-with wh_starter
	vagrant up --provision-with extras
	vagrant halt
	DATE=`date +%Y_%m_%d-%H-%M`
	NAME="full_${DATE}"
	vagrant snapshot save $NAME
	osascript -e 'display notification "full done" with title "It done" sound name "Ping"'

	osascript -e 'display notification "VM finished successfully?" with title "It done" sound name "Ping"'

	vagrant snapshot list
}

# starts vm
start() {
	vagrant up
	vagrant ssh
}

# deletes specified snapshot
delete() {
	if [ -z "$1" ]; then
		snaps=( $(vagrant snapshot list) )
		num_snaps=${#snaps[@]}
		echo $num_snaps
		for i in `seq 0 $(($num_snaps-1))`; do
			echo $i : ${snaps[$i]}
		done
		echo "pick a snapshot#: "
		read snap
		vagrant snapshot delete ${snaps[$snap]}
	else
	vagrant snapshot delete $1
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
	delete)
		delete $2
		;;
	*)
		echo "Usage: whvm.sh {save|restore|list|restart|reconfig|init|start|delete} {snapshot-name|provison-name}"
		exit 1
		;;
esac