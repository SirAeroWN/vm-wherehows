#Getting Started
---------------------
Run `./whvm.sh init` to initialize the VM and create four snapshots, the snapshots are:

* prebuild_(datetime): VM before WhereHows was downloaded and built
* built_(datetime): VM just after WhereHows was built
* sql_(datetime): VM just after the SQL databases were created
* full_(datetime): VM after `extra.sh` was run

Launch the VM by running `./whvm.sh start`. This will start the VM and start the WhereHows services running in the background. Thier logs can be found at `~/application_backend-service.log` and `~/application_web.log`.

##Breakdown of files

###`sed_cmds.sh`
_____________________
Has the `sed` commands for correcting the SQL database creation commands. Uses absolute paths to WhereHows files, so if WhereHows is moved then these need to be updated.

###`.bashrc`
---------------------
Replaces the default `.bashrc` file on the VM, put your aliases, extra sources, etc here (note that this is what starts the WhereHows services in the background, so make sure not to remove those commands accidentally).

###`extra.sh`
---------------------
This script is run after everything else is set up on the VM, use it to install extra utils or do some automated configuring.

###`playapp`
---------------------
This script is run automatically on VM login by `.bashrc` with some arguments to automatically start the WhereHows services in the background.

###`whvm.sh`
---------------------
Abstracts away and simplifies some VM actions. Commands:

* `save <name>` saves a snapshot with the specified name plus a datetime
* `restore <name>` restores VM to specified snapshot, requires full name
* `list` lists all current existing snapshots
* `restart` halts, ups, and logs into VM
* `reconfig <provision>` halts, and ups VM with specified provision
* `init` deletes and existing VM, creates a new one with certain provisions, and creates previously mentioned snapshots
* `start` makes sure VM is up and logs in