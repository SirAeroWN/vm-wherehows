# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "ubuntu/xenial64"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
   config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
     vb.memory = "4096"
   end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
   config.vm.provision "shell", inline: <<-SHELL
     export DEBIAN_FRONTEND=noninteractive
     apt update
     apt install -y vim emacs openjdk-8-jdk unzip mysql-server


     cd /opt
     wget –quiet http://downloads.typesafe.com/play/2.2.4/play-2.2.4.zip
     unzip play-2.2.4.zip
     rm play-2.2.4.zip
     chown -R ubuntu play-2.2.4
     echo 'export PLAY_HOME="/opt/play-2.2.4"' >> /opt/activate_play_home

     git clone https://github.com/linkedin/WhereHows.git
     chwon -R ubuntu WhereHows

     cd WhereHows
     git checkout -b v0.2.0 tags/v0.2.0

     cd data-model/DDL

     # Customize - it says so IN THE SOURCE CODE!
     sed -i "s|US/Pacific|$(date +%Z)|g" ETL_DDL/kafka_tracking.sql

     # JUNK! - NOT EVEN VALID CONSTAINTS!!!
     sed -i "s|\`owner_type\`      VARCHAR(50) DEFAULT NULL COMMENT 'which acl file this owner is in'|\`owner_type\`      VARCHAR(50) NOT NULL COMMENT 'which acl file this owner is in'|" ETL_DDL/git_metadata.sql
     sed -i "s|\`owner_name\`      VARCHAR(50) DEFAULT NULL COMMENT 'one owner name'|\`owner_name\`      VARCHAR(50) NOT NULL COMMENT 'one owner name'|" ETL_DDL/git_metadata.sql
     sed -i "s|PRIMARY KEY (\`dataset\`,\`cluster\`,\`partition_name\`,\`log_event_time\`)|PRIMARY KEY (\`dataset\`,\`cluster\`,\`log_event_time\`)|" ETL_DDL/kafka_tracking.sql
     sed -i "s|\`datacenter\`      VARCHAR(20)        DEFAULT NULL,|\`datacenter\`      VARCHAR(20)        NOT NULL,|" ETL_DDL/dataset_info_metadata.sql

     mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -u root mysql
     mysql -u root <<< "CREATE DATABASE wherehows DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;"
     mysql -u root <<< "CREATE USER 'wherehows';"
     mysql -u root <<< "SET PASSWORD FOR 'wherehows' = PASSWORD('wherehows');"
     mysql -u root <<< "GRANT ALL ON wherehows.* TO 'wherehows';"
     mysql -uwherehows -pwherehows -Dwherehows < create_all_tables_wrapper.sql
     cd ../..

     sudo -u ubuntu PLAY_HOME="/opt/play-2.2.4" SBT_OPTS="-Xms1G -Xmx2G -Xss16M" PLAY_OPTS="-Xms1G -Xmx2G -Xss16M"  ./gradlew build
   SHELL
end
