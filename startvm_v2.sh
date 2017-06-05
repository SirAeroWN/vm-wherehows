#!/bin/bash
vagrant up --provision-with bashrc
vagrant up --provision-with prebuild
vagrant halt
DATE=`date +%Y_%m_%d-%H-%M`
NAME="prebuild_${DATE}"
vagrant snapshot save $NAME
osascript -e 'display notification "prebuild done" with title "It done" sound name "Ping"'

vagrant up --provision-with wh_starter
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
vagrant up --provision-with extras
vagrant halt
DATE=`date +%Y_%m_%d-%H-%M`
NAME="full_${DATE}"
vagrant snapshot save $NAME
osascript -e 'display notification "full done" with title "It done" sound name "Ping"'

osascript -e 'display notification "VM finished successfully?" with title "It done" sound name "Ping"'

vagrant snapshot list