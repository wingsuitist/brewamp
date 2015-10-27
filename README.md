# BrewAMP - another way to get a nice Apache PHP MySQL OSX environment

This script installs Apache, MySQL, PHP and Adminer they way I like it the most.

## !! Atention

* this script will mess up any existing brew apache installation
* it will maybe disable the default apache
* it installs everything in /LocalSites/ outside of your Users Folder - not every Unix Admin likes that

## How to use

More details in src/index.html

Install homebrew first - it's not working without it: http://brew.sh/

````bash
 bash install.sh
````

## credits

This took a lot from an amazing tutorial by Anlan https://twitter.com/alanthing (follow him you must)
https://echo.co/blog/os-x-1010-yosemite-local-development-environment-apache-php-and-mysql-homebrew

The first version was written by me - Follow me on Twitter to get more fun stuff: https://twitter.com/wingsuitist

## debugging

### permissions brew

If you installed brew with sudo you'll get a lot of Errors about permissions, so set back the permission:
sudo chown -R $(whoami):admin /usr/local

