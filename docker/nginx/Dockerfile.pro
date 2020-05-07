FROM nginx:1.15.8

# openssl.cnf - 環境変数
ENV EMAIL $EMAIL
ENV PREFECTURE $PREFECTURE
ENV CITY $CITY

RUN rm -f /etc/nginx/conf.d/*
ADD docker/nginx/nginx.pro.conf /etc/nginx/conf.d/umbrellanotice.conf

ADD docker/nginx/ca/server.key /etc/ssl/ca/server.key
ADD docker/nginx/ca/server.crt /etc/ssl/ca/server.crt
RUN apt-get update \
  && apt-get install -y \
   openssl

CMD /usr/sbin/nginx -g 'daemon off;' -c /etc/nginx/nginx.conf