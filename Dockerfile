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
  echo "extension=/usr/local/lib/php/extensions/no-debug-non-zts-20151012/apc.so" >> /usr/local/etc/php/php.ini

RUN pecl install channel://pecl.php.net/xdebug-2.7.2; \
  echo 'zend_extension = /usr/local/lib/php/extensions/no-debug-non-zts-20151012/xdebug.so' >> /usr/local/etc/php/php.ini

RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

ENV PHP_TIMEZONE America/Santiago

RUN a2enmod rewrite