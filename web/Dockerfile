FROM php:7.2-apache

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  git \
  libfreetype6-dev \
  libgd-dev \
  libmagickwand-dev  \
  libjpeg62-turbo-dev \
  libpng-dev \
  libtiff-dev \
  zip \
  zlib1g-dev

RUN a2enmod rewrite

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-install \
      bcmath \
      gd \
      mysqli \
      pdo \
      pdo_mysql \
      zip
RUN pecl install imagick && docker-php-ext-enable imagick

EXPOSE 80
