FROM ruby:2.7.1-alpine

ENV ENTRYKIT_VERSION 0.4.0
ENV JAVA_HOME        /usr/lib/jvm/java-11-openjdk
ENV PATH             $JAVA_HOME/bin:$PATH
ENV LD_LIBRARY_PATH  $JAVA_HOME/lib/server

RUN apk --update add \
       openssl \
  && rm -rf /var/cache/apk/* \
  && wget https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && tar -xvzf entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && rm entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && mv entrykit /bin/entrykit \
  && chmod +x /bin/entrykit \
  && entrykit --symlink \
  && apk add \
       alpine-sdk \
       nodejs \
       openjdk11 \
       mysql-client \
       mysql-dev

ADD ./docker/rails/aliases.sh /root/.profile

# copy dirctory for up container with no bind in CircleCI.
ADD . /rails-app
WORKDIR /rails-app

RUN bundle config set without 'production' \
  && bundle config set path 'vendor/bundle'

ENTRYPOINT [ \
  "switch", \
        "sidekiq=echo sleep 600 seconds for finish bunsle install. sleeping now Zzz...", "--", \
  "switch", \
        "sidekiq=sleep 600", "--", \
  "switch", \
        "sidekiq=bundle exec sidekiq -q sidekiq", "--", \
  "prehook", "bundle install", "--", \
  "prehook", "bundle exec rails db:create", "--", \
  "prehook", "bundle exec rails db:migrate", "--", \
  "switch", \
      "circleci=bundle exec unicorn_rails -c /rails-app/config/unicorn.rb -E development", "--", \
  "prehook", "bundle exec rails db:seed", "--", \
  "switch", \
        "light_mode=bundle exec rails s -p 80", "--", \
  "prehook", "development=bundle exec unicorn_rails -c /rails-app/config/unicorn.rb -E development", "--" \
]