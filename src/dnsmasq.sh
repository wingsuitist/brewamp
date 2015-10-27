if (brew services list|grep dnsmasq); then
  tell "DNS Masq guids us to the right IP which is 127.0.0.1 - but it's already here"
else
  tell "DNS Masq guids us to the right IP which is 127.0.0.1 - so lets summon this last deamon"

  brew install -v dnsmasq
  echo 'address=/.dev/127.0.0.1' > $(brew --prefix)/etc/dnsmasq.conf
  echo 'listen-address=127.0.0.1' >> $(brew --prefix)/etc/dnsmasq.conf
  echo 'port=35353' >> $(brew --prefix)/etc/dnsmasq.conf
  brew services start dnsmasq
fi

if [ -e /etc/resolver/dev ]; then
  tell "DNS Masq is already in our resolver list"
else
  tell "So let's call DNS Masq all the time - cause, yes - it's nice"
  sudo mkdir -v /etc/resolver
  sudo bash -c 'echo "nameserver 127.0.0.1" > /etc/resolver/dev'
  sudo bash -c 'echo "port 35353" >> /etc/resolver/dev'
fi
