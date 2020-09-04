FROM ruby:2.7.1-alpine

ENV ENTRYKIT_VERSION 0.4.0
ENV JAVA_HOME /usr/lib/jvm/java-11openjdk

RUN apk --update add \
       openssl \
  && rm -rf /var/cache/apk/* \
  && wget https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && tar -xvzf entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && rm entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && mv entrykit /bin/entrykit \
  && chmod +x /bin/entrykit \
  && entrykit --symlink \
#  && curl -sL https://deb.nodesource.com/setup_14.x | bash - \
  && apk add \
       alpine-sdk \
       nodejs \
       openjdk11

ADD ./docker/rails/aliases.sh /root/.profile

# copy dirctory for up container with no bind in CircleCI.
ADD . /rails-app
WORKDIR /rails-app

RUN bundle config set without 'production' \
  && bundle install

ENTRYPOINT [ \
  "prehook", "bundle install", "--", \
  "switch", \
      "sidekiq=bundle exec sidekiq -q sidekiq", "--", \
  "prehook", "echo Sleep 45 seconds for comprete MySQL start up.", "--", \
  "prehook", "sleep 45", "--", \
  "prehook", "echo Finish sleep.", "--", \
  "prehook", "bundle exec rails db:create", "--", \
  "prehook", "bundle exec rails db:migrate", "--", \
  "switch", \
      "circleci=bundle exec unicorn_rails -c /rails-app/config/unicorn.rb -E development", "--", \
  "prehook", "bundle exec rails db:seed", "--", \
  "switch", \
        "light_mode=bundle exec rails s -p 80", "--", \
  "prehook", "development=bundle exec unicorn_rails -c /rails-app/config/unicorn.rb -E development", "--" \
]