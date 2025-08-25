FROM node:18-alpine AS base
WORKDIR /usr/src/app
ENV NODE_ENV=production

COPY package.json ./
RUN npm install --omit=dev

COPY . .

EXPOSE 3000

CMD [ "node", "app.js" ]
