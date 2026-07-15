FROM nginx:latest
COPY Website/ /usr/share/nginx/html
EXPOSE 80
CMD ["nginx","-g","daemon off;"]
