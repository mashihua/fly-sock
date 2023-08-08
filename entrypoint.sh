#!/bin/sh

set -e

_term() { 
  echo "Stop child process $child with SIGINT signal!"
  kill -INT "$child" 2>/dev/null
  echo "Send to chind $child SIGINT signal!"
}

# fly.io must use bind fly-global-services for UDP Server
/usr/local/bin/dnsforwarder -b fly-global-services &
# /usr/local/bin/dnsforwarder -b fly-global-services -s 208.67.222.222:443 &


if [ "$1" = "ss-server" ]; then
    COREVER=$(uname -r | grep -Eo '[0-9].[0-9]+' | sed -n '1,1p')
    CMV=$(echo $COREVER | awk -F '.' '{print $1}')
    CSV=$(echo $COREVER | awk -F '.' '{print $2}')

    if [[ -f "$PASSWORD_FILE" ]]; then
        PASSWORD=$(cat "$PASSWORD_FILE")
    fi
    
    if [[ -f "/var/run/secrets/$PASSWORD_SECRET" ]]; then
        PASSWORD=$(cat "/var/run/secrets/$PASSWORD_SECRET")
    fi
    
    if [[ ! -z "$DNS_ADDRS" ]]; then
        DNS="-d $DNS_ADDRS"
    fi

    if [ $(echo "$CMV >= 3" | bc) ]; then
        if [ $(echo "$CSV > 7" | bc) ]; then
        TFO='--fast-open'
        fi
    fi 
    RT_ARGS="-s $SERVER_ADDR -p $SERVER_PORT -k ${PASSWORD:-$(hostname)} -m $METHOD -a nobody -t $TIMEOUT -u $DNS $TFO $ARGS"
fi

trap _term SIGINT
exec $@ $RT_ARGS

child=$!
echo "Started ss pid $child";
wait "$child"