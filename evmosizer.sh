#!/bin/bash

echo ''
echo 'Please check following states are the same:'
echo '(both located in ~/.evmosd/config/app.toml)'
echo ''
echo -e '\e[1mRecommended:'
echo -e 'snapshot-interval = 0'
echo -e '\e[0mYou have:'
cat $HOME/.evmosd/config/app.toml | grep 'snapshot-interval ='    
echo ''
echo -e '\e[1mRecommended:'
echo -e 'pruning-keep-every = "0" '
echo -e '\e[0mYou have:'
cat $HOME/.evmosd/config/app.toml | grep 'pruning-keep-every ='

sed -i.bak -e "s%^indexer = \"kv\"%indexer = \"null\"%" $HOME/.evmosd/config/config.toml

sed -i.bak -e "s%^pruning = \"default\"%pruning = \"custom\"%; s%^pruning-keep-recent = \"0\"%pruning-keep-recent = \"100\"%; s%^pruning-interval = \"0\"%pruning-interval = \"10\"%" $HOME/.evmosd/config/app.toml

echo ''
echo '-=-=-=-=-=-=-=-=-=-=-=-=-=-'
echo -e 'All other states are set to:'
echo -e 'indexer = null'
echo -e 'pruning = custom'
echo -e 'pruning-keep-recent = 100'
echo -e 'pruning-interval = 10'
echo ''
