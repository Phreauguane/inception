FROM debian:bullseye

RUN apt update -y && apt upgrade -y && apt install -y \
    mariadb-server \
    mariadb-client \
    vim \
    curl \
    procps \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /var/run/mysqld \
    && chown -R mysql:mysql /var/run/mysqld \
    && chmod 777 /var/run/mysqld \
    && chown -R mysql:mysql /var/lib/mysql \
    && chmod 777 /var/lib/mysql


COPY 50-server.cnf /etc/mysql/mariadb.conf.d/.
COPY init.sh .

RUN sed -i "s/bind-address*/bind-address = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf \
    && chmod +x init.sh

EXPOSE 3306

CMD ["sh", "-c", "./init.sh"]