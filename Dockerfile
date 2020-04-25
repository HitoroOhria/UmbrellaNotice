FROM ruby:2.5.1

RUN apt-get update -qq && \
    apt-get install -y build-essential \
                       nodejs

RUN mkdir /umbrellanotice
WORKDIR /umbrellanotice

ADD Gemfile /umbrellanotice/Gemfile
ADD Gemfile.lock /umbrellanotice/Gemfile.lock

RUN bundle install

ADD . /umbrellanotice

RUN mkdir -p tmp/sockets
