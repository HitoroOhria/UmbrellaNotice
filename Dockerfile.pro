FROM ruby:2.5.1

RUN apt-get update \
  && apt-get install -y \
       build-essential \
       nodejs

ADD . /umbrellanotice
WORKDIR /umbrellanotice
RUN mkdir tmp tmp/sockets log \
  && bundle install

CMD unicorn_rails -c /umbrellanotice/config/unicorn.rb -E production