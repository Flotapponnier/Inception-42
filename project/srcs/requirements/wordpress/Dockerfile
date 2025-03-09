FROM debian:latest

RUN apt update -y && apt upgrade -y && \
    apt install -y curl php8.2 php8.2-fpm php8.2-mysql mariadb-client netcat-openbsd && \
    apt clean && rm -rf /var/lib/apt/lists/*

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY tools/wordpress.sh /usr/local/bin/wordpress.sh

RUN chmod +x /usr/local/bin/wordpress.sh

CMD ["/usr/local/bin/wordpress.sh"]
