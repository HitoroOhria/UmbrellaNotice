FROM node:14.9.0-alpine

ENV ENTRYKIT_VERSION 0.4.0

RUN apk --update add \
       openssl \
  && wget https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && tar -xvzf entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && rm entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && mv entrykit /bin/entrykit \
  && chmod +x /bin/entrykit \
  && entrykit --symlink

RUN mkdir /next-app
WORKDIR /next-app

ENTRYPOINT [ \
  "prehook", "npm install", "--", \
  "prehook", "npm run dev", "--" \
]
