# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: lrocca <marvin@42.fr>                      +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/02/13 16:18:26 by lrocca            #+#    #+#              #
#    Updated: 2021/02/17 20:06:15 by lrocca           ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM	debian:buster

EXPOSE	80 443

RUN		apt update
RUN		apt upgrade -y

RUN		apt install -y wget nginx openssl php php-fpm php-mysql mariadb-server

RUN		openssl req -nodes -x509 -newkey rsa:2048 -keyout /etc/ssl/localhost.key -out /etc/ssl/localhost.crt -days 365 -subj "/C=IT/ST=Roma/L=Roma/O=42/OU=Org/CN=ft_server"

# nginx
COPY	srcs/localhost.conf /etc/nginx/sites-available
RUN		ln -s /etc/nginx/sites-available/localhost.conf /etc/nginx/sites-enabled/
COPY	srcs/ft_server.html /var/www/html/
RUN		rm /etc/nginx/sites-enabled/default
RUN		rm /var/www/html/index.nginx-debian.html
ENV		AUTOINDEX "on"

# phpMyAdmin
RUN		wget -P /tmp https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-english.tar.xz
RUN		mkdir /var/www/html/phpmyadmin
RUN		tar -xvf /tmp/phpMyAdmin-latest-english.tar.xz -C /var/www/html/phpmyadmin --strip-components=1
COPY	srcs/config.inc.php /var/www/html/phpmyadmin/

# WordPress
RUN		wget -P /tmp https://wordpress.org/latest.tar.gz
RUN		mkdir /var/www/html/wordpress
RUN		tar -xvf /tmp/latest.tar.gz -C /var/www/html/wordpress --strip-components=1
COPY	srcs/wp-config.php /var/html/wordpress/
COPY	srcs/wordpress.sql /tmp
RUN		service mysql start && mysql -u root < /tmp/wordpress.sql

COPY	srcs/start.sh /

ENTRYPOINT	bash start.sh
