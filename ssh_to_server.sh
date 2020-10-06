#!/usr/bin/env bash

#Script exits if serverName parameter is absent:
: ${1?"Usage: $0 SERVERNAME"}

SERVERNAME=$1
USERNAME=ubuntu

function get_server_details() {

    SERVERIP=$(yq r inventory.yml "$1.ip")
    BASTIONIP=$(yq r inventory.yml "$1.bastion")
    echo "You are trying to connect to $SERVERIP through $BASTIONIP"

}

function ssh_to_server() {
    eval $(ssh-agent -s) &> /dev/null
    ssh-add -D &> /dev/null
    ssh-add -k /workdir/backend1_private_key.pem &> /dev/null
    ssh-add -k /workdir/bastion.pem &> /dev/null
    #The ProxyJump, or the -J flag, was introduced in ssh version 7.3.
    CONNECTIONSTRING="$USERNAME@$BASTIONIP $USERNAME@$SERVERIP"
    echo "Your connection string: $CONNECTIONSTRING"
    ssh -J $CONNECTIONSTRING

}

get_server_details "$SERVERNAME"
ssh_to_server