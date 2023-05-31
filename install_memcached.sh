#!/bin/bash
#
# Memcached Installation Script for Plesk PHP Handlers
# Author: George Chatzitaskos - SmartBytes Dev
#
# This script installs the Memcached PHP extension for all PHP versions available
# in Plesk PHP Handlers. It also provides the option to create backups before making
# any changes and prompts for confirmation before performing each action.
#
# Usage: ./install_memcached.sh

backup_dir="/root/memcached_backup/$(date +%Y%m%d%H%M%S)"
mkdir -p "$backup_dir"

php_versions=(/opt/plesk/php/*/)

echo "PHP versions found:"
for php_version in "${php_versions[@]}"; do
    php_version=${php_version%/}  # Remove trailing slash
    php_version=${php_version##*/}  # Extract PHP version from path
    echo "  - $php_version"
done

for php_version in "${php_versions[@]}"; do
    php_version=${php_version%/}  # Remove trailing slash
    php_version=${php_version##*/}  # Extract PHP version from path
    
    if [[ -d "/opt/plesk/php/${php_version}" ]]; then
        echo "Installing Memcached for PHP version $php_version"
        
        read -p "Do you want to install Memcached for PHP version $php_version? (y/n): " choice
        if [[ $choice =~ ^[Yy]$ ]]; then
            echo "Installing dependencies for PHP version $php_version..."
            
            # Install dependencies
            if [[ -f /etc/redhat-release ]]; then
                yum install -y make memcached gcc libmemcached-devel zlib-devel "plesk-php${php_version}-devel"
            elif [[ -f /etc/debian_version ]]; then
                apt-get install -y memcached autoconf automake gcc libmemcached-dev libhashkit-dev pkg-config "plesk-php${php_version}-dev" zlib1g-dev make
            fi
            
            echo "Backing up PHP configuration file for PHP version $php_version..."
            # Backup PHP configuration file
            cp "/opt/plesk/php/${php_version}/etc/php.ini" "$backup_dir/php_${php_version}_backup.ini"
            
            echo "Installing Memcached PHP extension for PHP version $php_version..."
            # Install Memcached PHP extension
            /opt/plesk/php/${php_version}/bin/pecl install memcached > /dev/null 2>&1
            
            echo "Registering Memcached extension in PHP configuration for PHP version $php_version..."
            # Register extension in PHP configuration
            echo "extension=memcached.so" > /opt/plesk/php/${php_version}/etc/php.d/memcached.ini
            
            echo "Updating PHP handlers information for PHP version $php_version..."
            # Update PHP handlers information
            plesk bin php_handler --reread
            
            echo "Restarting PHP-FPM service for PHP version $php_version..."
            # Restart PHP-FPM service
            service "plesk-php${php_version}-fpm" restart
            
            echo "Memcached installed for PHP version $php_version"
        fi
    else
        echo "PHP version $php_version is not installed"
    fi
done

read -p "Do you want to restart the Apache server? (y/n): " choice
if [[ $choice =~ ^[Yy]$ ]]; then
    echo "Creating backup directory: $backup_dir"
    
    echo "Backing up Apache configuration file..."
    # Backup Apache configuration file
    cp /etc/httpd/conf/httpd.conf "$backup_dir/httpd.conf.backup"
    
    echo "Restarting Apache server..."
    # Restart Apache server
    service apache2 restart
    
    echo "Apache server restarted"
fi
