#!/bin/bash
# place for installing stuff, doing configs, etc

cd /home/ubuntu/

sudo apt --assume-yes install python3-setuptools

# install suplemon
git clone https://github.com/richrd/suplemon.git
cd /home/ubuntu/suplemon
sudo python3 setup.py install

# install iterm shell integration
curl -L https://iterm2.com/misc/install_shell_integration_and_utilities.sh | bash