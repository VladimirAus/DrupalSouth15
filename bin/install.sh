#!/bin/bash

# General params
# readonly DVER="8.0.0-beta7"
# readonly DVER="8.0.x-dev"
readonly SITENAME="ds15.drupal8.loc" 
readonly DBNAME="ds15_drupal8_loc"

# MySQL credentials
DBSERVER="127.0.0.1"
DBLOGIN="root"
DBPSWD="root"

# Drupal credentials
DRUPLOGIN="d8admin"
DRUPPSWD="password"
DBCONN="mysql://$DBLOGIN:$DBPSWD@$DBSERVER/$DBNAME"

readonly LMSCONFIG="druaplsouth.d8b7.config"

# Download Drupal
# drush dl drupal-8.0.x # install latest Drupal
sudo rm -rf docroot
# mv drupal-$DVER docroot
drush make config/druaplsouth.d8.make docroot --yes
cd docroot
# sudo chmod -R 777 sites/default/files

# drush sql-create --db-url="$DBCONN" --yes
drush si minimal --db-url="$DBCONN" --account-name=$DRUPLOGIN --account-pass=$DRUPPSWD --yes
drush en bartik -y
drush pm-uninstall stark --yes
sudo chmod 755 sites/default/settings.php

# cp -r ../config/$LMSCONFIG sites/default/files
# mv sites/default/files/$LMSCONFIG sites/default/files/config_$LMSCONFIG
# chmod -r 775 sites/default/files/config_$LMSCONFIG
# echo "\$config_directories['$LMSCONFIG'] = 'sites/default/files/config_$LMSCONFIG';" >> sites/default/settings.php
SITEUUID="uuid: $(drush7 config-get system.site uuid --format=string)"

drush config-export staging -y
cd sites/default/files/
CONFIGDIR="$(ls -d c* | head -1)"
cd ../../../../config/$LMSCONFIG
cp -Rf . ../../docroot/sites/default/files/$CONFIGDIR/staging/

# Following commands do not work in core beta6 and earlier
# Comment all commands and proceed to instaructons

# replace import UUID with site UUID
cd ../..
sed -i.bak "1s/.*/$SITEUUID/" docroot/sites/default/files/$CONFIGDIR/staging/system.site.yml

cd docroot/

# Copy module
cp -Rf ../modules/* modules/

drush en config -y
drush config-import staging -y

# name is not set via config at the moment
# drush config-set system.site name 'Project Lantern' -y

