#!/bin/sh

echo "--- Wordpress Script ---"
php -v

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

echo "--- Setting up WP ---"

cd /var/www/html

wp core download --allow-root

wp core config  --allow-root \
                --dbname=$MY_DB \
                --dbuser=$MY_USER \
                --dbpass=$MY_USER_PASS \
                --dbhost=mariadb:3306

wp core install --allow-root \
                --skip-email \
                --title='INCEPTION' \
                --url=$WP_URL \
                --admin_user=$WP_ADMIN_USER \
                --admin_email=$WP_ADMIN_EMAIL \
                --admin_password=$WP_ADMIN_PASS \
                

wp user create --allow-root \
               $WP_USER_NAME \
               $WP_USER_EMAIL \
			   --user_pass=$WP_USER_PASS

# Fix permissions to prevent 403 Forbidden
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# listen port to 9000
sed -i 's|listen = /run/php/php8.2-fpm.sock|listen = 0.0.0.0:9000|' /etc/php/8.2/fpm/pool.d/www.conf

echo "🚀 WordPress container is running..."
/usr/sbin/php-fpm8.2 -F
