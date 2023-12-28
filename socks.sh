# Copyright 2023 KIRILL SUKHORUKOV

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License V.3
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

#!/bin/bash

if [ -z $SOCKS_PORT ]; then 
  SOCKS_PORT=5555
fi

export STD_REDIRECT=/dev/null

if [ -z "${VERBOSE}" ]; then
  export STD_REDIRECT=/dev/stdout
fi 

usage() {
  echo "USAGE: $0 [ install | start | stop | status ]"
  exit
}

start() {
  installed?
  ufw allow $SOCKS_PORT
  EXTERNAL_IP=`hostname -I | awk '{print $1}'`
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
  sudo apt-get update -y > $STD_REDIRECT 
  sudo apt-get upgrade -y > $STD_REDIRECT
  sudo apt-get install ufw -y > $STD_REDIRECT
  sudo ufw allow 22 > $STD_REDIRECT
  sudo ufw allow $SOCKS_PORT > $STD_REDIRECT
  
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

  UFW_PORT_ALLOWED=`ufw status | grep $SOCKS_PORT || echo 'nothing found' | grep -i allow || echo 'nothing found' | grep -i anywhere || echo 'nothing found' | wc -l`

  if [ $UFW_PORT_ALLOWED < 2 ]; then
    sudo ufw allow $PORT > $STD_REDIRECT
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