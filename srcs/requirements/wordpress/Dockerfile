FROM debian:bullseye

RUN apt update -y && apt upgrade -y && apt install -y \
    php7.4-fpm \
    php7.4-mysqli \
    curl \
    wget \
    mariadb-client \
    && mkdir -p /run/php

WORKDIR /var/www

RUN wget https://fr.wordpress.org/wordpress-6.0-fr_FR.tar.gz && \
    tar -xzf wordpress-6.0-fr_FR.tar.gz && \
    rm wordpress-6.0-fr_FR.tar.gz && \
    chown -R www-data:www-data /var/www/wordpress
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

COPY www.conf /etc/php/7.4/fpm/pool.d/.
COPY config.sh .

RUN chmod +x config.sh

EXPOSE 9000

CMD ["./config.sh"]