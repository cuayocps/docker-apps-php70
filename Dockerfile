FROM php:7.0-apache

RUN apt-get update && \
    apt-get install --fix-missing -y \
      g++ \
      git \
      vim \
      libgd-dev \
      libxml2 \
      libxml2-dev \
      libxslt-dev \
      libfreetype6-dev \
      mysql-client && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get autoremove -y && \
    apt-get clean all

RUN docker-php-ext-configure gd --with-freetype-dir=/usr
RUN docker-php-ext-install \
      mbstring \
      xsl \
      gd \
      exif \
      mysqli \
      pdo \
      pdo_mysql \
      zip \
      soap

RUN pecl install apc-3.1.13; \
  echo "extension=/usr/local/lib/php/extensions/no-debug-non-zts-20100525/apc.so" >> /usr/local/etc/php/conf.d/xdebug.ini

RUN pecl install channel://pecl.php.net/xdebug-2.7.2; \
  echo 'zend_extension = /usr/local/lib/php/extensions/no-debug-non-zts-20100525/xdebug.so' >> /usr/local/etc/php/php.ini; \
  touch /usr/local/etc/php/conf.d/xdebug.ini && \
    echo xdebug.remote_enable=1 >> /usr/local/etc/php/conf.d/xdebug.ini && \
    echo xdebug.remote_autostart=1 >> /usr/local/etc/php/conf.d/xdebug.ini && \
    echo xdebug.remote_connect_back=0 >> /usr/local/etc/php/conf.d/xdebug.ini && \
    echo xdebug.remote_host=docker.for.win.localhost >> /usr/local/etc/php/conf.d/xdebug.ini && \
    echo xdebug.remote_handler=dbgp >> /usr/local/etc/php/conf.d/xdebug.ini && \
    echo xdebug.remote_port=9000 >> /usr/local/etc/php/conf.d/xdebug.ini

RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

ENV PHP_TIMEZONE America/Santiago

RUN a2enmod rewrite