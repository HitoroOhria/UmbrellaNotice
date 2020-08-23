FROM ruby:2.7.1

RUN apt-get update && apt-get install -y \
       build-essential \
       nodejs

RUN gem install rails -v 6.0.3.2 \
  && rails new sandbox
WORKDIR /sandbox
RUN echo "gem 'mysql2', '0.5.3'" >> Gemfile \
  && bundle install \
  && mkdir tmp/sockets \
  && rm -r config/database.yml
ADD config/database.yml config/database.yml
ADD db/migrate db/migrate
ADD db/schema.rb db/schema.rb
ADD docker/db_migrate/db_setup.sh db_setup.sh

CMD sh ./db_setup.sh