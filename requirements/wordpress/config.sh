#!/bin/bash

until mysql -h"mariadb" -u"$SQL_USER" -p"$SQL_PASSWORD" -e "USE $SQL_DATABASE;" &>/dev/null; do
  echo "Waiting for database to be ready..."
  sleep 2
done

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

  echo "installing WordPress..."
  wp core install \
    --allow-root \
    --url=$WP_URL \
    --title='Inception Wordpress' \
    --admin_user=$WP_ADMIN_USER \
    --admin_password=$WP_ADMIN_PASSWORD \
    --admin_email=$WP_ADMIN_EMAIL \
    --path='/var/www/wordpress' \
    --skip-email || true

  echo "Creating user..."
  wp user create \
    --allow-root \
    $WP_USER \
    $WP_EMAIL \
    --role=author \
    --user_pass=$WP_PASSWORD \
    --path=/var/www/wordpress || true
fi

echo "Starting PHP-FPM..."
php-fpm7.4 -F