FROM ubuntu

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update && apt-get -y install wget && apt-get -y install curl

# add dlang repository
RUN wget http://master.dl.sourceforge.net/project/d-apt/files/d-apt.list -O /etc/apt/sources.list.d/d-apt.list
RUN apt-get -y update
RUN apt-get -y --allow-unauthenticated install --reinstall d-apt-keyring
RUN apt-get -y update

# install dmd / dub / vibe.d dependencies
RUN apt-get -y install dub libcurl4-gnutls-dev libevent-dev libssl-dev

# install git
RUN apt-get -y install git

# install npm
RUN curl -sL https://deb.nodesource.com/setup_7.x | bash -
RUN apt-get -y install nodejs

# install stylus
RUN npm install stylus -g

RUN git clone https://github.com/Amaranthos/blogd-spaces.git /var/www/blogd-spaces
WORKDIR /var/www/blogd-spaces
RUN dub build

RUN chown -R www-data:www-data /var/www/blogd-spaces
RUN chmod +x /var/www/blogd-spaces
EXPOSE 8080
USER www-data

VOLUME /var/www/blogd-spaces
CMD ["/var/www/blogd-spaces/blogd-spaces"]
