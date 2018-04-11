#!/bin/bash

CONFIGDIR=/etc/eos/scholar
DATADIR=/var/opt/eos/scholar

# `connect_as_participant` hook:
# $1 = p2p_address
# $2 = public key used by BIOS
# $3 = private key used by BIOS
# $4 = genesis_json

echo "Killing running nodes"
killall nodeos

echo "Phasing out any previous blockchain from disk"
rm -rf $DATADIR/blocks $DATADIR/shared_mem

echo "Copying base config"
# This one shouldn't contain any `producer-name` nor `private-key` nor `enable-stale-production` statements.
cp base_config.ini $CONFIGDIR/config.ini

echo "Writing genesis.json"
echo $4 > $CONFIGDIR/genesis.json

# INSERT YOUR NODE NAME HERE:
echo "producer-name = eosdublin" >> $CONFIGDIR/config.ini
echo "plugin = eosio::producer_plugin" >> $CONFIGDIR/config.ini
echo "p2p-peer-address = $1" >> $CONFIGDIR/config.ini
echo "private-key = [\"$NODEOS_PRODUCER_PUBLIC_KEY\",\"$NODEOS_PRODUCER_PRIVATE_KEY\"]" >> $CONFIGDIR/config.ini
echo "resync-blockchain = true" >> $CONFIGDIR/config.ini

# Replace this by some automated command to restart the node.
echo "CONFIGURATION DONE: Re/start nodeos, and press ENTER"
read
