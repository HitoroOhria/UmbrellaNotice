FROM ruby:2.7.1-alpine

ENV JAVA_HOME        /usr/lib/jvm/java-11-openjdk
ENV PATH             $JAVA_HOME/bin:$PATH
ENV LD_LIBRARY_PATH  $JAVA_HOME/lib/server

RUN apk --update add \
      alpine-sdk \
      nodejs \
      yarn \
      mysql-client \
      mysql-dev

RUN gem install 'rails:6.0.3.2' 'mysql2:0.5.3' \
  && rails new sandbox --database=mysql --skip-test  --skip-turbolinks --skip-bundle --api

WORKDIR /sandbox
RUN rm -r Gemfile config/database.yml

ADD docker/db_migrate/Gemfile     Gemfile
ADD config/database.yml           config/database.yml
ADD db/migrate                    db/migrate
ADD db/schema.rb                  db/schema.rb
ADD docker/db_migrate/db_setup.sh db_setup.sh

RUN bundle config set without 'development test' \
  && bundle install \
  && mkdir tmp/sockets

CMD sh ./db_setup.sh