#Getting Started
Run `./whvm.sh init` to initialize the VM and create three snapshots, the snapshots are:

* `prebuild_(datetime)`: VM before WhereHows was built
* `built_(datetime)`: VM just after WhereHows was built
* `prebuild_internal_use`: this is used by the script internally when running the `rebuild` command

Launch the VM by running `./whvm.sh start`. This will start the VM and start the WhereHows services running in the background. Their logs can be found at `~/backend-service.log` and `~/web.log`.

###Important Notes
* **Don't use** `vagrant up` **to create and provision the VM! This will almost certainly fail!**
* If you replace the default `WhereHows.tar.gz` file in `pre_downloads/` make sure that when it extracts the resulting folder is named `WhereHows`
* Most VM actions you might want to take have probably already been automated with `whvm.sh` or might have a special way that they need to be done, look at `whvm.sh`'s documentation in this document or in the script itself first to save yourself some time and maybe a headache
* It's probably a good idea to add an alias for `whvm.sh` to your `.bash_profile` like so: `alias wh="./whvm.sh"`

##Breakdown of files

###`sed_cmds.sh`
Has the `sed` commands for correcting the SQL database creation commands. Uses absolute paths to WhereHows files, so if WhereHows is moved then these need to be updated.

###`.bashrc`
Replaces the default `.bashrc` file on the VM, put your aliases, extra sources, etc here (note that this is what starts the WhereHows services in the background, so make sure not to remove those commands accidentally).

###`extra.sh`
This script is run after everything else is set up on the VM, use it to install extra utils or do some automated configuring.

###`playapp`
This script is run automatically on VM login by `.bashrc` with some arguments to automatically start the WhereHows services in the background.

###`pre_downloads/`
This folder has several compressed folders which are uploaded to the VM to avoid having to redownload them every time the VM is reprovisioned.

###`hreq.sh`
This script makes sending `POST`, `PUT`, and `GET` requests to WhereHows easier. Run it like so: `./hreq.sh {post|put|get} {file|URL} {URL}`

###`whvm.sh`
Abstracts away and simplifies some VM actions. Commands:

* `save name` saves a snapshot with the specified name plus a datetime
* `restore [name]` restores VM to specified snapshot, requires full name
* `list` lists all current existing snapshots
* `restart` halts, ups, and logs into VM
* `reconfig provision` halts, and ups VM with specified provision
* `init` deletes and existing VM, creates a new one with certain provisions, and creates previously mentioned snapshots
* `start` makes sure VM is up and logs in
* `delete [name]` deletes specified snapshot, requires full name
* `configFrom provision` reprovisions from specified provision (including that provision), note that it does not do any sort of snapshot rollback
* `rebuild` assumes there is a `WhereHows/` directory in the same directory that this command is run, command zips that directory, moves it into `pre_downloads/`, rolls back to the `prebuild_internal_use` snapshot, and reprovisions from `where_git`
* `ready` functions much like `init` but stops after `prebuild_internal_use` is created
* `repull` issues a git pull to refresh the local `WhereHows` repo. **NOTE THAT THIS IS LIKELY TO NOT WORK**
* `build` this rebuilds WhereHows in place on the VM, so you can cchange a few files and not have to rebuild the entirety of WhereHows