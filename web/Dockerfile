FROM php:7.2-apache

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  gifsicle \
  git \
  jpegoptim \
  optipng \
  pngquant \
  libgd-dev \
  zip

RUN a2enmod rewrite

RUN docker-php-ext-install \
      bcmath \
      gd \
      mysqli \
      pdo \
      pdo_mysql \
      zip

EXPOSE 80
