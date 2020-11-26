FROM ubuntu:16.04

MAINTAINER Hassen BEN SLIMENE <h.slimen@autobiz.com>

# Install dependencies
ENV DEBIAN_FRONTEND noninteractive

# Set the locale
RUN apt-get clean \
 && apt-get update \
 && apt-get install locales \
 && locale-gen en_US.UTF-8

## Update locales
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Install tools software
RUN echo 'APT::Install-Recommends 0;' >> /etc/apt/apt.conf.d/01norecommends \
    && echo 'APT::Install-Suggests 0;' >> /etc/apt/apt.conf.d/01norecommends \
    && apt-get update -qq \
    && apt-get install -qqy \
        build-essential \
        software-properties-common \
        vim.tiny \
        vim \
        ca-certificates \
        curl \
        acl \
        sudo \
        wget \
        net-tools \
        make \
        unzip \
        git \
        ssh \
        python \
        cron \
        netcat

# Install supervisor
RUN apt-get update -qq \
    && apt-get install -qqy supervisor

COPY ubuntu/assets/supervisord.conf /etc/supervisor/supervisord.conf
CMD ["/usr/bin/supervisord", "-n"]

# Install gosu to launch container with right permissions
RUN gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.4/gosu-$(dpkg --print-architecture)" \
    && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.4/gosu-$(dpkg --print-architecture).asc" \
    && gpg --verify /usr/local/bin/gosu.asc \
    && rm /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu

# User file
RUN mkdir -p /data/home-files
COPY ubuntu/assets/home/ /data/home-files/

# Load binaries
COPY ubuntu/bin/entrypoint-ubuntu.sh /bin/entrypoint-ubuntu
RUN chmod +x /bin/entrypoint-ubuntu

####################
# Install PHP
####################
ENV PHP_VERSION 7.4

# Install PHP 7 repository
RUN apt-get update -qq \
    && apt-get install --no-install-recommends -qqy software-properties-common \
    && LANG=C.UTF-8 add-apt-repository ppa:ondrej/php -y \
    && add-apt-repository -y ppa:git-core/ppa \
    && apt-get purge -qqy software-properties-common

# Install PHP
RUN apt-get update -qq \
    && apt-get install -qqy \
        php${PHP_VERSION}-fpm \
        php${PHP_VERSION}-cli \
        php${PHP_VERSION}-json \
        php${PHP_VERSION}-intl \
        php${PHP_VERSION}-mysql \
        php-mcrypt \
        php${PHP_VERSION}-gd \
        php${PHP_VERSION}-sqlite3 \
        php${PHP_VERSION}-ldap \
        php${PHP_VERSION}-opcache \
        php${PHP_VERSION}-soap \
        php${PHP_VERSION}-zip \
        php${PHP_VERSION}-mbstring \
        php${PHP_VERSION}-bcmath \
        php${PHP_VERSION}-xmlrpc \
        php${PHP_VERSION}-xsl \
        php${PHP_VERSION}-bz2 \
        php${PHP_VERSION}-apcu \
        php${PHP_VERSION}-redis \
        php${PHP_VERSION}-memcached \
        php${PHP_VERSION}-xdebug \
        php${PHP_VERSION}-curl \
        php${PHP_VERSION}-imagick

# Configure PHP
RUN mkdir -p /run/php

# Load PHP config
COPY php/assets/php.ini /etc/php/${PHP_VERSION}/cli/php.ini
COPY php/assets/php.ini /etc/php/${PHP_VERSION}/fpm/php.ini
COPY php/assets/php-fpm.conf /etc/php/${PHP_VERSION}/fpm/php-fpm.conf
COPY php/assets/www.pool.conf /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf
COPY php/assets/20-xdebug.ini /etc/php/${PHP_VERSION}/cli/conf.d/20-xdebug.ini
COPY php/assets/20-xdebug.ini /etc/php/${PHP_VERSION}/fpm/conf.d/20-xdebug.ini

# Fix Binaries PHP
RUN rm -f /usr/bin/php \
    && ln -s /usr/bin/php${PHP_VERSION} /usr/bin/php \
    && ln -s /usr/sbin/php-fpm${PHP_VERSION} /usr/bin/php-fpm

# Load binaries
COPY php/bin/entrypoint-php.sh /bin/entrypoint-php
RUN chmod +x /bin/entrypoint-php

####################
# Install Nginx
####################
RUN apt-get update -qq \
    && apt-get install -qqy nginx \
    && rm -rf /etc/nginx/sites-available/* /etc/nginx/sites-enabled/*

COPY nginx/assets/nginx.conf /etc/nginx/nginx.conf
COPY nginx/assets/includes /etc/nginx/includes
COPY nginx/assets/vhosts /etc/nginx/sites-enabled

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
   && ln -sf /dev/stderr /var/log/nginx/error.log

# Load binaries
COPY nginx/bin/entrypoint-nginx.sh /bin/entrypoint-nginx
RUN chmod +x /bin/entrypoint-nginx

##############################

COPY entrypoint.sh /bin/entrypoint
RUN chmod +x /bin/entrypoint

EXPOSE 80
EXPOSE 443

ENTRYPOINT ["entrypoint"]
