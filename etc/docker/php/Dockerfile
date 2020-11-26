FROM php:7.4-cli

ENV PHP_VERSION 7.4

RUN apt-get update
RUN apt-get install -y make libssl-dev libghc-zlib-dev libcurl4-gnutls-dev libexpat1-dev gettext unzip
RUN apt-get install -y git

# Load PHP config
COPY assets/php.ini /etc/php/${PHP_VERSION}/cli/php.ini
COPY assets/php.ini /etc/php/${PHP_VERSION}/fpm/php.ini

CMD ["php", "-a"]
