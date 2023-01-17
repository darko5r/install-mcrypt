#!/usr/bin/bash
# install-mcrypt
# This script provides a way to manage the installation and configuration of the mcrypt.so extension for PHP on a system running Arch Linux. It checks if the mcrypt.so file is installed and if it is compatible with the installed version of PHP, and prompts the user to remove the old version and install the latest version if necessary. It also manages the configuration of the mcrypt.so extension in the /etc/php/php.ini file and the /etc/php/conf.d/mcrypt.ini file, and restarts the Apache web server to apply the changes.
# 31-01-2022 / Fixed comparing of mcrypt and php versions so the script only compares the main version numbers and not the rest of the numbers. 
# 31-01-2022 / Version 5.0
