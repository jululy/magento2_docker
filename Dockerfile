FROM php:7.1.23-fpm-alpine3.8

RUN  echo 'http://mirrors.aliyun.com/alpine/v3.8/main/'> /etc/apk/repositories && \
	 echo 'http://mirrors.aliyun.com/alpine/v3.8/community/'>> /etc/apk/repositories 

RUN apk add shadow

RUN usermod -u 1000  -d /home/www-data -s /bin/bash  www-data \
   && chown -Rf www-data:www-data /var/www
   
RUN apk update && apk upgrade

RUN  apk add  libjpeg jpeg-dev libpng libpng-dev freetype freetype-dev icu-dev icu  libxslt libxslt-dev libmcrypt libmcrypt-dev php7-dev build-base

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

RUN  docker-php-ext-install intl pdo_mysql xsl zip soap bcmath  mcrypt opcache

#RUN pecl install igbinary &&  pecl install redis
RUN  pecl install redis && docker-php-ext-enable redis

#RUN  docker-php-ext-enable igbinary redis

ADD ./magento.ini   /usr/local/etc/php/conf.d/

#install composer
RUN php -r"copy('https://getcomposer.org/installer','composer-setup.php');" \
	&& php composer-setup.php --install-dir=/usr/bin --filename=composer 
	
RUN chmod a+x /usr/bin/composer
