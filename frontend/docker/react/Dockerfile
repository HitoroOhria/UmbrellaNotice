FROM node:14.7.0

ENV ENTRYKIT_VERSION 0.4.0

RUN apt update \
  && apt install -y \
       openssl \
  && wget https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && tar -xvzf entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && rm entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && mv entrykit /bin/entrykit \
  && chmod +x /bin/entrykit \
  && entrykit --symlink \
  && apt install -y \
       yarn

ADD . /react-app
WORKDIR /react-app

ENTRYPOINT [ \
  "prehook", "yarn", "--", \
  "prehook", "yarn start", "--" \
]
