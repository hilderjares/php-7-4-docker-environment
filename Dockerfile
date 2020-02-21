############################## BASE #####################################
FROM ubuntu:latest as base

RUN apt-get update \
    && apt-get -y install software-properties-common \
    && add-apt-repository ppa:ondrej/php

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -y install tzdata

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install \
    apache2 \
    php7.4 \
    php7.4-cli \
    libapache2-mod-php7.4 \
    php7.4-gd \
    php7.4-curl \
    php7.4-json \
    php7.4-mbstring \
    php7.4-mysql \
    php7.4-xml \
    php7.4-xsl \
    php7.4-zip

############################ DEPENDENCIES ###############################
FROM base as dependencies  

RUN apt-get -y install curl
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

############################## CLI #######################################
FROM dependencies as cli

COPY . /var/www/

RUN composer init
RUN composer install

############################ SERVER ######################################
FROM base

RUN a2enmod php7.4
RUN a2enmod rewrite

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

COPY php.ini /etc/php/7.4/apache2/php.ini

ADD app.conf /etc/apache2/sites-enabled/000-default.conf

EXPOSE 80

CMD /usr/sbin/apache2ctl -D FOREGROUND