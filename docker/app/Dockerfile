# syntax=docker/dockerfile:1

# Stage 1: Build environment and Composer dependencies
FROM php:8.4-cli AS builder
WORKDIR /var/www/html

# install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    unzip \
    libpq-dev \
    libonig-dev \
    libssl-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    libicu-dev \
    libzip-dev \
    && docker-php-ext-install -j$(nproc) \
    bcmath \
    intl \
    opcache \
    pdo_pgsql \
    pgsql \
    soap \
    zip \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY composer.json composer.lock ./

# Install Composer and dependencies
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer install --optimize-autoloader --no-interaction --no-progress --prefer-dist --no-scripts


# Stage 2: Production environment
FROM php:8.4-fpm AS production
WORKDIR /var/www/html

RUN apt-get update && apt-get install -y --no-install-recommends \
    libicu-dev \
    libzip-dev \
    libpq-dev \
    libxml2-dev \
    git \
    openssh-client \
    && docker-php-ext-install -j$(nproc) \
    bcmath \
    intl \
    opcache \
    pdo_pgsql \
    pgsql \
    soap \
    zip \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && rm -rf /var/lib/apt/lists/*

COPY . .
COPY --from=builder /var/www/html/vendor ./vendor

# Ensure correct permissions
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

USER www-data
EXPOSE 9000
CMD ["php-fpm", "-F"]

