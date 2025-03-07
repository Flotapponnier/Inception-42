#!/bin/sh

echo "----- Setting MariaDB -----"

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

# Start the DB if it doesn’t exist
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing database..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

mysqld_safe --port=3306 --bind-address=0.0.0.0 --datadir='/var/lib/mysql' &

echo "Waiting for MariaDB to start..."
until mariadb -u root -e "SELECT 1" 2>/dev/null; do
    sleep 2
    echo "Still waiting..."
done

mariadb -u root -e "
	CREATE DATABASE IF NOT EXISTS $MY_DB;
	CREATE USER IF NOT EXISTS '$MY_USER'@'%' IDENTIFIED BY '$MY_USER_PASS';
	GRANT ALL PRIVILEGES ON $MY_DB.* TO '$MY_USER'@'%';
	FLUSH PRIVILEGES;
	"

mariadb -u root -p -e "SHOW DATABASES;"

wait
