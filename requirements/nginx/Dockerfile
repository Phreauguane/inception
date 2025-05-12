FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    nginx \
    vim \
    curl \
    openssl \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /etc/nginx/ssl \
    && mkdir -p /var/run/nginx \
    && mkdir -p /var/www/html \
    && chmod -R 755 /var/www/html \
    && chown -R www-data:www-data /var/www/html

COPY nginx.conf /etc/nginx/nginx.config

COPY index.html /var/www/html/

ARG DOMAIN_NAME
ENV DOMAIN_NAME=${DOMAIN_NAME}

RUN openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/inception.key \
    -out /etc/nginx/ssl/inception.crt \
    -subj "/CN=jde-meo.42.fr" \
    -addext "subjectAltName = DNS:jde-meo.42.fr,DNS:localhost"

RUN cat /etc/nginx/ssl/inception*

RUN chmod 600 /etc/nginx/ssl/inception.key \
    && chmod 644 /etc/nginx/ssl/inception.crt \
    && chmod 644 /var/www/html/index.html

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]