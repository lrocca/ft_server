# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: lrocca <marvin@42.fr>                      +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/02/13 16:18:26 by lrocca            #+#    #+#              #
#    Updated: 2021/02/19 15:54:00 by lrocca           ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM	debian:buster

EXPOSE	80 443

RUN		apt-get update
RUN		apt-get upgrade -y
RUN		apt-get install -y wget nginx openssl php7.3-fpm php-mysql php-mbstring mariadb-server

RUN		openssl req -nodes -x509 -newkey rsa:2048 -keyout /etc/ssl/localhost.key -out /etc/ssl/localhost.crt -days 365 -subj "/C=IT/ST=Roma/L=Roma/O=lrocca@42/OU=Org/CN=ft_server"

# nginx
COPY	srcs/localhost.conf /etc/nginx/sites-available
RUN		ln -s /etc/nginx/sites-available/localhost.conf /etc/nginx/sites-enabled/
RUN		rm /etc/nginx/sites-enabled/default /var/www/html/index.nginx-debian.html
COPY	srcs/index.html srcs/404.html/ var/www/html/

# phpinfo
RUN		echo "<?php phpinfo(); ?>" >> /var/www/html/info.php

# phpMyAdmin
RUN		wget -P /tmp https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-english.tar.xz
RUN		mkdir /var/www/html/phpmyadmin
RUN		tar -xvf /tmp/phpMyAdmin-latest-english.tar.xz -C /var/www/html/phpmyadmin --strip-components=1
COPY	srcs/config.inc.php /var/www/html/phpmyadmin/

# WordPress
RUN		wget -P /tmp https://wordpress.org/latest.tar.gz
RUN		mkdir /var/www/html/wordpress
RUN		tar -xvf /tmp/latest.tar.gz -C /var/www/html/wordpress --strip-components=1
COPY	srcs/wp-config.php /var/www/html/wordpress/
COPY	srcs/wordpress.sql srcs/dump.sql /tmp
RUN		service mysql start && mysql -u root < /tmp/wordpress.sql && mysql -u root wordpress < /tmp/dump.sql

RUN		rm tmp/phpMyAdmin-latest-english.tar.xz tmp/latest.tar.gz tmp/wordpress.sql tmp/dump.sql
COPY	srcs/start.sh srcs/autoindex.sh /
ENTRYPOINT	bash start.sh
