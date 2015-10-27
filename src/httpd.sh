if (brew services list|grep httpd); then
  tell "Apache is installed"
else
  tell "Going to install a best friend of Winnetou"

  # deactivate sox Apache
  sudo launchctl unload /System/Library/LaunchDaemons/org.apache.httpd.plist 2>/dev/null

  # get the external repository dupes
  brew tap homebrew/dupes

  # let's kill some time
  (sleep 5; tell "The brewery is slow today please give it a little time.")&

  # install apache 2.2
  brew install -v homebrew/apache/httpd22 --with-brewed-openssl --with-mpm-event
fi

# install fastcgi
tell "now let's open the door for the indian to connect with the heavens of script interpreters"
brew install -v homebrew/apache/mod_fastcgi --with-brewed-httpd22

# creat /LocalSites folders
if [ -d /LocalSites ]; then
  tell "The local sites folder is available"
else
  tell "Going to crreate Slash Local Sits in your root folder, the new home for your dreams"
  sudo mkdir /LocalSites
  sudo chgrp admin /LocalSites
  sudo chmod g+rwx /LocalSites
  mkdir -pv /LocalSites/{logs,ssl}
fi

  # if our new apache snipped is not yet in the config, we have to remove the defualt fastcgi
if (grep brewamp $(brew --prefix)/etc/apache2/2.2/httpd.conf); then
  tell "the brew is already in your amp"
else
  tell "some custom configuration we must do my friend"

  sed -i '' '/fastcgi_module/d' $(brew --prefix)/etc/apache2/2.2/httpd.conf

  export MODFASTCGIPREFIX=$(brew --prefix mod_fastcgi)
  cat >> $(brew --prefix)/etc/apache2/2.2/httpd.conf <<EOF

# custom settings brewamp

# Load PHP-FPM via mod_fastcgi
LoadModule fastcgi_module    ${MODFASTCGIPREFIX}/libexec/mod_fastcgi.so

<IfModule fastcgi_module>
FastCgiConfig -maxClassProcesses 1 -idle-timeout 1500

# Prevent accessing FastCGI alias paths directly
<LocationMatch "^/fastcgi">
  <IfModule mod_authz_core.c>
    Require env REDIRECT_STATUS
  </IfModule>
  <IfModule !mod_authz_core.c>
    Order Deny,Allow
    Deny from All
    Allow from env=REDIRECT_STATUS
  </IfModule>
</LocationMatch>

FastCgiExternalServer /php-fpm -host 127.0.0.1:9000 -pass-header Authorization -idle-timeout 1500
ScriptAlias /fastcgiphp /php-fpm
Action php-fastcgi /fastcgiphp

# Send PHP extensions to PHP-FPM
AddHandler php-fastcgi .php

# PHP options
AddType text/html .php
AddType application/x-httpd-php .php
DirectoryIndex index.php index.html
</IfModule>

# Include our VirtualHosts
Include /LocalSites/httpd-vhosts.conf
EOF

fi

## create custom configuration
if [ -e /LocalSites/httpd-vhosts.conf ]; then
  tell "The scrolls of the Apache elders are already in place"
else
  tell "Creating the local configuration for our indian tribe"
  touch /LocalSites/httpd-vhosts.conf

  cat > /LocalSites/httpd-vhosts.conf <<EOF
  #
  # Listening ports.
  #
  #Listen 8080  # defined in main httpd.conf
  Listen 8443

  #
  # Use name-based virtual hosting.
  #
  NameVirtualHost *:8080
  NameVirtualHost *:8443

  #
  # Set up permissions for VirtualHosts in ~/Sites
  #
  <Directory "/LocalSites">
      Options -Indexes FollowSymLinks MultiViews
      AllowOverride All
      <IfModule mod_authz_core.c>
          Require all granted
      </IfModule>
      <IfModule !mod_authz_core.c>
          Order allow,deny
          Allow from all
      </IfModule>
  </Directory>

  # For http://localhost in the users' Sites folder
  <VirtualHost _default_:8080>
      ServerName localhost
      DocumentRoot "/LocalSites"
  </VirtualHost>
  <VirtualHost _default_:8443>
      ServerName localhost
      Include "/LocalSites/ssl/ssl-shared-cert.inc"
      DocumentRoot "/LocalSites"
  </VirtualHost>

  #
  # VirtualHosts
  #

  ## Manual VirtualHost template for HTTP and HTTPS
  #<VirtualHost *:8080>
  #  ServerName project.dev
  #  CustomLog "/LocalSites/logs/project.dev-access_log" combined
  #  ErrorLog "/LocalSites/logs/project.dev-error_log"
  #  DocumentRoot "/LocalSites/project.dev"
  #</VirtualHost>
  #<VirtualHost *:8443>
  #  ServerName project.dev
  #  Include "/LocalSites/ssl/ssl-shared-cert.inc"
  #  CustomLog "/LocalSites/logs/project.dev-access_log" combined
  #  ErrorLog "/LocalSites/logs/project.dev-error_log"
  #  DocumentRoot "/LocalSites/project.dev"
  #</VirtualHost>

  #
  # Automatic VirtualHosts
  #
  # A directory at /LocalSites/webroot can be accessed at http://webroot.dev
  # In Drupal, uncomment the line with: RewriteBase /
  #

  # This log format will display the per-virtual-host as the first field followed by a typical log line
  LogFormat "%V %h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combinedmassvhost

  # Auto-VirtualHosts with .dev
  <VirtualHost *:8080>
    ServerName dev
    ServerAlias *.dev

    CustomLog "/LocalSites/logs/dev-access_log" combinedmassvhost
    ErrorLog "/LocalSites/logs/dev-error_log"

    VirtualDocumentRoot /LocalSites/%-2+
  </VirtualHost>
  <VirtualHost *:8443>
    ServerName dev
    ServerAlias *.dev
    Include "/LocalSites/ssl/ssl-shared-cert.inc"

    CustomLog "/LocalSites/logs/dev-access_log" combinedmassvhost
    ErrorLog "/LocalSites/logs/dev-error_log"

    VirtualDocumentRoot /LocalSites/%-2+
  </VirtualHost>
EOF
fi

if [ -e /LocalSites/ssl/ssl-shared-cert.inc ]; then
  tell "Magic encryption SSL already available."
else
  tell "Creating the secret key to hide all communication"
  cat > /LocalSites/ssl/ssl-shared-cert.inc <<EOF
  SSLEngine On
  SSLProtocol all -SSLv2 -SSLv3
  SSLCipherSuite ALL:!ADH:!EXPORT:!SSLv2:RC4+RSA:+HIGH:+MEDIUM:+LOW
  SSLCertificateFile "/LocalSites/ssl/selfsigned.crt"
  SSLCertificateKeyFile "/LocalSites/ssl/private.key"
EOF

  openssl req \
    -new \
    -newkey rsa:2048 \
    -days 3650 \
    -nodes \
    -x509 \
    -subj "/C=US/ST=State/L=City/O=Organization/OU=$(whoami)/CN=*.dev" \
    -keyout /LocalSites/ssl/private.key \
    -out /LocalSites/ssl/selfsigned.crt
fi

tell "Dear darkest of valleys o summon my Apache so the deamon of port 80 80 comes a live!"

# copy the manuall
tell "learn how to use it"
cp $BASEDIR/src/index.html /LocalSites/

brew services stop httpd22
brew services start httpd22
open "http://localhost:8080/" &
