FROM ruby:2.5.1

RUN apt-get update \
  && apt-get install -y \
       build-essential \
       nodejs

RUN mkdir /umbrellanotice
WORKDIR /umbrellanotice
ADD . /umbrellanotice
RUN mkdir tmp tmp/sockets log
RUN bundle install

CMD unicorn_rails -c /umbrellanotice/config/unicorn.rb -E production