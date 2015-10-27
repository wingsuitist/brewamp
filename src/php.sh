if (brew services list|grep php55); then
  tell "The interpeter of the languages of languages from the P to the H to the P is installed"
else

  # kill some time
  (sleep 5; tell "Hey barman! Where is my beer?")&

  # install php
  tell "Lets install the interpeter of the languages of languages from the P to the H to the P"
  brew install -v homebrew/php/php55

  # configure php.ini
  tell "Change the settings of php so it's letting us having fun by using all memory"
  sed -i '-default' -e 's|^;\(date\.timezone[[:space:]]*=\).*|\1 \"'$(sudo systemsetup -gettimezone|awk -F"\: " '{print $2}')'\"|; s|^\(memory_limit[[:space:]]*=\).*|\1 512M|; s|^\(post_max_size[[:space:]]*=\).*|\1 200M|; s|^\(upload_max_filesize[[:space:]]*=\).*|\1 100M|; s|^\(default_socket_timeout[[:space:]]*=\).*|\1 600|; s|^\(max_execution_time[[:space:]]*=\).*|\1 300|; s|^\(max_input_time[[:space:]]*=\).*|\1 600|; $a\'$'\n''\'$'\n''; PHP Error log\'$'\n''error_log = /LocalSites/logs/php-error_log'$'\n' $(brew --prefix)/etc/php/5.5/php.ini

  # fix some permission problems
  chmod -R ug+w $(brew --prefix php55)/lib/php

  # let's get some speed
  tell "Give the magic potion of op cache to php"
  brew install -v php55-opcache

  # enable it
  /usr/bin/sed -i '' "s|^\(\;\)\{0,1\}[[:space:]]*\(opcache\.enable[[:space:]]*=[[:space:]]*\)0|\21|; s|^;\(opcache\.memory_consumption[[:space:]]*=[[:space:]]*\)[0-9]*|\1256|;" $(brew --prefix)/etc/php/5.5/php.ini

  # start php55
  tell "Now let's start the P H Party"
  brew services start php55
fi

tell "get the wisdom of the php info"
if [ -e /LocalSites/phpinfo/phpinfo.php ]; then
  tell "already here"
else
  mkdir /LocalSites/phpinfo
  echo "<?php phpinfo() ?>" >> /LocalSites/phpinfo/phpinfo.php
fi

if [ -e $(brew --prefix)/etc/php/5.5/conf.d/ext-xdebug.ini]; then
    tell "xdebug is already giving you the wisdom of debugging"
else
    tell "let's get the wisdom of debugging"
    brew install php55-xdebug
    cat >> $(brew --prefix)/etc/php/5.5/conf.d/ext-xdebug.ini <<EOF
xdebug.remote_enable=on
xdebug.remote_log="/var/log/xdebug.log"
xdebug.remote_host=localhost
xdebug.remote_handler=dbgp
xdebug.remote_port=9001
EOF

fi

brew services stop httpd22
brew services start httpd22

open "http://phpinfo.dev:8080/phpinfo.php" &
