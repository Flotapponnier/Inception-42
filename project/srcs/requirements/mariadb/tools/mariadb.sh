#!/bin/bash

# Check if the database is already initialized
if [ ! -d "/var/lib/mysql/mysql" ]; then
  echo "Initializing MariaDB data directory..."
  mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Make sure mysql can access its directories
chown -R mysql:mysql /var/lib/mysql
chown -R mysql:mysql /run/mysqld

# Start MariaDB server directly (no service)
echo "Starting MariaDB server..."
mysqld_safe --datadir=/var/lib/mysql &

# Wait for MariaDB to become available
echo "Waiting for MariaDB to start..."
until mysqladmin ping -h localhost --silent; do
  echo "Waiting for MariaDB to be ready..."
  sleep 2
done

echo "MariaDB started successfully!"

# Check if the database exists - if not, initialize it
DB_EXISTS=$(mysql -u root -e "SHOW DATABASES LIKE '${MYSQL_DATABASE}';" | grep "${MYSQL_DATABASE}")
if [ -z "$DB_EXISTS" ]; then
  echo "Initializing database ${MYSQL_DATABASE}..."
  mysql -u root << EOF
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF
  echo "Database initialization completed!"
else
  echo "Database ${MYSQL_DATABASE} already exists!"
fi

# Keep mysqld_safe running in the foreground
echo "MariaDB setup complete, keeping server running..."
wait %1
