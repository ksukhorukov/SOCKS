#!/bin/bash

SOCKS_PORT=5555

usage() {
  echo "USAGE: $0 [ start | stop | status ]"
  exit
}

start() {
  ufw allow $SOCKS_PORT
  EXTERNAL_IP=`ifconfig eth0 | grep inet | awk '{print $2}' | head -n 1`
  `ssh -g -f -N -D $SOCKS_PORT $EXTERNAL_IP`
}

stop() {
  PID="$(pid)"

  if [[ $PID =~ ^[0-9]+$ ]]; then
    `kill -9 $PID`
  fi
}

status() {
  PID="$(pid)"
  if [[ $PID =~ ^[0-9]+$ ]]; then
    echo "STATUS: UP"
    exit
  fi

  echo "STATUS: DOWN"
}

pid() {
  PID=`lsof -i :$SOCKS_PORT | awk {'print $2'} | head -n 2 | tail -n 1`
  echo "$PID"
}

if [ "$#" -ne 1 ]; then 
  usage
fi

case $1 in 
  start)
    echo 'STARTING...'
    start
    status
    ;;
  stop)
    echo 'STOPING...'
    stop
    status
    ;;
  status) 
    status
    ;;
  *)
    usage
    ;;
esac