#!/bin/bash

SOCKS_PORT=5555

usage() {
  echo "USAGE: $0 [ install | start | stop | status ]"
  exit
}

start() {
  installed?
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

install() {
  sudo apt-get update > /dev/null
  sudo apt-get upgrade > /dev/null
  sudo apt-get install ufw
  sudo ufw allow 22 > /dev/null
  sudo ufw allow $SOCKS_PORT > /dev/null
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
    `"sudo ufw allow $PORT"`
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