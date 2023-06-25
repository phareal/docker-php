FROM php:8.2-fpm

LABEL maintainer="POTCHONA Essosolam Justin <potchjust@gmail.com>"

USER root

# |--------------------------------------------------------------------------
# | User
# |--------------------------------------------------------------------------
# |
# | Define a default user with sudo rights.
# |

RUN useradd -ms /bin/bash docker && adduser docker sudo
# Users in the sudoers group can sudo as root without password.
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers




RUN apt-get update && apt-get install -y \
      wget \
      git \
      fish \
      net-tools \
      tzdata \
      golang-go





# install required  package
RUN apt-get update && apt-get install -y \
    libzip-dev \
    libicu-dev \
    libpq-dev


#install required dev pacakge
RUN apt-get update && docker-php-ext-install pdo \
    zip \
    intl \
    opcache \
    pdo_pgsql

RUN pecl install apcu \
    redis \
    xdebug


# enable package
RUN docker-php-ext-enable apcu \
    redis \
    xdebug


# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

# Symfony tool
RUN wget https://get.symfony.com/cli/installer -O - | bash && \
  mv /root/.symfony5/bin/symfony /usr/local/bin/symfony



# Xdebug (disabled by default, but installed if required)
# RUN pecl install xdebug-2.9.7 && docker-php-ext-enable xdebug
#ADD php.ini /usr/local/etc/php/conf.d/


#add start up command

# add start up commands feature
COPY utils/startup_commands.go /usr/local/bin/startup_commands.go

RUN go run /usr/local/bin/startup_commands.go


WORKDIR /var/www/html

EXPOSE 9000

USER docker
