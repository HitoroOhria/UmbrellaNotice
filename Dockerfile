FROM ruby:2.5.1

ENV ENTRYKIT_VERSION 0.4.0
ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-amd64

RUN apt-get update \
  && apt-get install -y \
       openssl \
  && rm -rf /var/cache/apk/* \
  && wget https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && tar -xvzf entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && rm entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && mv entrykit /bin/entrykit \
  && chmod +x /bin/entrykit \
  && entrykit --symlink \
  && apt-get install -y \
       build-essential \
       nodejs \
       openjdk-8-jdk

ADD . /umbrellanotice
WORKDIR /umbrellanotice
RUN bundle install

ENTRYPOINT [ \
  "prehook", "bundle install", "--", \
  "prehook", "echo sleep 45 seconds for mysql Start Up Comprete", "--", \
  "prehook", "sleep 45", "--", \
  "prehook", "echo finish sleep", "--", \
  "prehook", "bundle exec rails db:create", "--", \
  "prehook", "bundle exec rails db:migrate", "--", \
  "prehook", "bundle exec rails db:seed", "--", \
  "prehook", "bundle exec unicorn_rails -c /umbrellanotice/config/unicorn.rb -E development", "--" \
]