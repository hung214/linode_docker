# 使用PHP 8.1的官方镜像
FROM php:8.1-fpm
ARG TIMEZONE

# 安装必要的软件包
RUN apt-get update && apt-get install -y \
    openssl \
    git \
    zip \
    unzip \
    mariadb-client \
    vim \
    libzip-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    procps \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd zip mysqli pdo_mysql bcmath \
    && rm -r /var/lib/apt/lists/*

# 设置时区
RUN ln -snf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && echo ${TIMEZONE} > /etc/timezone
RUN printf '[PHP]\ndate.timezone = "%s"\n' ${TIMEZONE} > /usr/local/etc/php/conf.d/tzone.ini

# 安装Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer --version

# 安装并启用Redis扩展
RUN pecl install redis && docker-php-ext-enable redis

# 安装并启用Xdebug扩展
RUN pecl install xdebug && docker-php-ext-enable xdebug

# 配置Xdebug
RUN echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# 更新www-data用户UID
RUN usermod -u 1000 www-data

# 设置工作目录并调整权限
WORKDIR /var/www/html
RUN chown -R www-data:www-data /var/www/html
USER www-data
