#!/usr/bin/env bash

# Check if mcrypt.so is installed in /usr/lib/php/modules
if [ -f "/usr/lib/php/modules/mcrypt.so" ]; then

  # Split mcrypt.so version into main, minor, patch, and build numbers
  mcrypt_version=$(php -i 2>/dev/null | grep "mcrypt support" | grep -oP '\d+\.\d+\.\d+\.\d+')
  mcrypt_main=$(echo "$mcrypt_version" | cut -d'.' -f1)
  mcrypt_minor=$(echo "$mcrypt_version" | cut -d'.' -f2)
  mcrypt_patch=$(echo "$mcrypt_version" | cut -d'.' -f3)
  mcrypt_build=$(echo "$mcrypt_version" | cut -d'.' -f4)

  # Split PHP version into main, minor, patch, and build numbers
  php_version=$(php -i 2>/dev/null | grep "PHP Version" | grep -oP '\d+\.\d+\.\d+\.\d+') 2>/dev/null
  php_main=$(echo "$php_version" | cut -d'.' -f1) 
  php_minor=$(echo "$php_version" | cut -d'.' -f2) 
  php_patch=$(echo "$php_version" | cut -d'.' -f3) 
  php_build=$(echo "$php_version" | cut -d'.' -f4)

  # Check if mcrypt.so is old or incompatible with the installed PHP
  if [[ $mcrypt_main -lt $php_main ]] || [[ $mcrypt_main -gt $php_main ]]; then
    # Ask if the user wants to remove the old version of mcrypt.so
    read -p "An old or incompatible version of mcrypt.so is already installed. Do you want to remove it and install the latest version? [y/n] " answer
    if [ "$answer" == "y" ]; then
      # Remove the old version of mcrypt.so
      yaourt -Rns php-mcrypt
      # Install the latest version of mcrypt.so
      yaourt -S php-mcrypt
    fi
  else
    echo "The installed version of mcrypt.so is up to date."
    exit 0
  fi
else
  # Install the latest version of mcrypt.so
  read -p "Do you want to install the latest version of mcrypt? [y/n] " answer
    if [ "$answer" == "y" ]; then
  yaourt -S php-mcrypt
fi

# Check if the mcrypt.so extension is enabled in /etc/php/conf.d/mcrypt.ini
if [ -f "/etc/php/conf.d/mcrypt.ini" ]; then
  # Disable the mcrypt.so extension in /etc/php/conf.d/mcrypt.ini
  sed -i 's/^extension=mcrypt.so/;extension=mcrypt.so/' /etc/php/conf.d/mcrypt.ini
else

# Ask if the user wants to delete the /etc/php/conf.d/mcrypt.ini file
read -p "The /etc/php/conf.d/mcrypt.ini file does not exist. Do you want to delete it? [y/n] " answer
if [ "$answer" == "y" ]; then
  # Delete the /etc/php/conf.d/mcrypt.ini file
  rm -f /etc/php/conf.d/mcrypt.ini 2>/dev/null
fi

# Check if /etc/php/php.ini contains the extension=mcrypt.so line
if grep -q "^extension=mcrypt.so" /etc/php/php.ini; then
  # Remove the extension=mcrypt.so line from /etc/php/php.ini
  sed -i '/^extension=mcrypt.so/d' /etc/php/php.ini
fi

# Add the extension=mcrypt.so line to /etc/php/php.ini
sed -i '/^extension=ldap.so/a extension=mcrypt.so' /etc/php/php.ini

# Ask if the user is ready to restart httpd and php-fpm
read -p "mcrypt.so is now installed and enabled. Are you ready to restart httpd and php-fpm? [y/n] " answer
if [ "$answer" == "y" ]; then
  # Restart httpd
  systemctl restart httpd
  # Restart php-fpm
  systemctl restart php-fpm
fi
fi
fi
