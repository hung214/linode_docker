FROM nginx:alpine

COPY ./nginx.conf /etc/nginx/
COPY ./sites /etc/nginx/sites-available
RUN apk update \
    && apk upgrade \
    && apk add --no-cache bash \
    && adduser -D -H -u 1000 -s /bin/bash www-data -G www-data
CMD ["nginx"]