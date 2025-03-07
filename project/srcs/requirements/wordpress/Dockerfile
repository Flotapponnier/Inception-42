FROM debian:latest

RUN apt-get -y update && apt-get upgrade -y
RUN apt-get install -y mariadb-client

RUN apt-cache search php-fpm

RUN apt install -y \ 
curl \
php \
php-fpm \
php-json \
php-mysql \
php-curl \
php-dom \
php-exif \
php-fileinfo \
php-igbinary \
php-imagick \
php-intl \
php-mbstring \
php-xml \
php-zip

RUN dpkg -l | grep php

COPY ./conf/wordpress-script.sh /wordpress-script.sh
RUN chmod +x /wordpress-script.sh

ENTRYPOINT ["./wordpress-script.sh"]
