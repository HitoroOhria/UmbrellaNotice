FROM redis:alpine

COPY docker/redis/redis.conf /usr/local/etc/redis/redis.conf
RUN  mkdir -p /run/redis \
  && chown redis:redis /run/redis \
  && chmod 755 /run/redis

CMD [ "redis-server", "/usr/local/etc/redis/redis.conf" ]
