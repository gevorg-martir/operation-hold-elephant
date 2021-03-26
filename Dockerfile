# build stage
FROM node:12-alpine as buildfront
WORKDIR /app
COPY . .
RUN npm ci && npm run build

# prod stage
FROM nginx:1-alpine
COPY nginx.conf /etc/nginx/
WORKDIR /usr/share/nginx/html
COPY --from=buildfront /app/dist .
HEALTHCHECK CMD [ "wget", "-q", "--spider", "localhost/system-status" ]
EXPOSE 80
