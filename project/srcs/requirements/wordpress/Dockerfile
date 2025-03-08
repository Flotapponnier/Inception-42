FROM debian:latest
# Update packages and install dependencies
RUN apt update -y && apt upgrade -y && \
    apt install -y curl php8.2 php8.2-fpm php8.2-mysql mariadb-client netcat-openbsd && \
    apt clean && rm -rf /var/lib/apt/lists/*
# Copy configuration files for PHP-FPM
COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
# Copy the WordPress setup script and make it executable
COPY tools/wordpress.sh /usr/local/bin/wordpress.sh
RUN chmod +x /usr/local/bin/wordpress.sh
# Run the WordPress script as the container's default command
CMD ["/usr/local/bin/wordpress.sh"]
