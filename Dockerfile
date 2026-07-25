FROM nginx:latest
COPY Website/ /usr/share/nginx/html
EXPOSE 80
CMD ["nginx","-g","daemon off;"]
FROM nginx:alpine

RUN apk add --no-cache gettext

COPY Website/ /usr/share/nginx/html/

COPY docker/40-generate-config.sh /docker-entrypoint.d/40-generate-config.sh

RUN chmod +x /docker-entrypoint.d/40-generate-config.sh

EXPOSE 80
