#!/bin/bash

function tell() {
  echo $1
  declare -a voices=('Vick' 'Victoria' 'Bruce' 'Agnes')
  RANDOM=$$$(date +%s)
  voice=${voices[$RANDOM % ${#voices[@]} ]}
  say -r 200 -v $voice $1
}

# base dir
BASEDIR=$(dirname $0)

tell "Let's go on the journey through forests, over  \
  mountains and into the deepest caves to find the ring to controll them all"

# get homebrew services repositories
brew tap homebrew/services

# include mysql installation
source $BASEDIR/src/mysql.sh
source $BASEDIR/src/httpd.sh
source $BASEDIR/src/dnsmasq.sh
source $BASEDIR/src/php.sh
source $BASEDIR/src/adminer.sh

exit;
