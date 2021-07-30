FROM node:stretch-slim
WORKDIR /forest-frontend
COPY . .
RUN apt update && apt install python build-essential -y
RUN npm i && npm run build
EXPOSE 3003

ENTRYPOINT [ "./docker-entrypoint.sh" ]