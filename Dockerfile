FROM debian:8

MAINTAINER Guilherme Fontenele <guilherme@fontenele.net>

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential apt-utils net-tools wget nginx php5-fpm git vim \
	curl libssh2-php php5-ssh2 php5-curl php5-intl php5-mcrypt php5-pgsql php5-sqlite nodejs npm git \ 
	apt-transport-https ca-certificates curl software-properties-common

RUN ln -s /usr/bin/nodejs /usr/bin/node
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN rm /etc/nginx/sites-enabled/default /etc/nginx/sites-available/default
ADD ./nginx.conf /etc/nginx/sites-available/default
RUN ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

RUN echo "cgi.fix_pathinfo = 0;" >> /etc/php5/fpm/php.ini
RUN sed -i 's/post_max_size = 8M/post_max_size = 16M/g' /etc/php5/fpm/php.ini
RUN sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 16M/g' /etc/php5/fpm/php.ini

RUN echo "service php5-fpm start" >> /root/.bashrc
RUN echo "service nginx start" >> /root/.bashrc
RUN echo "alias l='ls -la'" >> /root/.bashrc

RUN echo "syntax on" >> /root/.vimrc
RUN echo "set nu" >> /root/.vimrc

RUN apt-get autoremove -y
RUN apt-get clean

EXPOSE 80 443
