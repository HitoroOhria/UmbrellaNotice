FROM node:14.9.0-alpine as NextBuilder

ENV REACT_APP_AMPLIFY_REGION           $AWS_REGION
ENV REACT_APP_AMPLIFY_USER_POOL_ID     $REACT_APP_AMPLIFY_USER_POOL_ID
ENV REACT_APP_AMPLIFY_WEB_CLIENT_ID    $REACT_APP_AMPLIFY_WEB_CLIENT_ID
ENV REACT_APP_AMPLIFY_IDENTITY_POOL_ID $REACT_APP_AMPLIFY_IDENTITY_POOL_ID

ADD . /next-app
WORKDIR /next-app

RUN ls -al

# yarn failure on CircleCI environment.
RUN npm install \
  && npm run build

RUN ls -al

FROM node:14.9.0-alpine

COPY --from=NextBuilder /next-app/.next /var/www/next-app/.next

ADD package.json   /var/www/next-app/package.json
ADD next.config.js /var/www/next-app/next.config.json

WORKDIR /var/www/next-app

CMD npm run prod
