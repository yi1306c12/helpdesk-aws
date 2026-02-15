FROM php:8.4-fpm

WORKDIR /var/www/html
COPY . .

RUN apt-get update && apt-get install -y --no-install-recommends \
    libicu-dev libzip-dev libpq-dev git openssh-client\
    && docker-php-ext-install intl opcache pdo_pgsql zip \
    && rm -rf /var/lib/apt/lists/*

COPY --from=composer:2.9.5 /usr/bin/composer /usr/bin/composer
RUN composer install

USER www-data
EXPOSE 9000
CMD ["php-fpm", "-F"]
