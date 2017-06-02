#!/bin/bash
# place for installing stuff, doing configs, etc

cd /home/ubuntu/

apt install fish

# install suplemon
git clone https://github.com/richrd/suplemon.git
cd /home/ubuntu/suplemon
sudo python3 setup.py install

cd ~

# install omf
curl -L -s http://get.oh-my.fish | fish

# setup fish
git clone https://github.com/SirAeroWN/fish_configs.git
cd /home/ubuntu/fish_configs
mv /home/ubuntu/functions /home/ubuntu/.config/fish
cd /home/ubuntu/
rm -rf fish_configs