#!/bin/bash
cd /var/www/html

# Download WP-CLI
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar

# Download WordPress core files
./wp-cli.phar core download --allow-root

# Create wp-config.php file
./wp-cli.phar config create --dbname=wordpress --dbuser=florent --dbpass=florent --dbhost=mariadb --allow-root

# Install WordPress with a secure admin username (not containing 'admin')
./wp-cli.phar core install --url=ftapponn.42.fr --title="WordPress Site" --admin_user=ftapponn --admin_password=ftapponn --admin_email=florent.tappo@hotmail.fr --allow-root

# Create a second regular user
./wp-cli.phar user create ftapponn2 ftapponn2@hotmail.fr --role=editor --user_pass=ftapponn --allow-root

# Verify users were created
echo "Verifying users..."
./wp-cli.phar user list --allow-root

# Start PHP-FPM
php-fpm8.2 -F
