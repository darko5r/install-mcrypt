#!/usr/bin/env bash

PHP=$(command -v php)
GREP=$(command -v grep)

# Fixup PHP and GREP as needed. It may be needed on AIX, BSDs, and Solaris
if [[ -f "/usr/gnu/bin/grep" ]]; then
    GREP="/usr/gnu/bin/grep"
elif [[ -f "/usr/linux/bin/grep" ]]; then
    GREP="/usr/linux/bin/grep"
elif [[ -f "/usr/xpg4/bin/grep" ]]; then
    GREP="/usr/xpg4/bin/grep"
fi

# Check if /etc/php/conf.d/mcrypt.ini exists
if [ -f "/etc/php/conf.d/mcrypt.ini" ]; then
  # Ask to delete /etc/php/conf.d/mcrypt.ini
  read -p "/etc/php/conf.d/mcrypt.ini exists. Do you want to delete it? [y/n] " answer
  if [ "$answer" == "y" ]; then
    # Delete /etc/php/conf.d/mcrypt.ini
    rm -f "/etc/php/conf.d/mcrypt.ini"
  fi
fi

# Check if mcrypt.so is installed in /usr/lib/php/modules
if [ ! -f "/usr/lib/php/modules/mcrypt.so" ]; then
  # Install mcrypt.so with yaourt
  yaourt -S php-mcrypt
else
  # Check PHP version
  PHP_MAJOR_VERSION=$("$PHP" -r 'echo PHP_MAJOR_VERSION;')
  PHP_MINOR_VERSION=$("$PHP" -r 'echo PHP_MINOR_VERSION;')
  PHP_VERSION="$PHP_MAJOR_VERSION.$PHP_MINOR_VERSION"

  # Check mcrypt.so version
  INSTALLED_MCRYPT_VERSION=$("$PHP" -r 'echo phpversion("mcrypt");')

  # Check if mcrypt.so is old or incompatible with the installed PHP
  if [ "$INSTALLED_MCRYPT_VERSION" != "$PHP_VERSION" ]; then
    # Ask if the user wants to remove the old version of mcrypt.so
    read -p "An old or incompatible version of mcrypt.so is already installed. Do you want to remove it and install the newest version? [y/n] " answer
    if [ "$answer" == "y" ]; then
      # Remove the old version of mcrypt.so with yaourt
      yaourt -Rns php-mcrypt

      # Install the latest version of mcrypt.so
      yaourt -S php-mcrypt
    else
      read -p "The installed version of mcrypt.so is already the newest possible and compatible with the installed PHP. Do you want to continue with the installation? [y/n] " answer
      if [ "$answer" != "y" ]; then
        exit 0
      fi
    fi
  fi
# Check if mcrypt.so is enabled in /etc/php/php.ini
  if grep -q "extension=mcrypt.so" "/etc/php/php.ini"; then
    # Remove the line from /etc/php/php.ini
    sed -i '/extension=mcrypt.so/d' "/etc/php/php.ini"
  fi

  # Ask if the user wants to enable mcrypt.so in /etc/php/php.ini
  read -p "Do you want to enable mcrypt.so in /etc/php/php.ini? [y/n] " answer
  if [ "$answer" == "y" ]; then
    # Enable mcrypt.so in /etc/php/php.ini
    line=$(grep -n "extension=ldap.so" "/etc/php/php.ini" | awk -F ":" '{print $1}')
    sed -i "$((line+1))i extension=mcrypt.so" "/etc/php/php.ini"
  fi
fi

# Print message that mcrypt.so is installed and enabled for the newest version of PHP
echo "mcrypt.so is now installed and enabled for the newest version of PHP."

# Check if /etc/php/conf.d/mcrypt.ini exists
if [ -f "/etc/php/conf.d/mcrypt.ini" ]; then
  # Ask to delete /etc/php/conf.d/mcrypt.ini
  read -p "/etc/php/conf.d/mcrypt.ini exists. Do you want to delete it? [y/n] " answer
  if [ "$answer" == "y" ]; then
    # Delete /etc/php/conf.d/mcrypt.ini
    rm -f "/etc/php/conf.d/mcrypt.ini"
  fi
fi

# Ask if the user is ready to restart httpd and php-fpm
read -p "Are you ready to restart httpd and php-fpm? [y/n] " answer
if [ "$answer" == "y" ]; then
  # Restart httpd and php-fpm
  systemctl restart httpd
  systemctl restart php-fpm
fi
