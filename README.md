# BrewAMP - another way to get a nice Apache PHP MySQL OSX environment

To get a easy to install local development environment with Homebrew.

## !! Atention

* this script will mess up any existing brew apache installation
* a globaly accessible /LocalSites/ folder will be created
* configuration files will be changed automatically

## How to use

Run the script on your Terminal:

````bash
 bash install.sh
````

It will install brew, apache, dnsmasq, mysql, php, fastcgi, adminer, xdebug and other helpful things.

Run multiple sites in /LocalSites/xyz and open them in your browser http://xyz.dev:8080/.

## credits

Initial version by Jonas Felix - Follow to get more OpenSource: https://twitter.com/wingsuitist

The basic workflow of the installation is based on the great tutorial from Alan: https://twitter.com/alanthing
https://echo.co/blog/os-x-1010-yosemite-local-development-environment-apache-php-and-mysql-homebrew


## debugging

### brew error messages

````bash
brew doctor
````

### apache not running

````bash
httpd --DEFOREGROUND
````
