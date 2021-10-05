FROM nginx:1.20.1

ENV DEBIAN_FRONTEND=noninteractive

RUN nginx -v
RUN apt-get -y update && apt-get install -yq --no-install-recommends gnupg2 curl vim apt-transport-https lsb-release debian-archive-keyring ca-certificates wget zip unzip software-properties-common \
      libicu-dev \
      libpq-dev \
      libmcrypt-dev \
      libfreetype6-dev \
      libjpeg62-turbo-dev \
      libpng-dev \
      libwebp-dev \
      libgmp-dev \
      libxml2-dev \
      libxslt1-dev \
      libmemcached-dev \
      sendmail-bin \
      sendmail \
      libonig-dev \
      libldap2-dev \
      zlib1g-dev \
      libzip-dev \
      openssl \
      procps openssh-client openssh-server dnsutils net-tools \
      python \
      python-pip \
      python-setuptools

RUN pip install wheel && pip install supervisor

# Install PHP Extentions
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list

RUN apt-get -y update && apt-get install -y php7.4 php7.4-fpm php7.4-common php7.4-mysql php7.4-gmp php7.4-curl php7.4-intl php7.4-mbstring php7.4-xmlrpc php7.4-gd php7.4-xml php7.4-cli php7.4-zip php7.4-bcmath php7.4-soap php7.4-sockets

COPY configs/supervisord/supervisord.conf /etc/supervisord.conf
COPY configs/nginx/. /etc/nginx/.
COPY configs/php/. /etc/php/7.4/fpm/.

RUN useradd -ms /bin/bash --uid 1000 klovercloud
COPY app/. /home/klovercloud/app/.

RUN service php7.4-fpm start

RUN mkdir -p /var/run/nginx

RUN chown -R klovercloud:klovercloud /var/run/nginx && chmod -R 777 /var/run/nginx
RUN chown -R klovercloud:klovercloud /var/log && chmod -R 777 /var/log
RUN chown -R klovercloud:klovercloud /var/cache/nginx && chmod -R 777 /var/cache/nginx
RUN chown -R klovercloud:klovercloud /run/php && chmod -R 777 /run/php/

CMD /usr/local/bin/supervisord -n -c /etc/supervisord.conf
