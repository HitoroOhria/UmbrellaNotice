FROM ruby:2.7.1

ENV JAVA_HOME /usr/lib/jvm/java-1.11.0-openjdk-amd64

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
  && apt-get update \
  && apt-get install -y \
       build-essential \
       nodejs \
       openjdk-11-jdk

ADD . /rails-app
WORKDIR /rails-app
RUN mkdir -p tmp/sockets/task tmp/sockets/host log \
  && bundle install --without development test

CMD bundle exec unicorn_rails -c /umbrellanotice/config/unicorn.rb -E production