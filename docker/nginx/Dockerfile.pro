FROM nginx:1.15.8

RUN rm -f /etc/nginx/conf.d/*
ADD docker/nginx/nginx.pro.conf /etc/nginx/conf.d/umbrellanotice.conf

ADD docker/nginx/ca/server.key /etc/ssl/ca/server.key
ADD docker/nginx/ca/server.crt /etc/ssl/ca/server.crt

CMD /usr/sbin/nginx -g 'daemon off;' -c /etc/nginx/nginx.conf