FROM node:14.9.0-alpine as NextBuilder

ADD . /next-app
WORKDIR /next-app

RUN yarn install \
  && yarn build

FROM node:14.9.0-alpine

COPY --from=NextBuilder /next-app/.next /var/www/next-app/.next

ADD package.json   /var/www/next-app/.next/package.json
ADD next.config.js /var/www/next-app/.next/next.config.js

CMD yarn start
