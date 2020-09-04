FROM nginx:1.19.2-alpine

RUN rm -f /etc/nginx/conf.d/*
ADD docker/nginx/nginx.conf /etc/nginx/conf.d/umbrellanotice.conf

RUN wget https://github.com/FiloSottile/mkcert/releases/download/v1.4.1/mkcert-v1.4.1-linux-amd64 \
  && chmod +x mkcert-v1.4.1-linux-amd64 \
  && mv mkcert-v1.4.1-linux-amd64 /usr/local/bin/mkcert \
  && mkdir /etc/ssl/ca \
  && cd /etc/ssl/ca \
  && mkcert -install \
  && mkcert localhost 127.0.0.1 \
  && mv localhost+1-key.pem localhost-key.pem \
  && mv localhost+1.pem localhost.pem \
  && chmod +r localhost-key.pem

CMD /usr/sbin/nginx -g 'daemon off;' -c /etc/nginx/nginx.conf
