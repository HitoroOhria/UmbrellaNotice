FROM nginx:1.15.8

RUN rm -f /etc/nginx/conf.d/*
ADD docker/nginx/nginx.pro.conf /etc/nginx/conf.d/umbrellanotice.conf

ADD docker/nginx/ca/server.key /etc/ssl/ca/server.key
ADD docker/nginx/ca/server.crt /etc/ssl/ca/server.crt

# ADD docker/nginx/ca/csr_create.sh /etc/ssl/ca/csr_create.sh
# RUN apt-get update \
#   && apt-get install -y \
#        openssl \
#        expect \
#   && cd /etc/ssl/ca \
#   && openssl genrsa -out server.key 2024 \
#   && ./csr_create.sh \
#   && ls -l \
#   && openssl x509 -req -days 3650 -signkey server.key -in server.csr -out server.crt

CMD /usr/sbin/nginx -g 'daemon off;' -c /etc/nginx/nginx.conf