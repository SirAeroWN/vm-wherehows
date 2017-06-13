#!/bin/bash

# gets first occurance of provison in ordered list of provisions
getFirst() {
	# list of provisions in order run
	declare -a provs=("play_zip" "prebuild" "extra_installs" "bashrc" "wh_starter" "extras" "where_git" "build" "sed_script" "sql" "noop")
	numprovs=${#provs[@]}

	# loop through provisions, when $1 is found, stop and return that
	for (( i=0; i<${numprovs}; i++ )); do
		if [ "$1" == "${provs["$i"]}" ]; then
			return $i
		fi
	done

	# otherwise noop will get run
	return $i
}

# saves snapshot with given name and current date
save() {
	DATE=`date +%Y_%m_%d-%H:%M`	
	NAME="${1}_${DATE}"
	vagrant snapshot save $NAME
}

# restores to specified snapshot
restore() {
	# if no snapshot name is given, then give a menu to choose from
	if [ -z "$1" ]; then
		# get a list of all naps
		snaps=( $(vagrant snapshot list) )
		num_snaps=${#snaps[@]}
		#echo $num_snaps

		# display all the snaps
		for i in `seq 0 $(($num_snaps-1))`; do
			echo $i : ${snaps[$i]}
		done

		# prompt to pick snap
		echo "pick a snapshot#: "
		read snap
		vagrant snapshot restore ${snaps[$snap]} --no-provision
	else
		# if snap is given then restore to it
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
	vagrant up && vagrant ssh
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
	vagrant up --provision-with play_zip
	vagrant up --provision-with prebuild
	vagrant up --provision-with extra_installs
	vagrant up --provision-with bashrc
	vagrant up --provision-with wh_starter
	vagrant up --provision-with extras
	vagrant halt
	DATE=`date +%Y_%m_%d-%H-%M`
	NAME="prebuild_${DATE}"
	vagrant snapshot save $NAME
	vagrant snapshot save prebuild_internal_use
	osascript -e 'display notification "prebuild done" with title "It done" sound name "Ping"'

	vagrant up --provision-with where_git
	vagrant up --provision-with build
	vagrant up --provision-with sed_script
	vagrant up --provision-with sql
	vagrant halt
	DATE=`date +%Y_%m_%d-%H-%M`
	NAME="built_${DATE}"
	vagrant snapshot save $NAME
	osascript -e 'display notification "built done" with title "It done" sound name "Ping"'


	osascript -e 'display notification "VM finished successfully?" with title "It done" sound name "Ping"'

	vagrant snapshot list
}

# get VM to a WhereHows ready state
ready() {
	vagrant halt
	vagrant --force destroy
	vagrant up --provision-with play_zip
	vagrant up --provision-with prebuild
	vagrant up --provision-with extra_installs
	vagrant up --provision-with bashrc
	vagrant up --provision-with wh_starter
	vagrant up --provision-with extras
	vagrant halt
	DATE=`date +%Y_%m_%d-%H-%M`
	NAME="prebuild_${DATE}"
	vagrant snapshot save $NAME
	vagrant snapshot save prebuild_internal_use
	osascript -e 'display notification "prebuild done" with title "It done" sound name "Ping"'
}

# starts vm
start() {
	vagrant up && vagrant ssh
}

# deletes specified snapshot
delete() {
	# same process as reconfig above
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
	fi
}

configFrom() {
	# list of provisions in order executed
	declare -a provs=("play_zip" "prebuild" "extra_installs" "bashrc" "wh_starter" "extras" "where_git" "build" "sed_script" "sql" "noop")
	numprovs=${#provs[@]}

	# finds index of first use of $1
	getFirst "$1"

	# index in $?, do provisioning process from here on
	for (( i=$?; i<${numprovs}; i++ )); do
		vagrant up --provision-with ${provs[$i]}
	done

	# save snapshot
	save latest
}

rebuild() {
	# first compress modified WhereHows repo
	tar -czvf WhereHows.tar.gz WhereHows/

	# move it into pre_downloads directory
	mv WhereHows.tar.gz pre_downloads/WhereHows.tar.gz

	# restore to prebuild so don't have to do apt stuff
	vagrant snapshot restore prebuild_internal_use --no-provision

	configFrom where_git
}

# repull WhereHows
repull() {
	rm -rf WhereHows/
	git clone https://github.com/linkedin/WhereHows.git
}

build() {
	reconfig buildinplace
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
	configFrom)
		configFrom $2
		;;
	rebuild)
		rebuild
		;;
	ready)
		ready
		;;
	repull)
		repull
		;;
	build)
		build
		;;
	*)
		#echo "Usage: whvm.sh {save|restore|list|restart|reconfig|init|start|delete|configFrom|rebuild|ready} {snapshot-name|provison-name}"
		echo "Usage:"
		echo "save snapshot-name"
		echo "restore [snapshot-name]"
		echo "list"
		echo "restart"
		echo "reconfig provison-name"
		echo "init"
		echo "start"
		echo "delete [snapshot-name]"
		echo "configFrom provison-name"
		echo "rebuild"
		echo "ready"
		echo "repull"
		echo "build"
		exit 1
		;;
esac