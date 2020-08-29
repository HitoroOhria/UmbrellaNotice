FROM ruby:2.5.1

ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-amd64

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
  && apt-get update \
  && apt-get install -y \
       build-essential \
       nodejs \
       openjdk-8-jdk
ADD . /rails-app
WORKDIR /rails-app
RUN mkdir -p tmp/sockets/task tmp/sockets/host log \
  && bundle install --without development test

CMD sh /rails-app/docker/rails/production_set_up.sh