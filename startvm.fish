vagrant up --provision-with sed_script;
vagrant up --provision-with bashrc
vagrant up --provision-with extra_installs
vagrant up --provision-with wh_starter
vagrant up --provision-with prebuild
vagrant halt
vagrant snapshot save prebuild
osascript -e 'display notification "prebuild done" with title "It done" sound name "Ping"';

vagrant up --provision-with build;
vagrant halt
vagrant snapshot save built
osascript -e 'display notification "built done" with title "It done" sound name "Ping"';

vagrant up --provision-with sql;
vagrant halt
vagrant snapshot save sql
osascript -e 'display notification "sql done" with title "It done" sound name "Ping"';

vagrant up --provision-with extras;
vagrant halt
vagrant snapshot save full
osascript -e 'display notification "full done" with title "It done" sound name "Ping"';

osascript -e 'display notification "VM finished successfully?" with title "It done" sound name "Ping"';

vagrant snapshot list