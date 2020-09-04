FROM ruby:2.7.1-alpine

ENV JAVA_HOME /usr/lib/jvm/java-11openjdk/
ENV PATH      $JAVA_HOME/bin:$PATH

RUN apk --update add \
         openssl \
         alpine-sdk \
         nodejs \
         openjdk11 \
         mysql-client \
         mysql-dev

ADD . /rails-app
WORKDIR /rails-app
RUN mkdir -p tmp/sockets/task tmp/sockets/host log \
  && bundle config set without 'development test' \
  && bundle install

CMD bundle exec unicorn_rails -c /rails-app/config/unicorn.rb -E production