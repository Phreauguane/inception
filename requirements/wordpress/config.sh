#!/bin/bash
set -e

echo "Starting configuration script..."

echo "Waiting for database connection..."
until mysql -h"mariadb" -u"$SQL_USER" -p"$SQL_PASSWORD" -e "USE $SQL_DATABASE;" &>/dev/null; do
    echo "Waiting for database to be ready..."
    sleep 2
done
echo "Database connection established!"

cd /var/www/wordpress
if [ ! -f wp-config.php ]; then
    echo "Creating wp-config.php..."
    wp config create \
        --allow-root \
        --dbname=$SQL_DATABASE \
        --dbuser=$SQL_USER \
        --dbpass=$SQL_PASSWORD \
        --dbhost=mariadb \
        --path='/var/www/wordpress' \
        --skip-check \
        --force
    
    echo "Installing WordPress..."
    wp core install \
        --allow-root \
        --url=$DOMAIN_NAME \
        --title='Inception Wordpress' \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL \
        --path='/var/www/wordpress' \
        --skip-email || true
    
    echo "Creating additional user..."
    wp user create \
        --allow-root \
        $WP_USER \
        $WP_EMAIL \
        --role=author \
        --user_pass=$WP_PASSWORD \
        --path=/var/www/wordpress || true
fi

echo "Checking PHP-FPM configuration..."
grep -q "listen = 0.0.0.0:9000" /etc/php/7.4/fpm/pool.d/www.conf || {
    echo "PHP-FPM not configured to listen on all interfaces. Fixing it..."
    sed -i 's/listen = .*/listen = 0.0.0.0:9000/' /etc/php/7.4/fpm/pool.d/www.conf
}

mkdir -p /run/php

echo "Starting PHP-FPM..."
echo "PHP-FPM version:"
php-fpm7.4 -v

exec php-fpm7.4 -F