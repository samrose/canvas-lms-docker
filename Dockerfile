FROM ubuntu
CMD "sh" "-c" "echo nameserver 8.8.8.8 > /etc/resolv.conf"
RUN apt-get update
RUN apt-get install git -y
RUN apt-get -y upgrade

# PostgreSQL
RUN apt-get install -y postgresql-9.3
FROM library/postgres
ENV POSTGRES_USER canvas
ENV POSTGRES_PASSWORD canvas
ENV POSTGRES_DB canvas_production
ENV POSTGRES_DB canvas_queue_production


# Canvas User
RUN adduser canvas

# Copy Canvas
RUN git clone https://github.com/instructure/canvas-lms.git canvas
RUN mkdir -p /var/canvas
RUN chown -R sysadmin /var/canvas
RUN cp -av ./canvas/* /var/canvas

# Ruby
RUN apt-get install python-software-properties
RUN apt-add-repository ppa:brightbox/ruby-ng
RUN apt-get update
RUN apt-get install ruby2.1 ruby2.1-dev zlib1g-dev libxml2-dev libsqlite3-dev postgresql libpq-dev libxmlsec1-dev curl make g++
#RUN apt-get install ruby1.9.3 zlib1g-dev libxml2-dev libmysqlclient-dev libxslt1-dev imagemagick libpq-dev nodejs libxmlsec1-dev libcurl4-gnutls-dev libxmlsec1 build-essential openjdk-7-jre unzip

# Set Up Canvas
RUN gem install bundler
RUN sudo -u canvas bundle install --path vendor/bundle --without=sqlite

# NodeJS for Assets
RUN curl -sL https://deb.nodesource.com/setup_0.12 | sudo bash -
RUN apt-get install nodejs
