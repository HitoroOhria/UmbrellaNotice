FROM node:14.9.0-alpine as NextBuilder

ARG CIRCLE_SHA1
ARG REACT_APP_AMPLIFY_REGION
ARG REACT_APP_AMPLIFY_USER_POOL_ID
ARG REACT_APP_AMPLIFY_WEB_CLIENT_ID
ARG REACT_APP_AMPLIFY_IDENTITY_POOL_ID

ADD . /next-app
WORKDIR /next-app

# yarn failure on CircleCI environment.
RUN npm install \
  && npm run build

# FROM node:14.9.0-alpine

# COPY --from=NextBuilder /next-app/.next /var/www/next-app/.next

# ADD package.json      /var/www/next-app/package.json
# ADD package-lock.json /var/www/next-app/package-lock.json
# ADD next.config.js    /var/www/next-app/next.config.js

# WORKDIR /var/www/next-app

CMD npm run prodStart
