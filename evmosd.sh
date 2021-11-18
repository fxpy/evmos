#!/bin/bash
exists()
{
  command -v "$1" >/dev/null 2>&1
}

bash_profile=$HOME/.bash_profile
if [ -f "$bash_profile" ]; then
    . $HOME/.bash_profile
fi

read -p "Enter node name: " EVMOS_NODENAME
echo 'export EVMOS_NODENAME='\"${EVMOS_NODENAME}\" >> $HOME/.bash_profile

read -p "Enter wallet name: " EVMOS_WALLET
echo 'export EVMOS_WALLET='\"${EVMOS_WALLET}\" >> $HOME/.bash_profile

echo -e '\n\e[42mYour wallet name:' $EVMOS_WALLET '\e[0m\n'
echo 'export EVMOS_CHAIN=evmos_9000-2' >> $HOME/.bash_profile
echo 'source $HOME/.bashrc' >> $HOME/.bash_profile
. $HOME/.bash_profile


# Update if needed
sudo apt update && sudo apt upgrade -y

# Install packages
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential git make ncdu -y

# Install GO 1.17.2
ver="1.17.2"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
. $HOME/.bash_profile

# install evmos

cd $HOME
rm -r evmos
git clone https://github.com/tharsis/evmos.git
cd evmos

git checkout v0.2.0

make install

# delete old genesis if exist
rm $HOME/.evmosd/config/genesis.json

# init
evmosd init ${EVMOS_NODENAME} --chain-id $EVMOS_CHAIN

evmosd config chain-id evmos_9000-2
evmosd config keyring-backend file

echo 'Please restore your wallet and perform genTX'
