FROM ruby:2.5.1

ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-amd64

RUN apt-get update \
  && apt-get install -y \
       build-essential \
       nodejs \
       openjdk-8-jdk

ADD . /umbrellanotice
WORKDIR /umbrellanotice
RUN mkdir tmp tmp/sockets log \
  && bundle install

CMD unicorn_rails -c /umbrellanotice/config/unicorn.rb -E production