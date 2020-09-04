FROM ruby:2.7.1-alpine

RUN apk --update add \
       alpine-sdk \
       nodejs \
       yarn

RUN gem install 'rails:6.0.3.2' 'mysql2:0.5.3' \
  && rails new sandbox --database=mysql --skip-test  --skip-turbolinks --skip-bundle --api

WORKDIR /sandbox

RUN bundle config set without 'development test' \
  && bundle install \
  && mkdir tmp/sockets \
  && rm -r config/database.yml

ADD config/database.yml           config/database.yml
ADD db/migrate                    db/migrate
ADD db/schema.rb                  db/schema.rb
ADD docker/db_migrate/db_setup.sh db_setup.sh

CMD sh ./db_setup.sh