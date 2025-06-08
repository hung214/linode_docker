# See https://github.com/docker-library/php/blob/master/7.1/fpm/Dockerfile
FROM php:7.1-fpm
ARG TIMEZONE

RUN apt-get update && apt-get install -y \
    openssl \
    git \
    zip \
    unzip

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer --version


# install xdebug
# RUN pecl install xdebug
# RUN docker-php-ext-enable xdebug
# RUN echo "zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20160303/xdebug.so" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
# RUN echo "error_reporting = E_ALL" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
# RUN echo "display_startup_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
# RUN echo "display_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# # relevant to this answer
# RUN echo "xdebug.idekey=\"PHPSTORM\"" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
# RUN echo "xdebug.remote_port=9000" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
# RUN echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
# RUN echo "xdebug.remote_autostart=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
# RUN echo "xdebug.remote_host=docker.for.win.localhost" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini



# Set timezone
RUN ln -snf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && echo ${TIMEZONE} > /etc/timezone
RUN printf '[PHP]\ndate.timezone = "%s"\n', ${TIMEZONE} > /usr/local/etc/php/conf.d/tzone.ini
RUN "date"

RUN apt-get update && apt-get install -y libmcrypt-dev mariadb-client vim
RUN rm -r /var/lib/apt/lists/*
RUN pecl install mcrypt-1.0.0
RUN docker-php-ext-enable mcrypt
RUN docker-php-ext-install mysqli pdo_mysql bcmath




# redis
RUN pecl install redis-4.0.1 && docker-php-ext-enable redis
# zip
RUN apt-get update && \
    apt-get install -y --no-install-recommends libzip-dev && \
    rm -r /var/lib/apt/lists/* && \
    docker-php-ext-install -j$(nproc) zip
#gd
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/freetype2 --with-jpeg-dir=/usr/include \
    && docker-php-ext-install -j$(nproc) gd
# #mongo
# RUN apt-get install -y libmongoc-dev
# RUN pecl install mongodb \
#     &&  echo "extension=mongodb.so" > $PHP_INI_DIR/conf.d/mongo.ini

# 安装 PHP 扩展和 Xdebug
RUN pecl install xdebug-2.9.8 \
    && docker-php-ext-enable xdebug


RUN apt-get update && apt-get install -y procps

RUN usermod -u 1000 www-data

WORKDIR /var/www/html
RUN chown -R www-data:www-data /var/www/html
USER www-data