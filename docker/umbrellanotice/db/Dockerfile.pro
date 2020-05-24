FROM ruby:2.5.1

RUN apt-get update \
  && apt-get install -y \
       build-essential \
       nodejs

RUN gem install rails -v 5.2.4 \
  && rails new sandbox
WORKDIR /sandbox
RUN echo "gem 'mysql2', '0.5.3'" >> Gemfile \
  && bundle install \
  && mkdir tmp/sockets \
  && rm -r config/database.yml
ADD config/database.yml config/database.yml
ADD db/migrate db/migrate
ADD docker/umbrellanotice/db/db_migrate.sh db_migrate.sh

CMD sh ./db_migrate.sh