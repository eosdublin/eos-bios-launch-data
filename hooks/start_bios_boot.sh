#!/bin/bash

CONFIGDIR=/etc/eos/scholar
DATADIR=/var/opt/eos/scholar

# `start_bios_boot` hook
# $1 genesis JSON
# $2 ephemeral public key
# $3 ephemeral private key

echo "Killing running nodes"
killall nodeos

echo "Phasing out any previous blockchain from disk"
rm -rf $DATADIR/blocks $DATADIR/shared_mem

echo "Copying base config"
# This one shouldn't contain any `producer-name` nor `private-key` nor `enable-stale-production` statements.
cp base_config.ini $CONFIGDIR/config.ini

echo "Writing genesis.json"
echo $1 > $CONFIGDIR/genesis.json

echo "plugin = eosio::producer_plugin" >> $CONFIGDIR/config.ini
echo "producer-name = eosio" >> $CONFIGDIR/config.ini

echo "enable-stale-production = true" >> $CONFIGDIR/config.ini
echo "private-key = [\"$2\",\"$3\"]" >> $CONFIGDIR/config.ini

# Replace this by some automated command to restart the node.
echo "CONFIGURATION DONE: Re/start nodeos, and press ENTER"
read
