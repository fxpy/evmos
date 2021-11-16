#!/bin/bash
exists()
{
  command -v "$1" >/dev/null 2>&1
}
if exists curl; then
  echo ''
else
  sudo apt install curl -y < "/dev/null"
fi
bash_profile=$HOME/.bash_profile
if [ -f "$bash_profile" ]; then
    . $HOME/.bash_profile
fi

function setupVars {
  if [ ! $EVMOS_NODENAME ]; then
    read -p "Enter node name: " EVMOS_NODENAME
    echo 'export EVMOS_NODENAME='\"${EVMOS_NODENAME}\" >> $HOME/.bash_profile
  fi
  if [ ! $EVMOS_WALLET ]; then
    read -p "Enter wallet name: " EVMOS_WALLET
    echo 'export EVMOS_WALLET='\"${EVMOS_WALLET}\" >> $HOME/.bash_profile
  fi
  echo -e '\n\e[42mYour wallet name:' $EVMOS_WALLET '\e[0m\n'
  echo 'export EVMOS_CHAIN=evmos_9000-2' >> $HOME/.bash_profile
  echo 'source $HOME/.bashrc' >> $HOME/.bash_profile
  . $HOME/.bash_profile
  sleep 1
}


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

git checkout v0.1.3

# git checkout -b XXX tags/XXXXX

make install
cd

# delete old genesis if exsist
rm $HOME/.evmosd/config/genesis.json

# init
evmosd init ${EVMOS_NODENAME} --chain-id $EVMOS_CHAIN
