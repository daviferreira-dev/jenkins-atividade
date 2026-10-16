FROM node:22-alpine
WORKDIR /app
COPY package.json ./
COPY src ./src
ARG BUILD_TAG=dev
ENV BUILD_TAG=$BUILD_TAG PORT=3000
USER node
EXPOSE 3000
CMD ["node", "src/server.js"]
