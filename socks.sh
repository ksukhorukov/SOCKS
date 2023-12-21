#!/bin/bash

SOCKS_PORT=5555

if [ -z "${VERBOSE}" ]; then
  export STD_REDIRECT=/dev/null
else
  export STD_REDIRECT=/dev/stdout
fi

usage() {
  echo "USAGE: $0 [ install | start | stop | status ]"
  exit
}

start() {
  installed?
  ufw allow $SOCKS_PORT
  EXTERNAL_IP=`ifconfig eth0 | grep inet | awk '{print $2}' | head -n 1`
  `ssh -g -f -N -D $SOCKS_PORT $EXTERNAL_IP > $STD_REDIRECT`
}

stop() {
  PID="$(pid)"

  if [[ $PID =~ ^[0-9]+$ ]]; then
    `kill -9 $PID > $STD_REDIRECT`
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

install() {
  `sudo apt-get update > $STD_REDIRECT`

  `sudo apt-get upgrade > $STD_REDIRECT`

  `sudo apt-get install ufw > $STD_REDIRECT`

  `sudo ufw allow 22 > $STD_REDIRECT`

  `sudo ufw allow $SOCKS_PORT > $STD_REDIRECT`
  
  echo '[+] SOCKS INSTALLED. STARTING...'
  start
  status
  echo '[+] INSTALLATION COMPLETE'
}

installed?() {
  INSTALLED=`which ufw | wc -l`

  if [ $INSTALLED == 0 ]; then
    install
    echo '[+] FIREWALL INSTALLED'
  fi

  UFW_PORT_ALLOWED=`"ufw status | grep $SOCKS_PORT | grep -i allow | grep -i anywhere | wc -l"`

  if [ $UFW_PORT_ALLOWED < 2 ]; then
    `"sudo ufw allow $PORT > $STD_REDIRECT"`
    echo "[+] $PORT now accepts incomming connections"
  fi
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
  install)
    install 
    ;;
  *)
    usage
    ;;
esac