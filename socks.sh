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

PURPLE='\033[0;35m' 
RED='\033[0;31m' 
BLUE='\033[0;34m' 
WHITE='\033[0;37m' 
GREEN='\033[0;32m'  

PROFILE_FILE='UNDEFINED'

MAJOR_VERSION_PART_REQUIRED=3

out() {
  echo -e "$PURPLE $1"
}

info() {
  echo -e "$BLUE $1"
}

white() {
  echo -e "$WHITE $1"
}

success() {
  echo -e "$GREEN $1"
}

error() {
  echo -e "$RED $1"
  exit
}

if [ -z $SOCKS_PORT ]; then 
  SOCKS_PORT=5555
fi

export STD_REDIRECT=/dev/null

if [ -z "${VERBOSE}" ]; then
  export STD_REDIRECT=/dev/stdout
fi 

pid() {
  PID=`lsof -i :$SOCKS_PORT | awk {'print $2'} | head -n 2 | tail -n 1`
  echo $PID
}

socks_are_installed() {
  INSTALLED=`which ufw`

  if [ -z $INSTALLED ]; then
    install
    success '[+] FIREWALL INSTALLED'
  fi

  INSTALLED=`which ufw`

  if [ -z $INSTALLED ]; then
    error '[-] ERROR! It was not possible to instal UFW'
    exit
  fi

  UFW_PORT_ALLOWED=`ufw status | grep "$SOCKS_PORT" || echo 'nothing found' | grep -i allow || echo 'nothing found' | grep -i anywhere`
  
  if [[ -z $UFW_PORT_ALLOWED ]]; then
    sudo ufw allow $PORT > $STD_REDIRECT
    success "[+] $PORT now accepts incomming connections"
  fi
}

usage() {
  info "USAGE: $0 [ install | start | stop | status ]"
  exit
}

fetch_external_ip() {
  export EXTERNAL_IP=`hostname -I | awk '{print $1}'`
}

allow_socks_port() {
  ufw allow $SOCKS_PORT
}

open_socks_tunnel() {
  `ssh -g -f -N -D $SOCKS_PORT $EXTERNAL_IP > $STD_REDIRECT`
}

display_socket_info() {
  info "[i] SOCKS5 server is now running on $EXTERNAL_IP:$SOCKS_PORT"
}

start() {
  socks_are_installed
  allow_socks_port
  fetch_external_ip
  open_socks_tunnel
  display_socket_info
}

stop() {
  PID="$(pid)"

  if [[ $PID =~ ^[0-9]+$ ]]; then
    `kill -9 $PID > $STD_REDIRECT`
  fi
}

status() {
  PID=$(pid)
  if [[ $PID =~ ^[0-9]+$ ]]; then
    fetch_external_ip
    info '[i] STATUS: UP'
    display_socket_info
    exit
  fi

  info '[i] STATUS: DOWN'
}

install() {
  sudo apt-get update -y > $STD_REDIRECT 
  sudo apt-get upgrade -y > $STD_REDIRECT
  sudo apt-get install ufw -y > $STD_REDIRECT
  sudo ufw allow 22 > $STD_REDIRECT
  sudo ufw allow $SOCKS_PORT > $STD_REDIRECT
  
  info '[~] REQUIREMENTS INSTALLED. STARTING...'
  start
  status
  success '[+] INSTALLATION COMPLETE'
}

if [ "$#" -ne 1 ]; then 
  usage
fi

case $1 in 
  start)
    info '[~] STARTING...'
    start
    status
    ;;
  stop)
    info '[~] STOPPING...'
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