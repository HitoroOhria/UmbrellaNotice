FROM ruby:2.5.1

ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-amd64

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
  && apt-get update \
  && apt-get install -y \
       build-essential \
       nodejs \
       openjdk-8-jdk

ADD . /umbrellanotice
WORKDIR /umbrellanotice
RUN mkdir -p tmp/sockets/task tmp/sockets/host log \
  && bundle install

CMD bundle exec unicorn_rails -c /umbrellanotice/config/unicorn.rb -E production