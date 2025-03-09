FROM debian:buster

RUN apt update -y && apt upgrade -y && \
    apt install -y curl php7.3 php7.3-fpm php7.3-mysql mariadb-client netcat-openbsd && \
    apt clean && rm -rf /var/lib/apt/lists/*

COPY conf/www.conf /etc/php/7.3/fpm/pool.d/www.conf
COPY tools/wordpress.sh /usr/local/bin/wordpress.sh
RUN chmod +x /usr/local/bin/wordpress.sh

CMD ["/usr/local/bin/wordpress.sh"]
