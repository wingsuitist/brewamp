if (grep adminer ); then
  tell "adminer seams to be there so let's celebrate and use it"
else
  tell "install the database interface cause someone is maybe to lazy for the commandline"
  brew install adminer  --with-brewed-httpd22

  # add it to our config
  cat >> /LocalSites/httpd-vhosts.conf <<EOF
  
  Alias /adminer /usr/local/share/adminer
 <Directory "/usr/local/share/adminer/">
   Options None
   AllowOverride None
   <IfModule mod_authz_core.c>
     Require all granted
   </IfModule>
   <IfModule !mod_authz_core.c>
     Order allow,deny
     Allow from all
   </IfModule>
 </Directory>
EOF

  brew services stop httpd22
  brew services start httpd22
fi

open "http://localhost:8080/adminer/" &
