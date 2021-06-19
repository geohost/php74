FROM ubuntu:groovy-20210614
LABEL maintainer="George Draghici <george@geohost.ro>"

# Setting frontend Noninteractive
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Avoid ERROR: invoke-rc.d: policy-rc.d denied execution of start.
RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d

# Install supervisor, mysql-client, php-fpm, composer
RUN apt update ; \
    apt install -y \
    build-essential \
    software-properties-common ; \
    apt-get update ; \
    apt-get install -y \
    wget \
    nano \
    curl \
    unzip \
    php-redis \
    php7.4-cli \
    php7.4-fpm \
    php7.4-bz2 \
    php7.4-bcmath \
    php7.4-curl \
    php7.4-gd \
    php7.4-json \
    php7.4-mbstring \
    php7.4-xml \
    php7.4-xmlrpc \
    php7.4-zip \
    php7.4-opcache \
    php7.4-cgi \
    php7.4-xml \
    php7.4-mysql \
    php7.4-pgsql \
    php7.4-imagick \
    php7.4-soap \
    libmysqlclient-dev \
    mysql-client \
    imagemagick \
    mailutils \
    net-tools \
    supervisor \
    cron

# Install PHP mcyrpt module
RUN apt install php-dev libmcrypt-dev gcc make autoconf libc-dev pkg-config php-pear -y
RUN pecl channel-update pecl.php.net
RUN yes "" | pecl install mcrypt
RUN echo "extension=mcrypt.so" | tee -a /etc/php/7.4/fpm/conf.d/mcrypt.ini

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


# Copy php.ini file
ADD conf/php/php.ini /etc/php/7.4/fpm/php.ini
RUN mkdir -p /var/log/php
RUN touch /var/log/php/php-error.log && chown -R www-data:www-data /var/log/php

#Create docroot directory , copy code and Grant Permission to docroot
RUN mkdir -p /app
RUN chown -R www-data:www-data /app

ADD conf/php/www.conf /etc/php/7.4/fpm/pool.d/www.conf
ADD conf/supervisord.conf /etc/supervisor/supervisord.conf


# Enable www-data user shell
RUN chsh -s /bin/bash www-data

# Clean
RUN apt remove -y \
    build-essential

EXPOSE 9000

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

CMD ["/docker-entrypoint.sh"]
