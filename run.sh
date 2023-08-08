#! /usr/bin/env bash

app=$1

if [ "$app" = "" ]; then
    echo "Usage: run.sh <app> [password]"
    exit 1
fi

if [ "$2" != "" ]; then
    PASSWORD=$2
fi

flyctl auth login
flyctl apps create $app
flyctl regions set sea -a $app
flyctl ips allocate-v4 -a $app
flyctl secrets set PASSWORD="$PASSWORD" -a $app
flyctl deploy -a $app
flyctl status -a $app