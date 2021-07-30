FROM node:alpine
WORKDIR /forest-frontend
COPY . .
RUN apk add python2
RUN apk add build-base
RUN yarn upgrade
RUN yarn install && NODE_ENV=production yarn build
EXPOSE 3003

ENTRYPOINT [ "./docker-entrypoint.sh" ]
