#service nginx stop (stop service sur VM)
FROM debian:buster

#install & update
RUN apt-get update
RUN apt-get upgrade
RUN apt-get install -y nginx mariadb-server php7.3-fpm php-mysqli openssl
ADD https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.tar.gz  .

#CONFIG NGINX USE PHP
RUN mkdir ./var/www/localhost
RUN chown -R $USER:$USER ./var/www/localhost
ADD ./srcs/localhost ./etc/nginx/sites-available/default
ADD ./srcs/localhost ./etc/nginx/sites-enabled/default
ADD ./srcs/info.php ./var/www/localhost/info.php
RUN rm -rf ./var/www/html

#CONFIG PHPMyAdmin
RUN mkdir ./var/www/localhost/phpmyadmin
RUN tar xzf phpMyAdmin-4.9.0.1-all-languages.tar.gz --strip-components=1 -C /var/www/localhost/phpmyadmin
RUN rm -f phpMyAdmin-4.9.0.1-all-languages.tar.gz
ADD ./srcs/database.sql .
RUN service mysql start && cat < database.sql | mariadb -u root
RUN rm -f database.sql

#CONFIG WORDPRESS
ADD https://wordpress.org/latest.tar.gz .
RUN tar xzvf latest.tar.gz
ADD ./srcs/wp-config.php ./var/www/localhost/wordpress/wp-config.php
RUN cp -a /wordpress/. /var/www/localhost/wordpress
RUN chown -R www-data:www-data /var/www/localhost
RUN rm -f latest.tar.gz
RUN rm -rf wordpress

#CONFIG SSL
RUN mkdir /etc/nginx/ssl
RUN openssl req -x509 -nodes -days 365 -config ./etc/ssl/openssl.cnf -subj "/CN=www.localhost" -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt

EXPOSE 80
EXPOSE 443

CMD service mysql start && service php7.3-fpm start && nginx -g "daemon off;"