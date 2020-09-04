FROM nginx:1.19.2-alpine

RUN rm -f /etc/nginx/conf.d/*
ADD docker/nginx/nginx.pro.conf /etc/nginx/conf.d/umbrellanotice.conf

RUN apk --update add \
        openssl \
  && mkdir /etc/ssl/ca \
  && cd /etc/ssl/ca \
  && openssl req -new -newkey rsa:2048 -keyout server.key -nodes -out server.csr -subj "/C=JP/ST=Fukushima/O=UmbrellaNotice/CN=www.umbrellanotice.work" \
  && openssl x509 -req -days 3650 -signkey server.key -in server.csr -out server.crt

CMD /usr/sbin/nginx -g 'daemon off;' -c /etc/nginx/nginx.conf