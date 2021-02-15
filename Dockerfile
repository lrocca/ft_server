# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: lrocca <marvin@42.fr>                      +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/02/13 16:18:26 by lrocca            #+#    #+#              #
#    Updated: 2021/02/15 12:35:54 by lrocca           ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM	debian:buster

# EXPOSE	80 443

RUN		apt update
RUN		apt upgrade -y

RUN		apt install -y wget nginx openssl php php-fpm php-mysql mariadb-server

RUN		openssl req -nodes -x509 -newkey rsa:2048 -keyout /etc/ssl/private/localhost.key -out /etc/ssl/certs/localhost.crt -days 365 -subj "/C=IT/ST=Lazio/L=Roma/O=42 Roma Luiss/OU=Org/CN=www.42roma.it"
RUN		openssl dhparam -out /etc/ssl/certs/dhparam.pem 1024

COPY	srcs/localhost /etc/nginx/sites-available
RUN		ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/
COPY	srcs/index.html /var/www/html/
RUN		rm /etc/nginx/sites-enabled/default

# RUN		wget -P /tmp https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-english.tar.gz
# RUN		mkdir /var/www/html/phpmyadmin
# RUN		tar -xvf /tmp/phpMyAdmin-latest-english.tar.gz -C /var/www/html/phpmyadmin --strip-components=1
# COPY	srcs/config.inc.php /var/www/html/phpmyadmin/

COPY	srcs/start.sh /

ENTRYPOINT	bash start.sh
