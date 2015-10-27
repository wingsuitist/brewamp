#!/bin/bash

function tell() {
  echo $1
  declare -a voices=('Vick' 'Victoria' 'Bruce' 'Agnes')
  RANDOM=$$$(date +%s)
  voice=${voices[$RANDOM % ${#voices[@]} ]}
  say -v $voice $1
}

# install brew services
brew tap homebrew/services

# installing mysql
if [ -e $(brew --prefix)/etc/my.cnf ]; then
  tell "The Deamon of MySQL is installed - you may summon it by brew services"
else
  brew install -v mysql

  cp -v $(brew --prefix mysql)/support-files/my-default.cnf $(brew --prefix)/etc/my.cnf

  cat >> $(brew --prefix)/etc/my.cnf <<'EOF'

# custom settings brewamp
max_allowed_packet = 1073741824
innodb_file_per_table = 1
EOF

  tell "remove bad STRICT_TRANS_TABLES definition from: " $(brew --prefix)/etc/my.cnf
  sed -i '' -e 's/,STRICT_TRANS_TABLES//g' $(brew --prefix)/etc/my.cnf

  tell "Uncomment the sample option for innodb_buffer_pool_size to improve performance: " $(brew --prefix)/etc/my.cnf
  sed -i '' 's/^#[[:space:]]*\(innodb_buffer_pool_size\)/\1/' $(brew --prefix)/etc/my.cnf

  tell "I am praying to the holy DB angels to get the magic wand"

  tell "!! We will now summon the Deamon of MySQL and make you set the root password:"
  brew services start mysql
  $(brew --prefix mysql)/bin/mysql_secure_installation
fi
