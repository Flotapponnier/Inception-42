#!/bin/bash
mkdir -p /var/www/wordpress
cd /var/www/wordpress

# Install wp-cli if not already installed
if [ ! -f /usr/local/bin/wp ]; then
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

# Wait for MariaDB to be ready
echo "Waiting for MariaDB to be ready..."
while ! nc -z mariadb 3306; do
    echo "MariaDB is not available yet - waiting..."
    sleep 3
done
echo "MariaDB is up and running!"

# Download WordPress if not already present
if [ ! -f wp-config.php ]; then
    echo "Downloading WordPress..."
    wp core download --allow-root
    echo "Configuring wp-config.php..."
    cp wp-config-sample.php wp-config.php
    sed -i "s/database_name_here/${MYSQL_DATABASE}/" wp-config.php
    sed -i "s/username_here/${MYSQL_USER}/" wp-config.php
    sed -i "s/password_here/${MYSQL_PASSWORD}/" wp-config.php
    sed -i "s/localhost/mariadb/" wp-config.php
    
    # Fix HTTP_HOST issue by defining WP_HOME and WP_SITEURL
    echo "define('WP_HOME', 'http://${DOMAIN_NAME}');" >> wp-config.php
    echo "define('WP_SITEURL', 'http://${DOMAIN_NAME}');" >> wp-config.php
    
    # Optional: Add this to allow WordPress to work behind a proxy if needed
    echo "if ( isset( \$_SERVER['HTTP_X_FORWARDED_PROTO'] ) && \$_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https' ) { \$_SERVER['HTTPS'] = 'on'; }" >> wp-config.php
fi

# Test database connection explicitly
echo "Testing database connection..."
if mysql -h mariadb -u ${MYSQL_USER} -p${MYSQL_PASSWORD} -e "USE ${MYSQL_DATABASE}"; then
    echo "Database connection successful!"
else
    echo "ERROR: Could not connect to database. Please check credentials."
    echo "Host: mariadb"
    echo "User: ${MYSQL_USER}"
    echo "Database: ${MYSQL_DATABASE}"
    echo "The WordPress setup will continue, but may fail if the database issue isn't resolved."
fi

# Install WordPress if not already installed
if ! wp core is-installed --allow-root; then
    echo "Installing WordPress..."
    if [[ "${WP_ADMIN_USER}" =~ [Aa]dmin|[Aa]dministrator ]]; then
        echo "Error: Administrator username cannot contain 'admin', 'Admin', or 'administrator' ..."
        exit 1
    fi
    wp core install \
        --url="${DOMAIN_NAME}" \
        --title="${SITE_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --skip-email \
        --allow-root
    
    wp user create \
        "${WP_USER}" "${WP_USER_EMAIL}" \
        --user_pass="${WP_USER_PASSWORD}" \
        --role=editor \
        --allow-root
    
    echo "WordPress installation complete!"
else
    echo "WordPress is already installed."
fi

# Theme setup - using Twenty Twenty-Two which is a more modern theme
if ! wp theme is-installed twentytwentytwo --allow-root; then
    wp theme install twentytwentytwo --activate --allow-root
else
    wp theme activate twentytwentytwo --allow-root
fi

# Create homepage with custom content
wp post update 1 --post_title="Inception-42" --post_content="<h1>Inception-42 project by Florent Tapponnier</h1><p>Welcome to my Inception project for 42 school.</p>" --allow-root

# Set homepage to display this static page
wp option update show_on_front page --allow-root
wp option update page_on_front 1 --allow-root

# Make sure the www-data user has proper permissions
mkdir -p /run/php
chown -R www-data:www-data /var/www/wordpress
chown -R www-data:www-data /run/php

echo "Starting PHP-FPM..."
# Use exec to replace the shell process with PHP-FPM
exec php-fpm8.2 -F
